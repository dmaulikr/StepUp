import UIKit

class EmailView: UIView {
    private lazy var title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.text = "Je oefeningen versturen"
        l.textColor = .black
        l.font = UIFont.light(withSize: 17)
        return l
    }()
    
    lazy var email: UITextField = {
        let s = UITextField()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.borderStyle = UITextBorderStyle.roundedRect
        s.placeholder = "E-mailadres van je therapeut"
        s.keyboardType = .emailAddress
        return s
    }()
    
    lazy var name: UITextField = {
        let s = UITextField()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.borderStyle = UITextBorderStyle.roundedRect
        s.placeholder = "Je naam"
        return s
    }()
    
    lazy var sendButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.regular(withSize: 14)
        b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(.buttonDisabled, for: .highlighted)
        b.backgroundColor = .treamentButtonBackground
        b.layer.cornerRadius = 3
        b.setTitle("Versturen", for: .normal)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        applyViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(title)
        addSubview(name)
        addSubview(email)
        addSubview(sendButton)
    }
    
    // swiftlint:disable function_body_length
    private func applyViewConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: title,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: title,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .left,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: title,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .right,
                                              multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: name,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: title,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        constraints.append(NSLayoutConstraint(item: name,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: title,
                                              attribute: .left,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: name,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .right,
                                              multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: email,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: name,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 5))
        constraints.append(NSLayoutConstraint(item: email,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: title,
                                              attribute: .left,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: email,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .right,
                                              multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: sendButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: email,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 5))
        constraints.append(NSLayoutConstraint(item: sendButton,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: title,
                                              attribute: .left,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: sendButton,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        NSLayoutConstraint.activate(constraints)
    }
    // swiftlint:enable function_body_length
}
