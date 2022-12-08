//
//  DiaryEditUseCase.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/27.
//
import Foundation

import RxSwift

protocol DiaryEditUseCase {
    func postDiary(_ newDiary: NewDiaryDetail) -> Single<NewDiaryDetail>
}

final class DiaryEditUseCaseImpl: DiaryEditUseCase {
    let localUtilityRepository: LocalUtilityRepositoryImpl
    let diaryRepository: DiaryRepository
    let imageRepository: ImageRepository
    private let disposeBag = DisposeBag()
    
    init(localUtilityRepository: LocalUtilityRepositoryImpl = LocalUtilityRepositoryImpl(),
         diaryRepository: DiaryRepository = DiaryRepositoryImpl(),
         imageRepository: ImageRepository = ImageRepositoryImpl()) {
        self.localUtilityRepository = localUtilityRepository
        self.diaryRepository = diaryRepository
        self.imageRepository = imageRepository
    }
    
    func postDiary(_ newDiary: NewDiaryDetail) -> Single<NewDiaryDetail> {
        return diaryRepository.postDiary(newDiary).map { dto in
            NewDiaryDetail(
                title: dto.title,
                tags: dto.tags,
                imagePath: dto.imagePath,
                bodyText: dto.bodyText,
                musicInfo: dto.musicInfo,
                location: dto.location,
                token: self.localUtilityRepository.getToken()
            )
        }
    }
}
