//
//  MapView.swift
//  Tteolione
//
//  Created by 전준영 on 1/24/25.
//

import UIKit
import SnapKit
import MapKit

protocol MapViewControllerDelegate: AnyObject {
    func didSelectLocation(latitude: Double, longitude: Double)
}

final class MapView: BaseView {
    
    private let locationManager = CLLocationManager()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "공유장소 검색하기"
        return searchBar
    }()
    
    private let centerMarker: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    override func configureHierarchy() {
        [mapView, searchBar,
         centerMarker].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        centerMarker.snp.makeConstraints { make in
            make.center.equalTo(mapView)
            make.size.equalTo(32)
        }
    }
    
    override func configureView() {
        setupMap()
        bindActions()
        
    }
}

extension MapView {
    
    private func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let location = locationManager.location {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
            mapView.setRegion(MKCoordinateRegion(center: center,
                                                 latitudinalMeters: 1000,
                                                 longitudinalMeters: 1000),
                              animated: true)
        }
    }
    
    private func bindActions() {
        searchBar.delegate = self
    }
    
}

extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        mapView.setRegion(MKCoordinateRegion(center: center,
                                             latitudinalMeters: 1000,
                                             longitudinalMeters: 1000),
                          animated: true)
        manager.stopUpdatingLocation()
    }
}

extension MapView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let self = self, let response = response else { return }
            
            if let mapItem = response.mapItems.first {
                let coordinate = mapItem.placemark.coordinate
                mapView.setRegion(MKCoordinateRegion(center: coordinate,
                                                     latitudinalMeters: 1000,
                                                     longitudinalMeters: 1000),
                                  animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = mapItem.name
                mapView.addAnnotation(annotation)
            }
        }
    }
    
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        let latitude = annotation.coordinate.latitude
        let longitude = annotation.coordinate.longitude
        
        if let parentVC = self.parentViewController as? MapViewController {
            parentVC.handleLocationSelection(latitude: latitude, longitude: longitude)
        }
    }
}
