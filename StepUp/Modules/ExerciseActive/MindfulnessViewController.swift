import UIKit
import FileKit
import App

class MindfulnessViewController: UIViewController, ExerciseResult {
    internal let audioPlayer: AudioPlayer
    
    private lazy var audioFileBodyScan: File? = {
        guard let item = try? FileKit.path(forResource: "bodyscan",
                                           withExtension: "mp3",
                                           inBundle: Bundle.main) else {
                                            return nil
        }
        return item
    }()
    
    private lazy var audioFileAdemRuimte: File? = {
        guard let item = try? FileKit.path(forResource: "ademruimte",
                                           withExtension: "mp3",
                                           inBundle: Bundle.main) else {
                                            return nil
        }
        return item
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
    
    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.light(withSize: 14)
        l.textAlignment = .center
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        var text = "Start het afspelen van de bodyscan of ademruimte oefening"
        text += " door op een van de onderstaande knoppen te drukken."
        l.text = text
        return l
    }()

    internal lazy var audioPlayerView: AudioPlayerView = {
        let v = AudioPlayerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        v.controlButton.setTitle("Afspelen", for: .normal)
        v.controlButton.setTitleColor(.buttonDisabled, for: .disabled)
        v.controlButton.isEnabled = false
        v.itemTitle.text = "Bodyscan"
        return v
    }()
    
    private lazy var bodyscanButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(songButtonTapped(sender:)), for: .touchUpInside)
        b.titleLabel?.font = UIFont.regular(withSize: 14)
        b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(.buttonDisabled, for: .highlighted)
        b.backgroundColor = .treamentButtonBackground
        b.layer.cornerRadius = 3
        b.setTitle("Bodyscan", for: .normal)
        b.tag = 1
        return b
    }()
    
    private lazy var ademruimteButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(songButtonTapped(sender:)), for: .touchUpInside)
        b.titleLabel?.font = UIFont.regular(withSize: 14)
        b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(.buttonDisabled, for: .highlighted)
        b.backgroundColor = .treamentButtonBackground
        b.layer.cornerRadius = 3
        b.setTitle("Ademruimte", for: .normal)
        b.tag = 2
        return b
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
        audioPlayer = AudioPlayer()
        super.init(nibName: nil, bundle: nil)
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
    
    func result() -> Exercise {
        return ExerciseMindfulness(value: [1, 1],
                                   weekDay: exercise.weekDay, weekNr: exercise.weekNr)
    }
    
    @objc private func songButtonTapped(sender: UIButton) {
        audioPlayerView.reset()
        switch sender.tag {
        case 1:
            audioPlayerView.itemTitle.text = "Bodyscan"
            prepareAudioPlayer(forAudioFile: audioFileBodyScan)
            return
        case 2:
            audioPlayerView.itemTitle.text = "Ademruimte"
            prepareAudioPlayer(forAudioFile: audioFileAdemRuimte)
            return
        default:
            return
        }
    }
    
    private func configure() {
        audioPlayer.configure { [weak self] _ in
            self?.audioPlayer.elapsedTime = { [weak self] time in
                self?.audioPlayerView.elapsedTime.text = String(format: "%02d:%02d", time.minute, time.second)
            }
            self?.prepareAudioPlayer(forAudioFile: self?.audioFileBodyScan)
            self?.audioPlayer.totalLength = { tl in
                self?.audioPlayerView.totalTime.text = String(format: "%02d:%02d", tl.minute, tl.second)
            }
            self?.audioPlayer.progress = { [weak self] ct, tt in
                self?.audioPlayerView.progress(totalTime: tt, elapsedTime: ct)
            }
        }
    }
    
    private func prepareAudioPlayer(forAudioFile: File?) {
        audioPlayerView.controlButton.isEnabled = false
        guard let file = forAudioFile else { return }
        audioPlayer.prepare(audioFilePath: file.path, completion: { [weak self] _ in
            self?.audioPlayerView.controlButton.isEnabled = true
        }, stopped: { [weak self] in
            self?.audioPlayerView.reset()
        })
    }
    
    private func setup() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(audioPlayerView)
        view.addSubview(bodyscanButton)
        view.addSubview(ademruimteButton)
    }
    
    // swiftlint:disable function_body_length
    private func applyConstraints() {
        let views: [String : Any] = ["titleLabel": titleLabel,
                                     "audioPlayerView": audioPlayerView,
                                     "ademruimteButton": ademruimteButton,
                                     "bodyscanButton": bodyscanButton,
                                     "descriptionLabel": descriptionLabel]
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: descriptionLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: titleLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: bodyscanButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: descriptionLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: ademruimteButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: descriptionLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: audioPlayerView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: bodyscanButton,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        NSLayoutConstraint.activate(constraints)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[descriptionLabel]-15-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        let buttonVF = "H:|-15-[bodyscanButton(==ademruimteButton)]-(>=25)-[ademruimteButton]-15-|"
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: buttonVF,
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[audioPlayerView]-15-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
    }
    // swiftlint:enable function_body_length
}

extension MindfulnessViewController: AudioPlayerDelegate {
    func controlPressed(player: AudioPlayerView) {
        if audioPlayer.isPlaying {
            audioPlayerView.controlButton.setTitle("Afspelen", for: .normal)
            audioPlayer.pause()
        } else {
            audioPlayerView.controlButton.setTitle("Pause", for: .normal)
            audioPlayer.play()
        }
    }
}
