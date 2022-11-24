//
//  DiaryDetailViewModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/23.
//

import Foundation

import RxSwift

final class DiaryDetailViewModel {
    
    private let itemIdentifier: String
    let useCase: DiaryDetailUseCase
    var diaryItem = PublishSubject<DiaryDetail>()
    // TODO: DiaryDetail에 date 추가
    // lazy var dateObservable = diaryItem.map { $0.date }
    lazy var titleObservable = diaryItem.map { $0.title }
    lazy var tagsObservable = diaryItem.map { $0.tags }
    lazy var imagePathObservable = diaryItem.map { $0.imagePath }
    lazy var bodyObservable = diaryItem.map { $0.bodyText }
    lazy var musicObservable = diaryItem.map { $0.musicInfo }
    lazy var locationObservable = diaryItem.map { $0.location }
        
    private let disposeBag = DisposeBag()
    
    init(itemIdentifier: String, useCase: DiaryDetailUseCase = DiaryDetailUseCaseImpl()) {
        self.itemIdentifier = itemIdentifier
        self.useCase = useCase
    }
    
    func getDiary() {
        useCase.getDiary(id: itemIdentifier)
            .subscribe(onSuccess: { [weak self] diary in
                self?.diaryItem.onNext(diary)
            }, onFailure: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
