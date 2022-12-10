//
//  MapViewModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/10.
//

import RxSwift

final class MapViewModel {
    private let getAddressUseCase: GetAddressUseCase
    private let disposeBag = DisposeBag()
    
    var addressSubject = PublishSubject<String>()
    
    init(getAddressUseCase: GetAddressUseCase = GetAddressUseCaseImpl()) {
        self.getAddressUseCase = getAddressUseCase
        
        bind()
    }
    
    private func bind() {
        getAddressUseCase.addressSubject
            .bind(to: addressSubject)
            .disposed(by: disposeBag)
            
    }
}
