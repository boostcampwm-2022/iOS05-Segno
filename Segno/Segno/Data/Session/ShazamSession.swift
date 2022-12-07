//
//  ShazamSession.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import Foundation
import ShazamKit

import RxSwift

typealias ShazamSearchResult = Result<ShazamSongDTO, ShazamError>

final class ShazamSession: NSObject {
    var result = PublishSubject<ShazamSearchResult>()
    private let disposeBag = DisposeBag()
    
    private lazy var audioSession: AVAudioSession = .sharedInstance()
    private lazy var session: SHSession = .init()
    private lazy var audioEngine: AVAudioEngine = .init()
    private lazy var inputNode = audioEngine.inputNode
    private lazy var bus: AVAudioNodeBus = 0
    
    override init() {
        super.init()
        
        session.delegate = self
    }
    
    func start() {
        switch audioSession.recordPermission {
        case .granted:
            record()
        case .denied:
            stop()
            result.onNext(.failure(.recordDenied))
        case .undetermined:
            audioSession.requestRecordPermission { granted in
                if granted {
                    self.record()
                } else {
                    self.stop()
                    self.result.onNext(.failure(.recordDenied))
                }
            }
        @unknown default:
            stop()
            result.onNext(.failure(.unknown))
        }
    }
    
    func stop() {
        audioEngine.stop()
        inputNode.removeTap(onBus: bus)
    }
    
    private func record() {
        do {
            let format = inputNode.outputFormat(forBus: bus)
            inputNode.installTap(onBus: bus, bufferSize: 2048, format: format) { buffer, time in
                self.session.matchStreamingBuffer(buffer, at: time)
            }
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            result.onNext(.failure(.unknown))
        }
    }
}

extension ShazamSession: SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) {
        stop()
        
        guard let mediaItem = match.mediaItems.first,
              let shazamSong = ShazamSongDTO(mediaItem: mediaItem) else {
            result.onNext(.failure(.matchFailed))
            return
        }
        
        result.onNext(.success(shazamSong))
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        stop()
        result.onNext(.failure(.matchFailed))
    }
}
