//
//  MusicSession.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import MusicKit

final class MusicSession {
    private var song: Song?
    
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
                        song = item
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
        guard let song else { return }
        if !isPlaying {
            playMusic(song: song)
        } else {
            player.pause()
        }
        
        // 뷰 컨트롤러를 나갈 때 큐를 비워 준다.
        // 뮤직세션, 샤잠세션은 싱글턴 인스턴스로 만들어 주는 것이 좋겠다.
    }
    
    private func playMusic(song: Song) {
        player.queue = [song]
        
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
    }
}
