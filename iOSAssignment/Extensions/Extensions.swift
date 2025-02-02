//
//  Extensions.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import Foundation
import UIKit

extension UIView {
    /// Round View conners
    func roundView() {
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
    }
}
extension UIViewController {
    
    /// Show Alert Popup
    func alert(message: String, title: String = "Error") {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(OKAction)
           self.present(alertController, animated: true, completion: nil)
       }
}

extension Notification.Name {
    static let internetConnectionRestored = Notification.Name("internetConnectionRestored")
}

extension UINavigationBar {
    func addShadow() {
        // Remove any existing shadow layer
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
}
