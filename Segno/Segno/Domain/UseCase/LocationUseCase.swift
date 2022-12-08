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
    var addressSubject: PublishSubject<String> { get set }
    func getLocation()
    func stopLocation()
}

final class LocationUseCaseImpl: LocationUseCase {
    var locationSubject = PublishSubject<Location>()
    var addressSubject = PublishSubject<String>()
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
        repository.addressSubject
            .bind(to: addressSubject)
            .disposed(by: disposeBag)
        
        repository.locationSubject
            .bind(to: locationSubject)
            .disposed(by: disposeBag)
    }
}
