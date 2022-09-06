//
//  CharacterDetailVM.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 05/09/22.
//

import Foundation
import CoreData
import UIKit

class CharacterDetailVM  {
    var characterDetailVC = CharacterDetailVC()    
    
    var comicNames: [String] {
        var detail = self.characterDetailVC.comicCharacterDetail?.comicNames.components(separatedBy: ",") ?? []
        if detail.count > 5 {
            detail = Array(detail.prefix(5))
        }
        return detail
    }
    
    var loadImgUrl : String? {
        if let path = self.characterDetailVC.comicCharacterDetail?.thumbnailPath, let imageExtension = self.characterDetailVC.comicCharacterDetail?.thumbnailExtension {
            // can set default image
            let imageURLString = path + ".\(imageExtension)"
            return imageURLString
        }
        return ""
    }
    
    var characterName : String? {
        return self.characterDetailVC.comicCharacterDetail?.name ?? ""
    }
    
    
    func checkIfCharacterBookmarked() {
        let detail = self.characterDetailVC.comicCharacterDetail
        DataStoreManager.shared.checkCharacterBookmarked(id: Int64(detail?.id ?? 0)) { isBookMarked in
            self.characterDetailVC.btnMarkBookmark.isSelected = isBookMarked
        }
    }
    
    func saveBookmarkInDatabase() {
        let detail = self.characterDetailVC.comicCharacterDetail
        DataStoreManager.shared.saveBookmark(id: Int64(detail?.id ?? 0), name: detail?.name ?? "", thumbnail: detail?.thumbnailPath ?? "", extensionUrl: detail?.thumbnailExtension ?? "", comicNames: detail?.comicNames ?? "") { isSucceded in
            if isSucceded {
                self.characterDetailVC.btnMarkBookmark.isSelected = true
                self.characterDetailVC.showAlertViewController(title: "Saved Successfully", messsage: "")
            } else {
                self.characterDetailVC.showAlertViewController(title: KDBErrorTitle, messsage: kDBErrorMessage)
            }
        }
    }
    
    func removeBookmarkFromDatabase() {
        let detail = self.characterDetailVC.comicCharacterDetail
        DataStoreManager.shared.removeBookmark(id: Int64(detail?.id ?? 0)) { isSucceded in
            if isSucceded {
                self.characterDetailVC.btnMarkBookmark.isSelected = false
                self.characterDetailVC.showAlertViewController(title: "Removed Successfully", messsage: "")
            } else {
                self.characterDetailVC.showAlertViewController(title: KDBErrorTitle, messsage: kDBErrorMessage)
            }
        }
    }
}
