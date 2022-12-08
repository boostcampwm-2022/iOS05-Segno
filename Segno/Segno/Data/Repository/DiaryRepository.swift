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
    func postDiary(_ newDiary: NewDiaryDetail) -> Single<NewDiaryDetailDTO>
    func deleteDiary(id: String) -> Single<Bool>
}

final class DiaryRepositoryImpl: DiaryRepository {
    func getDiaryListItem() -> Single<DiaryListDTO> {
        let endpoint = DiaryListItemEndpoint.item

        return NetworkManager.shared.call(endpoint)
            .map {
                let diaryListItemDTO = try JSONDecoder().decode(DiaryListDTO.self, from: $0)
                return diaryListItemDTO
            }

//        // TODO: 추후에 NetworkManager로 변경
//        return Single.create { observer -> Disposable in
//            let dto = DiaryListDTO.example
//            observer(.success(dto))
//
//            return Disposables.create()
//        }
    }
    
    func getDiary(id: String) -> Single<DiaryDetailDTO> {
        let endpoint = DiaryDetailEndpoint.item(id)

        return NetworkManager.shared.call(endpoint).map {
            debugPrint("repository: \($0)")
            return try JSONDecoder().decode(DiaryDetailDTO.self, from: $0)
        }
        
//        // TODO: 추후에 NetworkManager로 변경
//        return Single.create { observer -> Disposable in
//            observer(.success(DiaryDetailDTO.example))
//
//            return Disposables.create()
//        }
    }
    
    func postDiary(_ newDiary: NewDiaryDetail) -> Single<NewDiaryDetailDTO> {
        let newDiaryDetailEndpoint = NewDiaryPostEndpoint.item(newDiary)
        print("========= repository -> ", newDiary)
        
        let single = NetworkManager.shared.call(newDiaryDetailEndpoint)
            .map { try JSONDecoder().decode(NewDiaryDetailDTO.self, from: $0) }
            .asObservable()
            .asSingle()
        
        return single
    }
    
    func deleteDiary(id: String) -> RxSwift.Single<Bool> {
        //TODO: - Token 받아오기
        let token = "0KjV78s0YPKbrlVP3QeAwUJcjohs2h2ysdWDLWg"
        
        let diaryDeleteEndpoint = DiaryDeleteEndpoint.item(token: token, diaryId: id)
        
        let single = NetworkManager.shared.call(diaryDeleteEndpoint)
            .map { _ in
                return true
            }
        
        return single
    }
}
