//
//  LocationManagerDelegate.swift
//  Tteolione
//
//  Created by 전준영 on 1/17/25.
//

import CoreLocation

final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    private let successHandler: (CLLocation) -> Void
    private let failureHandler: (Error) -> Void
    
    init(success: @escaping (CLLocation) -> Void, failure: @escaping (Error) -> Void) {
        self.successHandler = success
        self.failureHandler = failure
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        successHandler(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorMessage: String
        switch (error as NSError).code {
        case CLError.locationUnknown.rawValue:
            errorMessage = "위치를 확인할 수 없습니다. 잠시 후 다시 시도해주세요."
        case CLError.denied.rawValue:
            errorMessage = "위치 권한이 거부되었습니다. 설정에서 권한을 활성화해주세요."
        default:
            errorMessage = "위치를 가져오는 중 문제가 발생했습니다."
        }
        failureHandler(NSError(domain: "LocationError", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
    }
}
