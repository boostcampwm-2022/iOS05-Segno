//
//  DiaryListUseCaseTest.swift
//  SegnoTests
//
//  Created by 이예준 on 2022/12/14.
//

import XCTest

import RxSwift
import RxTest

@testable import Segno

final class DiaryListUseCaseTest: XCTestCase {
    
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
    var useCase: DiaryListUseCase!
    var repository: DiaryRepository!
    var manager: LocalUtilityManager!
    var info: TestableObserver<[DiaryListItem]>!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        scheduler = TestScheduler(initialClock: 0)
        repository = StubRepository()
        useCase = DiaryListUseCaseImpl(repository: repository)
        info = scheduler.createObserver([DiaryListItem].self)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        scheduler = nil
        useCase = nil
        repository = nil
        manager = nil
        disposeBag = nil
    }

    func test_getDiaryList() throws {
        // given
        let diaryListItem1 = DiaryListItem(identifier: "1", title: "first", thumbnailPath: "firstfirst")
        let diaryListItem2 = DiaryListItem(identifier: "2", title: "second", thumbnailPath: "secondsecond")
        let diaryListItem3 = DiaryListItem(identifier: "3", title: "third", thumbnailPath: "thirdthird")
        let diaryList = [diaryListItem1, diaryListItem2, diaryListItem3]
        
        // when
        useCase.getDiaryList()
            .asObservable()
            .bind(to: info)
            .disposed(by: disposeBag)
        
        // then
        XCTAssertEqual(info.events, [.next(0, diaryList),
                                     .completed(0)])
    }
}
