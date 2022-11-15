//
//  DiaryRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/15.
//

import RxSwift

protocol DiaryRepository {
    func getDiaryListItem() -> Single<DiaryListItemDTO>
}
