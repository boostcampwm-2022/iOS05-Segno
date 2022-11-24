//
//  DiaryDetailUseCase.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/23.
//

import RxSwift

protocol DiaryDetailUseCase {
    func getDiary(id: String) -> Single<DiaryDetail>
}

final class DiaryDetailUseCaseImpl: DiaryDetailUseCase {
    let repository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    init(repository: DiaryRepository = DiaryRepositoryImpl()) {
        self.repository = repository
    }
    
    func getDiary(id: String) -> Single<DiaryDetail> {
        // MusicInfo, location은 추가 상의 필요
        return repository.getDiary(id: id).map {
            DiaryDetail(identifier: $0.id, title: $0.title, tags: $0.tags, imagePath: $0.imagePath, bodyText: $0.bodyText, musicInfo: nil, location: nil)
            }
    }
}
