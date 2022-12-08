//
//  MusicSession.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import MusicKit

final class MusicSession {
    private lazy var player = ApplicationMusicPlayer.shared
    private lazy var playerState = player.state
    
    private var isPlaying: Bool {
        return playerState.playbackStatus == .playing
    }
    
    func fetchMusic(term: MusicInfo?) {
        guard let term else { return }
        
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let request = MusicCatalogResourceRequest<Song>(matching: \.isrc, equalTo: term.isrc)
                    let response = try await request.response()
                    if let item = response.items.first {
                        player.queue = [item]
                    }
                } catch (let error) {
                    // TODO: 에러 처리
                    print(error.localizedDescription)
                }
            default:
                // TODO: 에러 처리
                debugPrint("no")
            }
        }
    }
    
    // 음악을 재생하는 함수
    func togglePlayer() {
        if !isPlaying {
            playMusic()
        } else {
            player.pause()
        }
    }
    
    private func playMusic() {
        Task {
            do {
                try await player.play()
            } catch let error {
                // TODO: 에러 처리
                print(error.localizedDescription)
            }
        }
    }
    
    func stopMusic() {
        player.stop()
        player.queue = []
    }
}
