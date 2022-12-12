//
//  ShazamSession.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import Foundation
import ShazamKit

import RxSwift

final class ShazamSession: NSObject {
    private var result = PublishSubject<ShazamSongDTO>()
    private var errorStatus = PublishSubject<ShazamError>()
    private let disposeBag = DisposeBag()
    
    var resultObservable: Observable<ShazamSongDTO> {
        result.asObservable()
    }
    var errorObservable: Observable<ShazamError> {
        errorStatus.asObservable()
    }
    
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
            errorStatus.onNext(.recordDenied)
        case .undetermined:
            audioSession.requestRecordPermission { granted in
                if granted {
                    self.record()
                } else {
                    self.errorStatus.onNext(.recordDenied)
                }
            }
        @unknown default:
            errorStatus.onNext(.unknown)
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
            errorStatus.onNext(.unknown)
        }
    }
}

extension ShazamSession: SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) {
        guard let mediaItem = match.mediaItems.first,
              let shazamSong = ShazamSongDTO(mediaItem: mediaItem) else {
            errorStatus.onNext(.matchFailed)
            return
        }
        
        result.onNext(shazamSong)
        stop()
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        errorStatus.onNext(.matchFailed)
        stop()
    }
}
