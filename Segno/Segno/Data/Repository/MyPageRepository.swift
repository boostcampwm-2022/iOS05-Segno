//
//  MyPageRepository.swift
//  Segno
//
//  Created by 이예준 on 2022/11/30.
//

import RxSwift

protocol MyPageRepository {
    func getUserDetail() -> Single<UserDetailDTO>
}

final class MyPageRepositoryImpl: MyPageRepository {
    func getUserDetail() -> Single<UserDetailDTO> {
//        let endpoint = UserDetailEndpoint.item(id)
//
//        return NetworkManager.shared.call(endpoint)
//            .map {
//                try JSONDecoder().decode(UserDetailDTO.self, from: $0)
//            }
        
        // TODO: 추후에 NetworkManager로 변경
        return Single.create { observer -> Disposable in
            observer(.success(UserDetailDTO.example))

            return Disposables.create()
        }
    }
}
