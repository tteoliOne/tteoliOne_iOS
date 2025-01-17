//
//  AddressReactor.swift
//  Tteolione
//
//  Created by 전준영 on 1/14/25.
//

import ReactorKit
import RxSwift
import MapKit

final class AddressReactor: Reactor {
    
    enum Action {
        case updateSearchWord(String)
        case myLocationButtonTap
        case selectSearchResult(MKLocalSearchCompletion)
        case updateSearchResults([MKLocalSearchCompletion])
    }
    
    enum Mutation {
        case setSearchResults([MKLocalSearchCompletion])
        case setSelectedLocation(Bool)
        case showError(String)
    }
    
    struct State {
        var searchResults: [MKLocalSearchCompletion] = []
        var isLocationSelected: Bool = false
        var errorMessage: String?
    }
    
    private let searchCompleterWrapper = SearchCompleterWrapper()
    private var locationManagerDelegate: LocationManagerDelegate?
    private let locationManager = CLLocationManager()
    private let ud: UserDefaultsManager
    private let disposeBag = DisposeBag()
    let initialState: State = State()
    
    init(ud: UserDefaultsManager) {
        self.ud = ud
        
        searchCompleterWrapper.results
            .map { Action.updateSearchResults($0) }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        searchCompleterWrapper.error
            .bind { error in
                print("Search Completer Error: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
        
        locationManager.requestWhenInUseAuthorization()
    }
}

extension AddressReactor {
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateSearchWord(let searchText):
            if searchText.isEmpty {
                return .just(.setSearchResults([]))
            } else {
                searchCompleterWrapper.updateQuery(searchText)
                return .empty()
            }
            
        case .myLocationButtonTap:
            let authorizationStatus = CLLocationManager.authorizationStatus()
            if authorizationStatus == .denied || authorizationStatus == .restricted {
                return .just(.showError("위치 권한이 비활성화되어 있습니다. 설정에서 권한을 활성화해주세요."))
            } else if authorizationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
                return .empty()
            } else {
                self.locationManagerDelegate = LocationManagerDelegate(
                    success: { [weak self] location in
                        guard let self = self else { return }
                        print("aaaaa: \(location.coordinate.latitude), bbbbb: \(location.coordinate.longitude)")
                        self.saveLocationToUserDefaults(latitude: location.coordinate.latitude,
                                                        longitude: location.coordinate.longitude)
                    },
                    failure: { error in
                        print("위치 가져오기 실패: \(error.localizedDescription)")
                    }
                )
                self.locationManager.delegate = self.locationManagerDelegate
                self.locationManager.requestLocation()
                
                return .concat([
                    .just(.setSelectedLocation(true)),
                    .just(.setSelectedLocation(false))
                ])
            }
            
        case .updateSearchResults(let results):
            return .just(.setSearchResults(results))
            
        case .selectSearchResult(let completion):
            let searchRequest = createSearchRequest(for: completion)
            let localSearch = MKLocalSearch(request: searchRequest)
            
            return Observable<Mutation>.create { observer in
                localSearch.start { response, error in
                    guard let place = response?.mapItems.first, error == nil else {
                        observer.onError(NSError(domain: "AddressError", code: -1, userInfo: [NSLocalizedDescriptionKey: "위치를 가져올 수 없습니다."]))
                        return
                    }
                    
                    self.saveLocationToUserDefaults(latitude: place.placemark.coordinate.latitude,
                                                    longitude: place.placemark.coordinate.longitude)
                    observer.onNext(.setSelectedLocation(true))
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            .flatMap { _ in
                Observable.concat([
                    .just(.setSelectedLocation(true)),
                    .just(.setSelectedLocation(false))
                ])
            }
            
        }
    }
}

extension AddressReactor {
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSearchResults(let results):
            newState.searchResults = results
            
        case .setSelectedLocation(let isSelected):
            newState.isLocationSelected = isSelected
            
        case .showError(let errorMessage):
            newState.errorMessage = errorMessage
        }
        
        return newState
    }
}

extension AddressReactor {
    
    private func createSearchRequest(for completion: MKLocalSearchCompletion) -> MKLocalSearch.Request {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        searchRequest.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
            span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        )
        return searchRequest
    }
    
    private func saveLocationToUserDefaults(latitude: Double, longitude: Double) {
        ud.latitude = latitude
        ud.longitude = longitude
    }
}
