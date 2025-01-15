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
        case selectSearchResult(MKLocalSearchCompletion)
        case updateSearchResults([MKLocalSearchCompletion])
    }
    
    enum Mutation {
        case setSearchResults([MKLocalSearchCompletion])
        case setSelectedLocation(String, String, Double, Double)
    }
    
    struct State {
        var searchResults: [MKLocalSearchCompletion] = []
        var selectedLocation: (name: String,
                               address: String,
                               latitude: Double,
                               longitude: Double)? = nil
    }
    
    private let searchCompleterWrapper = SearchCompleterWrapper()
    private let disposeBag = DisposeBag()
    let initialState: State = State()
    
    init() {
        searchCompleterWrapper.results
            .map { Action.updateSearchResults($0) }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        searchCompleterWrapper.error
            .bind { error in
                print("error: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
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
            
        case .updateSearchResults(let results):
            return .just(.setSearchResults(results))
            
        case .selectSearchResult(let completion):
            let searchRequest = createSearchRequest(for: completion)
            return Observable.create { observer in
                let localSearch = MKLocalSearch(request: searchRequest)
                localSearch.start { response, error in
                    guard let place = response?.mapItems.first, error == nil else { return }
                    observer.onNext(.setSelectedLocation(
                        place.name ?? "",
                        place.placemark.title ?? "",
                        place.placemark.coordinate.latitude,
                        place.placemark.coordinate.longitude
                    ))
                    observer.onCompleted()
                }
                return Disposables.create()
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
            
        case let .setSelectedLocation(name, address, latitude, longitude):
            newState.selectedLocation = (name, address, latitude, longitude)
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
    
}
