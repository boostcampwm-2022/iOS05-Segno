//
//  MusicSession.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import MusicKit

final class MusicSession {
    private var songInfo: SongInfo?
    private var song: Song?
    
    private lazy var player = ApplicationMusicPlayer.shared
    private lazy var playerState = player.state
    
    private var isPlaying: Bool {
        return playerState.playbackStatus == .playing
    }
    
    private let request: MusicCatalogSearchRequest = {
        var request = MusicCatalogSearchRequest(term: "Happy", types: [Song.self])
        request.limit = 1
        return request
    }()
    
    func fetchMusic(term: SongInfo?) {
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
                        songInfo = SongInfo(isrc: item.isrc!, title: item.title, artist: item.artistName, album: item.albumTitle)
                    }
                    
                    print(songInfo ?? "NO SONG")
                } catch (let error) {
                    print(error.localizedDescription)
                }
            default:
                debugPrint("no")
            }
        }
    }
    
    // 음악을 재생하는 함수
    func playMusic() {
        guard let song else { return }
        if !isPlaying {
            player.queue = [song]
            
            Task {
                do {
                    try await player.play()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        } else {
            player.pause()
        }
        
        // 뷰 컨트롤러를 나갈 때 큐를 비워 준다.
        // 뮤직세션, 샤잠세션은 싱글턴 인스턴스로 만들어 주는 것이 좋겠다.
    }
}

struct SongInfo {
    let isrc: String
    let title: String
    let artist: String
    let album: String?
}
