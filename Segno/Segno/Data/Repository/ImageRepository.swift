//
//  ImageRepository.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/08.
//

import Foundation

import RxSwift

protocol ImageRepository {
    func uploadImage(data: Data) -> Single<ImageDTO>
}

final class ImageRepositoryImpl: ImageRepository {
    func uploadImage(data: Data) -> Single<ImageDTO> {
        let endpoint = ImageEndpoint.item(data)
        
        return NetworkManager.shared.call(endpoint)
            .map {
                let imageDTO = try JSONDecoder().decode(ImageDTO.self, from: $0)
                return imageDTO
            }
    }
}

