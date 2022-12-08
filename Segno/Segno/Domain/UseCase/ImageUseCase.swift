//
//  ImageUseCase.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/08.
//

import Foundation

import RxSwift

protocol ImageUseCase {
    func uploadImage(data: Data) -> Single<ImageInfo>
}

final class ImageUseCaseImpl: ImageUseCase {
    let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository = ImageRepositoryImpl()) {
        self.imageRepository = imageRepository
    }
    
    func uploadImage(data: Data) -> Single<ImageInfo> {
        return imageRepository.uploadImage(data: data)
            .map {
                ImageInfo(filename: $0.filename)
            }
    }
}
