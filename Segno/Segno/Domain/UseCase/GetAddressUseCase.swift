//
//  LocationUseCase.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/08.
//

import Foundation

import RxSwift

protocol GetAddressUseCase {
    var addressSubject: PublishSubject<String> { get set }
    func getAddress(by location: Location)
}

final class GetAddressUseCaseImpl: GetAddressUseCase {
    var addressSubject = PublishSubject<String>()
    let repository: LocationRepository
    private var disposeBag = DisposeBag()
    
    init(repository: LocationRepository = LocationRepositoryImpl()) {
        self.repository = repository
        bindAddressSubject()
    }
    
    func getAddress(by location: Location) {
        repository.getAddress(by: location)
    }
    
    private func bindAddressSubject() {
        repository.addressSubject
            .bind(to: addressSubject)
            .disposed(by: disposeBag)
    }
}
