//
//  DiaryRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/15.
//

import Foundation
import RxSwift

protocol DiaryRepository {
    func getDiaryListItem() -> Single<DiaryListItemDTO>
}

final class DiaryRepositoryImpl: DiaryRepository {
    func getDiaryListItem() -> Single<DiaryListItemDTO> {
        let endpoint = DiaryListItemEndpoint.item
        
        return NetworkManager.shared.call(endpoint)
            .map {
                let diaryListItemDTO = try JSONDecoder().decode(DiaryListItemDTO.self, from: $0)
                return diaryListItemDTO
            }
    }
}
