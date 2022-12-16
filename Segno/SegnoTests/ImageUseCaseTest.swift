//
//  ImageUseCaseTest.swift
//  SegnoTests
//
//  Created by YOONJONG on 2022/12/17.
//

import XCTest

import RxSwift
import RxTest

@testable import Segno

final class ImageUseCaseTest: XCTestCase {
    
    final class StubRepository: ImageRepository {
        func uploadImage(data: Data) -> Single<ImageDTO> {
            return Single.create { single in
                single(.success(ImageDTO(filename: "abc")))
                return Disposables.create()
            }
        }
    }
    
    var scheduler: TestScheduler!
    var useCase: ImageUseCase!
    var repository: ImageRepository!
    var info: TestableObserver<ImageInfo>!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 0)
        repository = StubRepository()
        useCase = ImageUseCaseImpl(imageRepository: repository)
        info = scheduler.createObserver(ImageInfo.self)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        scheduler = nil
        repository = nil
        useCase = nil
        disposeBag = nil
    }
    
    func test_upload_image() throws {
        // given
        let imageInfo = ImageInfo(filename: "abc")
        
        // when
        useCase.uploadImage(data: Data())
            .asObservable()
            .bind(to: info)
            .disposed(by: disposeBag)
        
        // then
        XCTAssertEqual(info.events, [.next(0, imageInfo),
                                     .completed(0)]
        )
    }
}
