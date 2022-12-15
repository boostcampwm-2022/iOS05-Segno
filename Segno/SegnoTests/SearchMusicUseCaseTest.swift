//
//  SearchMusicUseCaseTest.swift
//  SegnoTests
//
//  Created by YOONJONG on 2022/12/16.
//

import ShazamKit
import XCTest

import RxSwift
import RxTest

@testable import Segno

final class SearchMusicUseCaseTest: XCTestCase {
    
    final class MockRepository: MusicRepository {
        var searchingMusicCount = 0
        
        func startSearchingMusic() {
            searchingMusicCount += 1
        }
        
        func stopSearchingMusic() {
            searchingMusicCount -= 1
        }
        
        func setupMusic(_ song: MusicInfo?) {
            
        }
        
        func toggleMusicPlayer() {
            
        }
        
        func stopPlayingMusic() {
            
        }
        
        func subscribeSearchresult() -> Observable<ShazamSongDTO> {
            return Observable.create { emitter in
                guard let dto = ShazamSongDTO(
                    mediaItem: SHMatchedMediaItem(properties: [SHMediaItemProperty("Hello") : "Any"])
                ) else {
                    emitter.onCompleted()
                    return Disposables.create()
                }
                emitter.onNext(dto)
                return Disposables.create()
            }
        }
        
        func subscribeSearchError() -> Observable<ShazamError> {
            return Observable.create { emitter in
                emitter.onNext(.unknown)
                return Disposables.create()
            }
        }
        
        func subscribePlayingStatus() -> Observable<Bool> {
            return Observable.create { emitter in
                emitter.onNext(true)
                return Disposables.create()
            }
        }
        
        func subscribeDownloadStatus() -> Observable<Bool> {
            return Observable.create { emitter in
                emitter.onNext(true)
                return Disposables.create()
            }
        }
        
        func subscribePlayerError() -> Observable<MusicError> {
            return Observable.create { emitter in
                emitter.onNext(.libraryAccessDenied)
                return Disposables.create()
            }
        }
        
        
    }
    
    var scheduler: TestScheduler!
    var useCase: SearchMusicUseCase!
    var repository: MockRepository!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 0)
        repository = MockRepository()
        useCase = SearchMusicUseCaseImpl(musicRepository: repository)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        scheduler = nil
        repository = nil
        useCase = nil
        disposeBag = nil
    }
    
    func test_start_searching() throws {
        // given when
        useCase.startSearching()
        
        // then
        XCTAssertEqual(repository.searchingMusicCount, 1)
    }
    func test_stop_searching() throws {
        // given when
        useCase.stopSearching()
        
        // then
        XCTAssertEqual(repository.searchingMusicCount, -1)
    }
    
    func test_subscribe_shazam_result() throws {
        // given when
        useCase.subscribeShazamResult()
            .subscribe(onNext: { musicInfo in
                guard let dto = ShazamSongDTO(mediaItem:
                                            SHMatchedMediaItem(
                                                properties: [
                                                    SHMediaItemProperty("Hello") : "Any"
                                                ]
                                            )) else { return }
                let correctMusicInfo = MusicInfo(shazamSong: dto)
                
                // then
                XCTAssertEqual(musicInfo, correctMusicInfo)
            })
            
            .disposed(by: disposeBag)
    }
}
