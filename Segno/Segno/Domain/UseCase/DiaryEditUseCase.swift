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
}

final class DiaryEditUseCaseImpl: DiaryEditUseCase {
    let diaryRepository: DiaryRepository
    let imageRepository: ImageRepository
    private let disposeBag = DisposeBag()
    
    init(diaryRepository: DiaryRepository = DiaryRepositoryImpl(),
         imageRepository: ImageRepository = ImageRepositoryImpl()) {
        self.diaryRepository = diaryRepository
        self.imageRepository = imageRepository
    }
    
    func postDiary(_ newDiary: NewDiaryDetail) -> Completable {
        return diaryRepository.postDiary(newDiary)
            .asCompletable()
    }
}
