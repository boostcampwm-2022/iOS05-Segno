//
//  DiaryCollectionViewModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/15.
//

import RxSwift

final class DiaryCollectionViewModel {
    private let useCase: DiaryListUseCase
    private var disposeBag = DisposeBag()
    
    var diaryListItems = PublishSubject<[DiaryListItem]>()
    
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
