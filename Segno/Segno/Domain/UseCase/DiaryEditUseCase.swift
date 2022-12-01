//
//  DiaryEditUseCase.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/27.
//
import Foundation

import RxSwift

protocol DiaryEditUseCase {
    func postDiary(_ diary: DiaryDetail, image: Data) -> Single<DiaryDetail>
}

final class DiaryEditUseCaseImpl: DiaryEditUseCase {
    let repository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    init(repository: DiaryRepository = DiaryRepositoryImpl()) {
        self.repository = repository
    }
    
    func postDiary(_ diary: DiaryDetail, image: Data) -> Single<DiaryDetail> {
        repository.postDiary(diary, image: image).map { dto in
            DiaryDetail(
                identifier: dto.id,
                title: dto.title,
                tags: dto.tags,
                imagePath: dto.imagePath,
                bodyText: dto.bodyText,
                // TODO: MusicInfo, location 업데이트
                musicInfo: nil,
                location: nil
            )
        }
    }
}
