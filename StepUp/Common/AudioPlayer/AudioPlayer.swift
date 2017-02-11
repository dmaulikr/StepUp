import Foundation
import AVFoundation

class AudioPlayer {
    private let engine: AVAudioEngine
    private let playerNode: AVAudioPlayerNode
    private let mixer: AVAudioMixerNode
    private var audio: AVAudioFile?
    var elapsedTime: ((AudioTime) -> ())?
    var totalLength: ((AudioTime) -> ())?
    var progress: ((_ elapsedTime: AudioTime, _ totalLength: AudioTime) -> ())?
    var isPlaying: Bool {
        return playerNode.isPlaying
    }
    
    init() {
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        mixer = engine.mainMixerNode
    }
    
    deinit {
        audio = nil
        playerNode.stop()
        engine.inputNode?.removeTap(onBus: 0)
        engine.disconnectNodeInput(playerNode)
        engine.detach(playerNode)
        engine.stop()
        cleanUpAudioSession()
    }
    
    func configure(completion: @escaping (Result<Bool>) -> ()) {
        DispatchQueue.global().async { [unowned self] in
            self.engine.attach(self.playerNode)
            self.engine.connect(self.playerNode, to: self.mixer, format: nil)
            self.engine.inputNode?.installTap(onBus: 0,
                                         bufferSize: 1024,
                                         format: self.mixer.inputFormat(forBus: 0),
                                         block: { [weak self] (b: AVAudioPCMBuffer, at: AVAudioTime) in
                                            if let closure = self?.elapsedTime,
                                                let currentTime = self?.currentTime(),
                                                let totalTime = self?.totalTime(),
                                                let isPlaying = self?.playerNode.isPlaying,
                                                isPlaying {
                                                DispatchQueue.main.async {
                                                    closure(AudioTime(currentTime))
                                                    if let progress = self?.progress {
                                                        progress(AudioTime(currentTime), AudioTime(totalTime))
                                                    }
                                                }
                                            }
            })
            do {
                try self.engine.start()
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.success(false))
                }
            }
        }
    }
    
    func play() {
        playerNode.play()
        if let closure = totalLength {
            closure(AudioTime(totalTime()))
        }
    }
    
    func pause() {
        playerNode.pause()
    }
    
    func prepare(audioFilePath path: URL, completion: @escaping (Result<Bool>) -> (), stopped: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            self?.playerNode.reset()
            self?.playerNode.stop()
            guard let audio = try? AVAudioFile(forReading: path) else { return }
            self?.audio = audio
            self?.prepareAudioSession()
            self?.playerNode.scheduleFile(audio, at: nil) {
                DispatchQueue.main.async {
                    stopped()
                }
            }
            self?.playerNode.prepare(withFrameCount: 1)
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }
    }
    
    private func totalTime() -> TimeInterval {
        if let nodeTime: AVAudioTime = playerNode.lastRenderTime,
            let playerTime: AVAudioTime = playerNode.playerTime(forNodeTime: nodeTime),
            let audio = self.audio {
            return Double(Double(audio.length) / playerTime.sampleRate)
        }
        return 0
    }
    
    private func currentTime() -> TimeInterval {
        if let nodeTime: AVAudioTime = playerNode.lastRenderTime,
            let playerTime: AVAudioTime = playerNode.playerTime(forNodeTime: nodeTime) {
            return Double(Double(playerTime.sampleTime) / playerTime.sampleRate)
        }
        return 0
    }
    
    @discardableResult private func prepareAudioSession() -> Bool {
        let avs = AVAudioSession.sharedInstance()
        do {
            try avs.setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
            try avs.setActive(true)
        } catch {
            return false
        }
        return true
    }
    
    @discardableResult private func cleanUpAudioSession() -> Bool {
        let avs = AVAudioSession.sharedInstance()
        do {
            try avs.setActive(false)
        } catch {
            return false
        }
        return true
    }
}

