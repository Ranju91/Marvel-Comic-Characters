//
//  ExtensionViewController.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 05/09/22.
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
    
    //MARK: - Displaying Alert Message
    func showAlertViewController(title : String,messsage: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let alertController = UIAlertController(title: title, message: messsage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
