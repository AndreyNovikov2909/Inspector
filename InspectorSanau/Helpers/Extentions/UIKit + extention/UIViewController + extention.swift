//
//  UIViewController + extention.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/14/21.
//

import UIKit


// MARK: - Error Alert

extension UIViewController {
    @discardableResult
    func errorAlert(title: String) -> UIView {
        let errorAlert: ErrorAlertController = UIStoryboard.loadViewController()
        errorAlert.modalPresentationStyle = .overCurrentContext
        errorAlert.modalTransitionStyle = .crossDissolve
        
        present(errorAlert, animated: false) {
            errorAlert.animate {
                errorAlert.dismiss(animated: false, completion: nil)
            }
        }
        
        errorAlert.titleLabel.text = title
        return errorAlert.view
    }
}

// MARK: - Single alert

extension UIViewController {
    func singlerAlert(title: String, description: String, buttonTitle: String = "Понятно", delegate: SingleSanauAlertDelegate? = nil) {
        let singleSanauAlert: SingleSanauAlert = UIStoryboard.loadViewController()
        singleSanauAlert.modalPresentationStyle = .overCurrentContext
        singleSanauAlert.modalTransitionStyle = .crossDissolve
        present(singleSanauAlert, animated: false) {
            singleSanauAlert.animateIn {
                
            }
        }
        
        singleSanauAlert.titleLabel.text = title
        singleSanauAlert.descriptionLabel.text = description
        singleSanauAlert.okButton.setTitle(buttonTitle, for: .normal)
        singleSanauAlert.myDelegate = delegate
    }
}


// MARK: - Alert

extension UIViewController {
    func alert(title: String, message: String, complition: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            complition?()
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, actionTitle: String, complition:@escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .destructive) { (_) in
            complition()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .default)
        
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - Init from storyboard

extension UIViewController {
    class func loadFromStroryboard<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: String(describing: T.self)) as? T  else {
            fatalError("Storyboard, storyboard identifire and view controller should havee same name, name: \(String(describing: T.self))")
        }
        return viewController
    }
    
    class func instantiate<T: UIViewController>(from storyboard: UIStoryboard, identifire: String) -> T {
        guard let viewController = storyboard.instantiateViewController(identifier: identifire) as? T else {
            fatalError("Indentifier: \(identifire) doosen't containts in storyboard \(#function)")
        }
        
        return viewController
    }
    
    class func instantiate(from storyboard: UIStoryboard) -> Self {
        return instantiate(from: storyboard, identifire: String(describing: self))
    }
    
    class func instantiate() -> Self {
        let className = String(describing: self)
        return instantiate(from: UIStoryboard(name: className, bundle: Bundle(for: self)), identifire: className)
    }
}


