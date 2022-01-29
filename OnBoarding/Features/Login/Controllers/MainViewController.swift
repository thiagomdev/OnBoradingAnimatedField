//
//  MainViewController.swift
//  OnBoarding
//
//  Created by Thiago Monteiro on 24/01/22.
//

import UIKit

class MainViewController: UIViewController {
    
    let stackView     = UIStackView()
    let formFieldView = FormFieldView()
    let undoButton    = makeButton(withText: "Undo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.style()
        self.layout()
    }
}

extension MainViewController {
    func style() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis                                      = .vertical
        self.stackView.spacing                                   = 20
        self.stackView.alignment                                 = .leading
        
        undoButton.addTarget(self, action: #selector(undoTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        self.stackView.addArrangedSubview(formFieldView)
        self.stackView.addArrangedSubview(undoButton)
        
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.formFieldView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: formFieldView.trailingAnchor, multiplier: 2),
            self.undoButton.heightAnchor.constraint(equalTo: formFieldView.heightAnchor),
            self.undoButton.widthAnchor.constraint(equalTo: formFieldView.widthAnchor),
        ])
    }
}

extension MainViewController {
    @objc func undoTapped() {
        self.formFieldView.undo()
    }
}

func makeButton(withText text: String) -> UIButton {
    let button                                       = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.titleLabel?.adjustsFontSizeToFitWidth     = true
    button.contentEdgeInsets                         = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    button.backgroundColor                           = .systemBlue
    button.layer.cornerRadius                        = 60 / 4
    return button
}

