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
    func getDiary(id: String) -> Single<DiaryDetailDTO>
}

final class DiaryRepositoryImpl: DiaryRepository {
    func getDiaryListItem() -> Single<DiaryListDTO> {
//        let endpoint = DiaryListItemEndpoint.item
//
//        return NetworkManager.shared.call(endpoint)
//            .map {
//                let diaryListItemDTO = try JSONDecoder().decode(DiaryListDTO.self, from: $0)
//                return diaryListItemDTO
//            }
        
        // TODO: 추후에 NetworkManager로 변경
        return Single.create { observer -> Disposable in
            let dto = DiaryListDTO.example
            observer(.success(dto))
            
            return Disposables.create()
        }
    }
    
    func getDiary(id: String) -> Single<DiaryDetailDTO> {
        let endpoint = DiaryDetailEndpoint.item(id)

        return NetworkManager.shared.call(endpoint).map {
            try JSONDecoder().decode(DiaryDetailDTO.self, from: $0)
        }
        
//        // TODO: 추후에 NetworkManager로 변경
//        return Single.create { observer -> Disposable in
//            observer(.success(DiaryDetailDTO.example))
//
//            return Disposables.create()
//        }
    }
}
