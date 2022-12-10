//
//  MusicSession.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import MusicKit

import RxSwift

final class MusicSession {
    private lazy var player = ApplicationMusicPlayer.shared
    private lazy var playerState = player.state
    
    private var isPlaying: Bool {
        return playerState.playbackStatus == .playing
    }
    private var playingStatus: BehaviorSubject<Bool> {
        return BehaviorSubject(value: isPlaying)
    }
    private var errorStatus = PublishSubject<MusicError>()
    
    var playingStatusObservable: Observable<Bool> {
        return playingStatus.asObservable()
    }
    var errorStatusObservable: Observable<MusicError> {
        return errorStatus.asObservable()
    }
    
    init() {
        playerState.repeatMode = .one
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
                } catch {
                    debugPrint(MusicError.failedToFetch)
                }
            default:
                debugPrint(MusicError.libraryAccessDenied)
            }
        }
    }
    
    // 음악 재생, 일시정지, 정지에 관여하는 메서드
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
            } catch {
                debugPrint(MusicError.failedToPlay)
            }
        }
    }
    
    func stopMusic() {
        player.stop()
        player.queue = []
    }
}
