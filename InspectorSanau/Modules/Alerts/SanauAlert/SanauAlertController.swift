//
//  SanauAlertController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/14/21.
//

import UIKit

protocol SanauAlertControllerDelegate: class {
    func sanauAlertController(_ sanauAlertController: SanauAlertController, didOkButtonTapped okButton: UIButton)
    func sanauAlertController(_ sanauAlertController: SanauAlertController, didCancelButtonTapped cancelButton: UIButton)
    func sanauAlertController(_ sanauAlertController: SanauAlertController, didTapGestureTappeed tapGesture: UITapGestureRecognizer)
}

class SanauAlertController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var alertBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    // MARK: - Exteranal action
    
    weak var myDelegate: SanauAlertControllerDelegate?
    
    var okComplition: (() -> Void)?
 
    
    // MARK: - Object livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        myDelegate?.sanauAlertController(self, didCancelButtonTapped: sender)
        animateOut {
            self.dismiss(animated: false, completion: nil)
        }
    }
 
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

extension SanauAlertController {
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

private extension SanauAlertController {
    func setupUI() {
        alertBackView.layer.cornerRadius = 20
    
        okButton.setTitle("ДА", for: .normal)
        cancelButton.setTitle("НЕТ", for: .normal)
        
        okButton.layer.cornerRadius = 22.5
        cancelButton.layer.cornerRadius = 22.5
        
        view.backgroundColor = .clear
    }
}
