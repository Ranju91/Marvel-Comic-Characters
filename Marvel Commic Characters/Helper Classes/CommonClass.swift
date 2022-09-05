//
//  CommonClass.swift
//  Marvel Commic Characters
//
//  Created by Apple on 04/09/22.
//

import UIKit
import Foundation
import CryptoKit

//MARK: - Displaying Alert Message
func showAlertViewController(title : String,messsage: String) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let alertController = UIAlertController(title: title, message: messsage, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
    }
    alertController.addAction(okAction)
    appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
}

//MARK: - Genrate hash from Cryptokit
func md5Hash(_ source: String) -> String {
    let digest = Insecure.MD5.hash(data: source.data(using: .utf8) ?? Data())
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
