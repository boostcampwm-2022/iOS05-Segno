//
//  PlayMusicUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/07.
//

import Foundation

protocol PlayMusicUseCase {
    func setupPlayer(_ song: MusicInfo?)
    func togglePlayer()
    func stopPlaying()
}

final class PlayMusicUseCaseImpl: PlayMusicUseCase {
    let musicRepository: MusicRepository
    
    init(musicRepository: MusicRepository = MusicRepositoryImpl()) {
        self.musicRepository = musicRepository
    }
    
    func setupPlayer(_ song: MusicInfo?) {
        musicRepository.setupMusic(song)
    }
    
    func togglePlayer() {
        musicRepository.toggleMusicPlayer()
    }
    
    func stopPlaying() {
        musicRepository.stopPlayingMusic()
    }
}
