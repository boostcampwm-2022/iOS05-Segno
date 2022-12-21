//
//  DiaryEditUseCase.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/27.
//
import Foundation

import RxSwift

protocol DiaryEditUseCase {
    func postDiary(_ newDiary: NewDiaryDetail) -> Completable
    func updateDiary(_ diary: UpdateDiaryDetail) -> Completable
}

final class DiaryEditUseCaseImpl: DiaryEditUseCase {
    let localUtilityManager: LocalUtilityManagerImpl
    let diaryRepository: DiaryRepository
    let imageRepository: ImageRepository
    private var disposeBag = DisposeBag()
    
    init(localUtilityManager: LocalUtilityManagerImpl = LocalUtilityManagerImpl(),
         diaryRepository: DiaryRepository = DiaryRepositoryImpl(),
         imageRepository: ImageRepository = ImageRepositoryImpl()) {
        self.localUtilityManager = localUtilityManager
        self.diaryRepository = diaryRepository
        self.imageRepository = imageRepository
    }
    
    func postDiary(_ newDiary: NewDiaryDetail) -> Completable {
        return diaryRepository.postDiary(newDiary)
            .asCompletable()
    }
    
    func updateDiary(_ diary: UpdateDiaryDetail) -> Completable {
        return diaryRepository.updateDiary(diary)
            .asCompletable()
    }
}
