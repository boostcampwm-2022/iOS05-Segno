//
//  LocationSession.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/08.
//

import CoreLocation
import Foundation

import RxSwift

protocol LocationRepository {
    var locationSubject: PublishSubject<Location> { get set }
    var addressSubject: PublishSubject<String> { get set }
    var errorStatus: PublishSubject<LocationError> { get set }
    var errorObservable: Observable<LocationError> { get }
    func getAddress(by location: Location)
    func getAddress(location: CLLocation)
    func getLocation()
    func stopLocation()
}

final class LocationRepositoryImpl: NSObject, LocationRepository {
    var locationSubject = PublishSubject<Location>()
    var addressSubject = PublishSubject<String>()
    var errorStatus = PublishSubject<LocationError>()
    
    var errorObservable: Observable<LocationError> {
        errorStatus.asObservable()
    }
    
    var locationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    private var locationManager = CLLocationManager()
    
    override init() {
        
    }
    
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                debugPrint("위치 서비스 on")
                self.locationManager.requestLocation()
            } else {
                debugPrint("위치 서비스 off 상태")
                self.errorStatus.onNext(.restricted)
                
            }
        }
    }
    
    func stopLocation() {
        DispatchQueue.global().async {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func getAddress(by location: Location) {
        let cllocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        getAddress(location: cllocation)
    }
    
    func getAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            guard let placemarks = placemarks,
                  let address = placemarks.last else { return }
//            debugPrint("description : ", address.description)
            let fullAddress = address.description.components(separatedBy: ", ")[1]
            let array = Array(fullAddress.components(separatedBy: " ").dropFirst())
            let refinedAddress = array.joined(separator: " ")
            debugPrint("변환된 주소값 : ", refinedAddress)
            
            self.addressSubject.onNext(refinedAddress)
        }
    }
}

extension LocationRepositoryImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let cllocation = locations.first {
            let location = Location(latitude: cllocation.coordinate.latitude, longitude: cllocation.coordinate.longitude)
            getAddress(location: cllocation)
            locationSubject.onNext(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("didFailWithError")
        debugPrint("현재 권한 상태 : ", locationStatus.rawValue)
        switch locationStatus {
        case .restricted:
            errorStatus.onNext(.restricted)
        case .denied:
            errorStatus.onNext(.denied)
        default:
            getLocation()
        }
    }
}
