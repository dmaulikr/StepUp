import Foundation
import AVFoundation

struct Time {
    let day: Int
    let hour: Int
    let minute: Int
    let second: Int
}

extension Time {
    init(_ timeInterval: TimeInterval) {
        day = Int(timeInterval / (24 * 3600))
        hour = Int(timeInterval.truncatingRemainder(dividingBy:(24 * 3600))) / 3600
        minute = Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60
        second = Int(timeInterval.truncatingRemainder(dividingBy: 60))
    }
}

extension Time: Equatable {
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.day == rhs.day &&
            lhs.hour == rhs.hour &&
            lhs.minute == rhs.minute &&
            lhs.second == rhs.second
    }
}

class AudioPlayer {
    private let engine: AVAudioEngine
    private let playerNode: AVAudioPlayerNode
    private let mixer: AVAudioMixerNode
    private var audio: AVAudioFile?
    var elapsedTime: ((Time) -> ())?
    var totalLength: ((TimeInterval) -> ())?
    
    init() {
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        mixer = engine.mainMixerNode
        engine.attach(playerNode)
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
    
    func configure() throws {
        engine.connect(playerNode, to: mixer, format: nil)
        engine.inputNode?.installTap(onBus: 0,
                                     bufferSize: 1024,
                                     format: mixer.inputFormat(forBus: 0),
                                     block: { [weak self] (b: AVAudioPCMBuffer, at: AVAudioTime) in
                                        if let closure = self?.elapsedTime,
                                            let currentTime = self?.currentTime() {
                                            DispatchQueue.main.async {
                                                closure(Time(currentTime))
                                            }
                                        }
        })
        try engine.start()
    }
    
    func play() {
        playerNode.play()
        if let closure = totalLength {
            closure(totalTime())
        }
    }
    
    func pause() {
        playerNode.pause()
    }
    
    func prepare(audio: AVAudioFile, completion: @escaping () -> ()) {
        self.audio = audio
        playerNode.reset()
        DispatchQueue.global().async { [weak self] in
            self?.prepareAudioSession()
            self?.playerNode.scheduleFile(audio, at: nil, completionHandler: nil)
            self?.playerNode.prepare(withFrameCount: 45)
            DispatchQueue.main.async {
                completion()
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

