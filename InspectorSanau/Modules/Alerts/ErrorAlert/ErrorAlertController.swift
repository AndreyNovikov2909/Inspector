//
//  ErrorAlertController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit

class ErrorAlertController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Object livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func animate(complition:@escaping () -> Void) {
        backView.transform = CGAffineTransform(translationX: 0, y: 100)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut) {
            self.backView.transform = CGAffineTransform(translationX: 0, y: -50)
        } completion: { (_) in
            
            UIView.animate(withDuration: 0.5,
                           delay: 3,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseInOut) {
                
                self.backView.transform = CGAffineTransform(translationX: 0, y: 100)
            } completion: { _ in
                self.dismiss(animated: false, completion: nil)

            }
        }

    }
}

// MARK: - Setup UI

private extension ErrorAlertController {
    func setupUI() {
        backView.layer.cornerRadius = 4
    }
}
