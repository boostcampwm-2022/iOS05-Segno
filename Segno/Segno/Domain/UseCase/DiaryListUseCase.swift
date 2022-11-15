//
//  DiaryListUseCase.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/15.
//

import RxSwift

protocol DiaryListUseCase {
    func getDiaryList() -> Single<[DiaryListItem]>
}

final class DiaryListUseCaseImpl: DiaryListUseCase {
    let repository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    init(repository: DiaryRepository = DiaryRepositoryImpl()) {
        self.repository = repository
    }
    
    func getDiaryList() -> Single<[DiaryListItem]> {
        return repository.getDiaryListItem()
            .map {
                $0.map { diaryData in
                    DiaryListItem(id: diaryData.id, title: diaryData.title, thumbnailPath: diaryData.thumbnailPath)
                }
            }
    }
}
