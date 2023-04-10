//
//  UIViewController+Extension.swift
//  YOUMAWO
//
//  Created by Andreas Wörner on 23.02.19.
//  Copyright © 2019 YOUMAWO. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func configureNavigationController() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .clear
    }
    
    func canUseVTO() -> Bool {
        return UserManager.currentUser?.isUserAllowedToUseVTO ?? false
    }
    
    @objc func createNextButton() -> UIBarButtonItem {
        UIBarButtonItem(title: Localization.shared.getLocalizedString(forKey: "navigation_next_button_title") ?? "", style: .plain, target: self, action: nil)
    }
    
    func createProgressBarView(step: Float, ofStep: Float) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 10.0))
        let progress = step/ofStep
        
        let progressBar = UIProgressView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 10.0))
        progressBar.barHeight = 10
        progressBar.setProgress(progress, animated: false)
        progressBar.progressTintColor = UIColor.mfDarkBlue
        progressBar.backgroundColor = UIColor.clear
        containerView.addSubview(progressBar)
        containerView.backgroundColor = .clear
        
        return containerView
    }
    
    // MARK: - Close buttons.
    
    func createCloseButton() -> UIBarButtonItem {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        closeButton.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        return UIBarButtonItem(customView: closeButton)
    }
    
    func createCloseButtonWithPopUp() -> UIBarButtonItem {
        return UIBarButtonItem(title: Localization.shared.getLocalizedString(forKey: "navigation_cancel_button_title"),
                               style: .plain, target: self, action: #selector(self.closeVcWithPopUp))
    }
    
    @objc private func closeVcWithPopUp() {
        self.createClosePopUpAlert()
    }
    
    @objc func createClosePopUpAlert() {
        let title = Localization.shared.getLocalizedString(forKey: "close_popup_question")
        
        let alert = UIAlertController(title: Localization.shared.getLocalizedString(forKey: title),
                                      message: nil,
                                      preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: Localization.shared.getLocalizedString(forKey: "close_popup_yes"),
                                        style: .default,
                                        handler: { (UIAlertAction) in
            self.closeVC()
        })
        
        let cancelAction = UIAlertAction(title: Localization.shared.getLocalizedString(forKey: "close_popup_cancel"),
                                         style: .destructive,
                                         handler: { (UIAlertAction) in })
        alert.addAction(closeAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func createRoundedCloseButton() -> UIButton {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        let size: CGFloat = 40
        closeButton.backgroundColor = .clear
        closeButton.layer.cornerRadius = size / 2
        return closeButton
    }
    
    func createPlainCloseButton() -> UIButton {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .gray10
        closeButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        closeButton.frame = CGRect(x: 0, y: 0, width: 26, height: 20)
        return closeButton
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true)
    }
    
    func createPlainBackButton() -> UIButton {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        return backButton
    }
    
    @objc private func backToPreviuosController() {
        self.navigationController?.popViewController(animated: true)
    }
}
