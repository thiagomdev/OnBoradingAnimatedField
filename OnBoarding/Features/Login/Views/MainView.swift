//
//  MainView.swift
//  OnBoarding
//
//  Created by Thiago Monteiro on 24/01/22.
//

import UIKit

private struct Local {
    static let height: CGFloat           = 60
    static let tintColorValid: UIColor   = .systemGreen
    static let tintColorInValid: UIColor = .systemRed
    static let backgroundColor: UIColor  = .systemGray5
    static let foregroundColor: UIColor  = .systemGray
}

class FormFieldView: UIView {
    enum EditState {
        case valid
        case invalid
    }
    
    let label = UILabel()
    let invalidLabel = UILabel()
    var editState    = EditState.valid
    
    let textField    = UITextField()
    let cancelButton = makeSymbolButton(systemName: "clear.fill", target: self, selector: #selector(cancelTapped(_:)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Local.height)
    }
}

extension FormFieldView {
    func setup() {
        textField.delegate = self
    }
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor                           = Local.backgroundColor
        layer.cornerRadius                        = Local.height / 4
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textColor                                 = .systemGray
        self.label.text                                      = "Email"
        
        self.invalidLabel.translatesAutoresizingMaskIntoConstraints = false
        self.invalidLabel.textColor                                 = Local.tintColorInValid
        self.invalidLabel.text                                      = "Email is invalid"
        self.invalidLabel.font                                      = UIFont.preferredFont(forTextStyle: .caption1)
        self.invalidLabel.isHidden                                  = true
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.tintColor                                 = Local.tintColorValid
        self.textField.isHidden                                  = true
        
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.imageView?.tintColor                      = Local.foregroundColor
        self.cancelButton.isHidden                                  = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_: )))
        addGestureRecognizer(tap)
    }
    
    func layout() {
        self.addSubview(label)
        self.addSubview(invalidLabel)
        self.addSubview(textField)
        self.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            self.label.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.label.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            
            self.invalidLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            self.invalidLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            
            self.textField.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            self.trailingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 2),
            self.bottomAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 2),
            
            self.cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.trailingAnchor.constraint(equalToSystemSpacingAfter: cancelButton.trailingAnchor, multiplier: 2),
        ])
    }
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizer.State.ended) {
            if editState == .valid {
                self.enterEmailAnimation()
            }
        }
    }
}

extension FormFieldView {
    
    func enterEmailAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1,
                                                       delay: 0,
                                                       options: []) {
            self.backgroundColor     = .white
            self.label.textColor     = Local.tintColorValid
            self.layer.borderWidth   = 1
            self.layer.borderColor   = self.label.textColor.cgColor
            self.textField.tintColor = Local.tintColorValid
            
            let transpose        = CGAffineTransform(translationX: -8, y: -24)
            let scale            = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.label.transform = transpose.concatenating(scale)
            
        } completion: { position in
            self.textField.isHidden    = false
            self.textField.becomeFirstResponder()
            self.cancelButton.isHidden = false
        }
    }
}

extension FormFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let emailText = textField.text else { return }
        
        if isValidEmail(emailText) {
            self.undo()
        } else {
            self.showInvalidEmailMessage()
            textField.becomeFirstResponder()
        }
        
        textField.text = ""
    }
    
    func showInvalidEmailMessage() {
        self.label.isHidden        = true
        self.invalidLabel.isHidden = false
        layer.borderColor          = Local.tintColorInValid.cgColor
        self.textField.tintColor   = Local.tintColorInValid
        self.editState             = .invalid
    }
}

extension FormFieldView {
    func undo() {
        let size = UIViewPropertyAnimator(duration: 0.1, curve: .linear) {
            self.backgroundColor       = Local.backgroundColor
            self.label.textColor       = Local.foregroundColor
            self.layer.borderWidth     = 0
            self.layer.borderColor     = UIColor.clear.cgColor
            
            self.label.isHidden        = false
            self.invalidLabel.isHidden = true
            self.textField.isHidden    = true
            self.textField.text        = ""
            self.cancelButton.isHidden = true
            
            self.label.transform       = .identity
            
            self.editState             = .valid
        }
        size.startAnimation()
    }
    
    @objc func cancelTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        undo()
    }
}

func makeSymbolButton(systemName: String, target: Any, selector: Selector) -> UIButton {
    let configuration = UIImage.SymbolConfiguration(scale: .large)
    let image = UIImage(systemName: systemName, withConfiguration: configuration)
    
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(target, action: selector, for: .primaryActionTriggered)
    button.setImage(image, for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    return button
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

