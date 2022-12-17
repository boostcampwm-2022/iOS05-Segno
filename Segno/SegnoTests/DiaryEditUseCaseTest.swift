//
//  DiaryEditUseCaseTest.swift
//  SegnoTests
//
//  Created by 이예준 on 2022/12/14.
//

import XCTest

import RxSwift
import RxTest

@testable import Segno

final class DiaryEditUseCaseTest: XCTestCase {
    
    final class StubRepository: DiaryRepository {
        func getDiaryListItem() -> Single<DiaryListDTO> {
            let listItem1 = DiaryListItemDTO(identifier: "1", title: "first", thumbnailPath: "firstfirst")
            let listItem2 = DiaryListItemDTO(identifier: "2", title: "second", thumbnailPath: "secondsecond")
            let listItem3 = DiaryListItemDTO(identifier: "3", title: "third", thumbnailPath: "thirdthird")
            let list = DiaryListDTO(diaries: [listItem1, listItem2, listItem3])
            
            return Single.create { single in
                single(.success(list))
                return Disposables.create()
            }
        }
        
        func getDiary(id: String) -> Single<DiaryDetailDTO> {
            let diaryDetailDTO = DiaryDetailDTO(id: id, userId: "0001", date: "2022/12/17 03:00:00", title: "dummy", tags: [], imagePath: "dummydummy")
            
            return Single.create { single in
                single(.success(diaryDetailDTO))
                return Disposables.create()
            }
        }
        
        func postDiary(_ newDiary: NewDiaryDetail) -> Single<NewDiaryDetailDTO> {
            let newDiaryDetailDTO = NewDiaryDetailDTO(Code: "code", Desc: "desc")
            
            return Single.create { single in
                single(.success(newDiaryDetailDTO))
                return Disposables.create()
            }
        }
        
        func updateDiary(_ diary: UpdateDiaryDetail) -> Single<Bool> {
            return Single.create { single in
                single(.success(true))
                return Disposables.create()
            }
        }
        
        func deleteDiary(id: String) -> Single<Bool> {
            return Single.create { single in
                single(.success(true))
                return Disposables.create()
            }
        }
    }
    
    var scheduler: TestScheduler!
    var useCase: DiaryEditUseCase!
    var repository: DiaryRepository!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        scheduler = TestScheduler(initialClock: 0)
        repository = StubRepository()
        useCase = DiaryEditUseCaseImpl(diaryRepository: repository)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        scheduler = nil
        useCase = nil
        repository = nil
        disposeBag = nil
    }

    func test_postDiary() throws {
        // given
        let newDiaryDetail = NewDiaryDetail(date: "2022/12/17 03:00:00", title: "dummy", tags: [], imagePath: "dummydummy", bodyText: nil, musicInfo: nil, location: nil, token: "token")
        var events: [CompletableEvent] = []
        
        // when
        useCase.postDiary(newDiaryDetail)
            .subscribe { event in
                events.append(event)
            }
            .disposed(by: DisposeBag())

        // then
        XCTAssertEqual(events, [.completed])
    }
    
    func test_updateDiary() throws {
        // given
        let updateDiaryDetail = UpdateDiaryDetail(id: "1", date: "2022/12/17 03:00:00", title: "dummy", tags: [], imagePath: "dummydummy", bodyText: nil, musicInfo: nil, location: nil, token: "token")
        var events: [CompletableEvent] = []
        
        // when
        useCase.updateDiary(updateDiaryDetail)
            .subscribe { event in
                events.append(event)
            }
            .disposed(by: DisposeBag())
        
        // then
        XCTAssertEqual(events, [.completed])
    }
}
