//
//  DiaryRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/15.
//

import Foundation
import RxSwift

protocol DiaryRepository {
    func getDiaryListItem() -> Single<DiaryListDTO>
}

final class DiaryRepositoryImpl: DiaryRepository {
    func getDiaryListItem() -> Single<DiaryListDTO> {
        let endpoint = DiaryListItemEndpoint.item
        
        return NetworkManager.shared.call(endpoint)
            .map {
                let diaryListItemDTO = try JSONDecoder().decode(DiaryListDTO.self, from: $0)
                return diaryListItemDTO
            }
    }
}
