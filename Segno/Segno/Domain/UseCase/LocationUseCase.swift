//
//  LocationUseCase.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/08.
//

import Foundation

import RxSwift

protocol LocationUseCase {
    var locationSubject: PublishSubject<Location> { get set }
    func getLocation()
    func stopLocation()
    func subscribeError() -> Observable<LocationError>
}

final class LocationUseCaseImpl: LocationUseCase {
    var locationSubject = PublishSubject<Location>()
    let repository: LocationRepository
    private let disposeBag = DisposeBag()
    
    init(repository: LocationRepository = LocationRepositoryImpl()) {
        self.repository = repository
        subscribeResults()
    }
    
    func getLocation() {
        repository.getLocation()
    }
    
    func stopLocation() {
        repository.stopLocation()
    }
    
    private func subscribeResults() {
        repository.locationSubject
            .bind(to: locationSubject)
            .disposed(by: disposeBag)
    }
    
    func subscribeError() -> Observable<LocationError> {
        return repository.errorObservable
    }
}
