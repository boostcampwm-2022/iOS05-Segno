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
    private enum Metric {
        static let userToken: String = "userToken"
    }
    
    private let localUtilityManager = LocalUtilityManagerImpl()
    
    func getDiaryListItem() -> Single<DiaryListDTO> {
        let endpoint = DiaryListItemEndpoint.item

        return NetworkManager.shared.call(endpoint)
            .map {
                let diaryListItemDTO = try JSONDecoder().decode(DiaryListDTO.self, from: $0)
                return diaryListItemDTO
            }
    }
    
    func getDiary(id: String) -> Single<DiaryDetailDTO> {
        let endpoint = DiaryDetailEndpoint.item(id)

        return NetworkManager.shared.call(endpoint).map {
            return try JSONDecoder().decode(DiaryDetailDTO.self, from: $0)
        }
    }
    
    func postDiary(_ newDiary: NewDiaryDetail) -> Single<NewDiaryDetailDTO> {
        let newDiaryDetailEndpoint = NewDiaryPostEndpoint.item(newDiary)
        
        let single = NetworkManager.shared.call(newDiaryDetailEndpoint)
            .map { try JSONDecoder().decode(NewDiaryDetailDTO.self, from: $0) }
            .asObservable()
            .asSingle()
        
        return single
    }
    
    func deleteDiary(id: String) -> Single<Bool> {
        let token = localUtilityManager.getToken(key: Metric.userToken)
        let diaryDeleteEndpoint = DiaryDeleteEndpoint.item(token: token, diaryId: id)
        
        let single = NetworkManager.shared.call(diaryDeleteEndpoint)
            .map { _ in
                return true
            }
        
        return single
    }
}
