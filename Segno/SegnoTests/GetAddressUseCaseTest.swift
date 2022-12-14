//
//  GetAddressUseCaseTest.swift
//  SegnoTests
//
//  Created by YOONJONG on 2022/12/14.
//

import XCTest
import CoreLocation

import RxSwift
import RxTest

@testable import Segno

final class GetAddressUseCaseTest: XCTestCase {
    
    class StubRepository: LocationRepository {
        var locationSubject: PublishSubject<Location>
        var addressSubject: PublishSubject<String>
        var errorStatus: PublishSubject<LocationError>
        var errorObservable: Observable<LocationError> {
            errorStatus.asObservable()
        }
        let fakeReturnValue = "경기도 수원시 영통구 영통동 1024-3"
        
        init() {
            locationSubject = PublishSubject<Location>()
            addressSubject = PublishSubject<String>()
            errorStatus = PublishSubject<LocationError>()
        }
        
        func getAddress(by location: Location) {
            let cllocation = CLLocation(
                latitude: location.latitude,
                longitude: location.longitude
            )
            getAddress(location: cllocation)
        }
        func getAddress(location: CLLocation) {
            addressSubject.onNext(fakeReturnValue)
        }
        func getLocation() { }
        func stopLocation() { }
        
        
    }
    var scheduler: TestScheduler!
    var useCase: GetAddressUseCase!
    var repository: LocationRepository!
    var address: TestableObserver<String>!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 0)
        repository = StubRepository()
        useCase = GetAddressUseCaseImpl(repository: repository)
        address = scheduler.createObserver(String.self)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        scheduler = nil
        repository = nil
        useCase = nil
        address = nil
        disposeBag = nil
    }

    func test_getAddress() throws {
        // given
        let location = Location(
            latitude: 37.247935,
            longitude: 127.076536
        )

        repository.addressSubject
            .bind(to: address)
            .disposed(by: disposeBag)
        
        // when
        useCase.getAddress(by: location)
        let correctAddress = Recorded.events(.next(0, "경기도 수원시 영통구 영통동 1024-3"))
        
        // then
        XCTAssertEqual(address.events, correctAddress)
    }
}
