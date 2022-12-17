//
//  PlayMusicUseCaseTest.swift
//  SegnoTests
//
//  Created by YOONJONG on 2022/12/17.
//

import ShazamKit
import XCTest

import RxSwift
import RxTest

@testable import Segno

final class PlayMusicUseCaseTest: XCTestCase {
    
    final class MockRepository: MusicRepository {
        var song: MusicInfo?
        var isToggled = false
        var isStopped = false
        
        func startSearchingMusic() { }
        func stopSearchingMusic() { }
        
        func setupMusic(_ song: MusicInfo?) {
            self.song = song
        }
        
        func toggleMusicPlayer() {
            self.isToggled = true
        }
        
        func stopPlayingMusic() {
            self.isStopped = true
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
                emitter.onNext(.failedToPlay)
                return Disposables.create()
            }
        }
        
        func subscribeSearchresult() -> Observable<ShazamSongDTO> {
            return Observable.create { emitter in
                emitter.onCompleted()
                return Disposables.create()
            }
        }
        
        func subscribeSearchError() -> Observable<ShazamError> {
            return Observable.create { emitter in
                emitter.onCompleted()
                return Disposables.create()
            }
        }
    }
    
    var scheduler: TestScheduler!
    var useCase: PlayMusicUseCase!
    var repository: MockRepository!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 0)
        repository = MockRepository()
        useCase = PlayMusicUseCaseImpl(musicRepository: repository)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        scheduler = nil
        repository = nil
        useCase = nil
        disposeBag = nil
    }
    
    func test_setup_player() throws {
        // given
        let musicInfo = MusicInfo(isrc: "1234",
                                  title: "0310",
                                  artist: "백예린",
                                  album: "Every letter I sent you.")
        // when
        useCase.setupPlayer(musicInfo)
        
        // then
        XCTAssertEqual(repository.song, musicInfo)
    }
    
    func test_toggle_player() throws {
        // given when
        useCase.togglePlayer()
        
        // then
        XCTAssertEqual(repository.isToggled, true)
    }
    
    func test_stop_playing() throws {
        // given when
        useCase.stopPlaying()
        
        // then
        XCTAssertEqual(repository.isStopped, true)
    }
    
    func test_subscribe_playing_status() throws {
        // given when
        useCase.subscribePlayingStatus()
            .subscribe(onNext: { status in
                // then
                XCTAssertEqual(status, true)
            })
            .disposed(by: disposeBag)
    }
    
    func test_subscribe_download_status() throws {
        // given when
        useCase.subscribeDownloadStatus()
            .subscribe(onNext: { status in
                // then
                XCTAssertEqual(status, true)
            })
            .disposed(by: disposeBag)
    }
    
    func test_subscribe_player_error() throws {
        // given when
        useCase.subscribePlayerError()
            .subscribe(onNext: { error in
                // then
                XCTAssertEqual(error, .failedToPlay)
            })
            .disposed(by: disposeBag)
    }
}
