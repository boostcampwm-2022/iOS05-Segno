//
//  LocationUseCaseTest.swift
//  SegnoTests
//
//  Created by YOONJONG on 2022/12/15.
//

import XCTest
import CoreLocation

import RxSwift
import RxTest

@testable import Segno

final class LocationUseCaseTest: XCTestCase {
    
    final class StubRepository: LocationRepository {
        var locationSubject: PublishSubject<Location>
        var addressSubject: PublishSubject<String>
        var errorStatus: PublishSubject<LocationError>
        var errorObservable: Observable<LocationError> {
            errorStatus.asObservable()
        }
        
        init() {
            locationSubject = PublishSubject<Location>()
            addressSubject = PublishSubject<String>()
            errorStatus = PublishSubject<LocationError>()
        }
        
        func getAddress(by location: Location) { }
        func getAddress(location: CLLocation) { }
        
        func getLocation() {
            let location = Location(
                latitude: 37.247935,
                longitude: 127.076536
            )
            locationSubject.onNext(location)
        }
        
        func stopLocation() {
            errorStatus.onNext(.denied)
        }
    }
    
    var scheduler: TestScheduler!
    var useCase: LocationUseCase!
    var repository: LocationRepository!
    var location: TestableObserver<Location>!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 0)
        repository = StubRepository()
        useCase = LocationUseCaseImpl(repository: repository)
        location = scheduler.createObserver(Location.self)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        scheduler = nil
        repository = nil
        useCase = nil
        location = nil
        disposeBag = nil
    }
    
    func test_getLocation() throws {
        // given
        repository.locationSubject
            .bind(to: location)
            .disposed(by: disposeBag)
        
        // when
        useCase.getLocation()
        
        // then
        XCTAssertEqual(location.events, [
            .next(0, Location(latitude: 37.247935,
                              longitude: 127.076536
                             ))
        ])
    }
}

