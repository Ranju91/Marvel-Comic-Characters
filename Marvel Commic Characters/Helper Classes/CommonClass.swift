//
//  CommonClass.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 04/09/22.
//

import UIKit
import Foundation
import CryptoKit


//MARK: - Genrate hash from Cryptokit
func md5Hash(_ source: String) -> String {
    let digest = Insecure.MD5.hash(data: source.data(using: .utf8) ?? Data())
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
