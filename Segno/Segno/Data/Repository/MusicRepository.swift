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
    private let shazamSession = ShazamSession()
    private let musicSession = MusicSession()
    
    var shazamSearchResult = PublishSubject<ShazamSearchResult>()
    
    func startSearchingMusic() {
        
    }
    
    func stopSearchingMusic() {
        
    }
    
    func playMusic() {
        
    }
}
