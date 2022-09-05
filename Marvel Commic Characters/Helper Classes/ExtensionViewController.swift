//
//  ExtensionViewController.swift
//  Marvel Commic Characters
//
//  Created by Apple on 05/09/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func startLoadingActivityIndicator() {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .large)
        activityIndicator.tag = kAlertControllerTag
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
    }
    
    func stopLoadingActivityIndicator() {
        if let activityIndicator = self.view.subviews.filter({$0.tag == kAlertControllerTag}).first as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
