//
//  DiaryCollectionViewModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/15.
//

import RxSwift

final class DiaryCollectionViewModel {
    let useCase: DiaryListUseCase
    var diaryListItems = PublishSubject<[DiaryListItem]>()
    private let disposeBag = DisposeBag()
    
    init(useCase: DiaryListUseCase = DiaryListUseCaseImpl()) {
        self.useCase = useCase
    }
    
    func getDiaryList() {
        useCase.getDiaryList()
            .subscribe(onSuccess: { [weak self] diaryList in
                self?.diaryListItems.onNext(diaryList)
            }, onFailure: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
