import UIKit

final class LoaderView: UIView {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let l = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.color = .baseGreen
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        applyViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        activityIndicator.startAnimating()
    }
    
    func stop() {
        activityIndicator.stopAnimating()
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(activityIndicator)
    }
    
    private func applyViewConstraints() {
        let views: [String: Any] = ["activityIndicator": activityIndicator]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[activityIndicator]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[activityIndicator]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views))
    }
}



