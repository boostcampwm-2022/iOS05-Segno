//
//  MusicRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

protocol MusicRepository {
    var shazamSearchResult: PublishSubject<ShazamSearchResult> { get set }
    
    func startSearchingMusic()
    func stopSearchingMusic()
    func playMusic()
}

final class MusicRepositoryImpl: MusicRepository {
    private let shazamSession: ShazamSession
    private let musicSession: MusicSession
    private let disposeBag = DisposeBag()
    
    var shazamSearchResult = PublishSubject<ShazamSearchResult>()
    
    init(shazamSession: ShazamSession = ShazamSession(),
         musicSession: MusicSession = MusicSession()) {
        self.shazamSession = shazamSession
        self.musicSession = musicSession
        
        subscribeSearchresult()
    }
    
    func startSearchingMusic() {
        shazamSession.start()
    }
    
    func stopSearchingMusic() {
        shazamSession.stop()
    }
    
    func playMusic() {
        
    }
}

extension MusicRepositoryImpl {
    private func subscribeSearchresult() {
        shazamSession.result
            .subscribe(onNext: {
                self.shazamSearchResult.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}
