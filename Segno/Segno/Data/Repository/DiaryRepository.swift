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
    func postDiary(_ diary: DiaryDetail, image: Data) -> Single<DiaryDetailDTO>
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
    
    func postDiary(_ diary: DiaryDetail, image: Data) -> Single<DiaryDetailDTO> {
        // Dummy endpoint
        
        let imageEndpoint = ImageEndpoint.item(image)

        let single = NetworkManager.shared.call(imageEndpoint)
            .compactMap {
                // image 전송 후 이름 받아오기
                let imageDTO = try JSONDecoder().decode(ImageDTO.self, from: $0)
                return imageDTO.filename
            }.map { imagePath in
                // diary에 imagePath넣어 전달
                return DiaryDetail(diary, imagePath: imagePath)
            }.flatMap { diaryDetail in
                // diary를 다시 서버에 전달
                // TODO: - token 넣어야됩니당
                let testDiaryDetail = DiaryDetail(diaryDetail, token: "0KjV78s0YPKbrlVP3QeAwUJcjohs2h2ysdWDLWg")
                                
                let diaryDetailEndpoint = DiaryPostEndpoint.item(testDiaryDetail)
                
                return NetworkManager.shared.call(diaryDetailEndpoint)
                    .map { try JSONDecoder().decode(DiaryDetailDTO.self, from: $0) }
                    .asObservable()
                    .asMaybe()
            }
            .asObservable()
            .asSingle()
        
        return single
    }
}
