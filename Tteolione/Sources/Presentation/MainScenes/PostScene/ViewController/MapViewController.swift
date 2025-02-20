//
//  MapViewController.swift
//  Tteolione
//
//  Created by 전준영 on 1/24/25.
//

import UIKit
import MapKit
import ReactorKit

final class MapViewController: BaseViewController<MapView> {
    
    var disposeBag = DisposeBag()
    weak var delegate: PostCoordinatorDelegate?
    weak var delegates: MapViewControllerDelegate?
    
    func completeSelection() {
        let centerCoordinate = rootView.mapView.centerCoordinate
        delegates?.didSelectLocation(latitude: centerCoordinate.latitude,
                                     longitude: centerCoordinate.longitude)
    }
    
    func handleLocationSelection(latitude: Double,
                                 longitude: Double) {
        delegates?.didSelectLocation(latitude: latitude,
                                     longitude: longitude)
    }
    
}

extension MapViewController: View {
    
    func bind(reactor: MapReactor) {
        //        bindAction(reactor)
        //        bindNavigation(reactor)
    }
    
}

extension MapViewController: DelegateOwner {
    typealias Delegate = PostCoordinatorDelegate
}
