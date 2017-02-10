import UIKit
import AVFoundation
import FileKit

class MindfulnessViewController: UIViewController, AVAudioPlayerDelegate {
    private let audioPlayer: AudioPlayer
    
    private lazy var audioFileBodyScan: AVAudioFile? = {
        guard let item = try? FileKit.path(forResource: "bodyscan",
                                           withExtension: "mp3",
                                           inBundle: Bundle.main) else {
                                            return nil
        }
        return try? AVAudioFile(forReading: item.path)
    }()
    
    private lazy var audioFileAdemRuimte: AVAudioFile? = {
        guard let item = try? FileKit.path(forResource: "ademruimte",
                                           withExtension: "mp3",
                                           inBundle: Bundle.main) else {
                                            return nil
        }
        return try? AVAudioFile(forReading: item.path)
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.regular(withSize: 20)
        l.textAlignment = .center
        l.text = "Mindfulness"
        return l
    }()
    
    private lazy var currentPlayingTime: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.regular(withSize: 20)
        l.textAlignment = .center
        l.text = "0"
        return l
    }()
    
    private var timeObserverToken: Any?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        audioPlayer = AudioPlayer()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        applyConstraints()
        configure()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func configure() {
        do {
            try audioPlayer.configure()
            audioPlayer.elapsedTime = { [weak self] time in
                self?.currentPlayingTime.text = String(format: "%02d:%02d", time.minute, time.second)
            }
            audioPlayer.prepare(audio: audioFileBodyScan!) { [weak self] in
                self?.audioPlayer.play()
            }
        }
        catch {
            print("error configuring audio player")
        }
    }
    
    private func setup() {
        view.addSubview(titleLabel)
        view.addSubview(currentPlayingTime)
    }
    
    private func applyConstraints() {
        let views: [String : Any] = ["titleLabel": titleLabel,
                                     "currentPlayingTime": currentPlayingTime]
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: currentPlayingTime,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: titleLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        NSLayoutConstraint.activate(constraints)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[currentPlayingTime]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
    }
}
