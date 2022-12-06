//
//  MusicRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

protocol MusicRepository {
    func toggleSearchingMusic()
    func playMusic()
}

final class MusicRepositoryImpl: MusicRepository {
    private let shazamSession = ShazamSession()
    private let musicSession = MusicSession()
    
    func toggleSearchingMusic() {
        
    }
    
    func playMusic() {
        
    }
}
