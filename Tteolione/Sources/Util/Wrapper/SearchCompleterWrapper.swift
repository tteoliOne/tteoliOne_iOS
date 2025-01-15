//
//  SearchCompleterWrapper.swift
//  Tteolione
//
//  Created by 전준영 on 1/15/25.
//

import MapKit
import RxSwift

final class SearchCompleterWrapper: NSObject, MKLocalSearchCompleterDelegate {
    
    private let searchCompleter = MKLocalSearchCompleter()
    private let resultsSubject = PublishSubject<[MKLocalSearchCompletion]>()
    private let errorSubject = PublishSubject<Error>()

    private let koreaRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
    )

    var results: Observable<[MKLocalSearchCompletion]> {
        return resultsSubject.asObservable()
    }
    
    var error: Observable<Error> {
        return errorSubject.asObservable()
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.region = koreaRegion
    }
    
    func updateQuery(_ query: String) {
        searchCompleter.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        resultsSubject.onNext(completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        errorSubject.onNext(error)
    }
    
    func createSearchRequest(for completion: MKLocalSearchCompletion) -> MKLocalSearch.Request {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        searchRequest.region = koreaRegion
        return searchRequest
    }
}

