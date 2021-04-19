//
//  SingleSanauAlert.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/14/21.
//

import UIKit

protocol SingleSanauAlertDelegate: class {
    func sanauAlertController(_ sanauAlertController: SingleSanauAlert, didOkButtonTapped okButton: UIButton)
    func sanauAlertController(_ sanauAlertController: SingleSanauAlert, didTapGestureTappeed tapGesture: UITapGestureRecognizer)
}

class SingleSanauAlert: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var alertBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var deviderView: UIView!
    
    // MARK: - Exteranal action
    
    weak var myDelegate: SingleSanauAlertDelegate?
    
    var okComplition: (() -> Void)?
 
    
    // MARK: - Object livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IBAction
 
    @IBAction func okButtonTapped(_ sender: UIButton) {
        okComplition?()
        myDelegate?.sanauAlertController(self, didOkButtonTapped: sender)
        animateOut {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        myDelegate?.sanauAlertController(self, didTapGestureTappeed: sender)
        animateOut {
            self.dismiss(animated: false, completion: nil)
        }
    }
}


// MARK: - Animation

extension SingleSanauAlert {
    func animateIn(animationComplition: @escaping () -> Void) {
        alertBackView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        backView.alpha = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut) {
            self.backView.alpha = 1
            self.alertBackView.transform = .identity
        } completion: { _ in
            animationComplition()
        }
    }
    
    func animateOut(animateComplition:@escaping () -> Void) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut) {
            self.alertBackView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.backView.alpha = 0
        } completion: { _ in
            animateComplition()
        }
    }
}

// MARK: - Setup UI

private extension SingleSanauAlert {
    func setupUI() {
        alertBackView.layer.cornerRadius = 30
        okButton.setTitle("Ok", for: .normal)
        okButton.setTitleColor(UIColor(named: "buttonTextColor"), for: .normal)
        titleLabel.textColor = UIColor(named: "alertTitleColor")
        logoImageView.changeColor(color: UIColor(named: "alertLogoColor"))
        deviderView.backgroundColor = UIColor(named: "alertLogoColor")
        descriptionLabel.textColor = UIColor(named: "alertDescriptionColor")
        alertBackView.backgroundColor = UIColor(named: "alertBackgroundColor")
        okButton.layer.cornerRadius = 22.5
        view.backgroundColor = .clear
    }
}
