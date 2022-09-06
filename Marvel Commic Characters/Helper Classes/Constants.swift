//
//  Contants.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 04/09/22.
//

import Foundation
import UIKit


let kMarvelsPublicKey = "9e0355f167a4e45ed011b1975aa27cea"
let kMarvelsPrivateKey = "8ce9435d36c83d68a3bc7a2b34ff80e02eab48c4"
let kConnectionErrorMsg = "Make sure your device is connected to the internet."
let kNetworkError = "Network error"
let kDBErrorMessage = "Some error occured while fetching your Local data. Please try again!"
let KDBErrorTitle = "Message"
let kEmptyBookmarkMessage = "You don't have any saved bookmarks. Please save bookmark from character detail page."
let kNoDataFound = "No data found"
let kAlertControllerTag:Int = 101

// API Request URL's
let kBaseUrl = "http://gateway.marvel.com/v1/public/"
let kGetComicList = kBaseUrl + "characters"
