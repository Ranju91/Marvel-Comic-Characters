//
//  BookmarksListVM.swift
//  Marvel Commic Characters
//
//  Created by Apple on 05/09/22.
//

import Foundation
import CoreData
//MARK: ViewModel Pr

protocol BookmarksListVMProtocols: AnyObject {
    func updateContent()
    func fetchUpdatedListAndUpdateContent()
}

class BookmarksListVM {
    //MARK: Defining Variables
    var listofBooksmarks : [CharacterDetailModel]?
    weak var delegate : BookmarksListVMProtocols?
    
    //MARK: - Check database & Maintain API Call
    func getAllBookmarkedValues() {
        self.listofBooksmarks =  DataStoreManager.shared.fetchAllBookmarkedList()
        self.delegate?.updateContent()
    }
    
    func removeBookmarkFromDatabase(idToDelete:Int64) {
        DataStoreManager.shared.removeBookmark(id: Int64(idToDelete)) { isSucceded in
            if isSucceded {
                self.delegate?.fetchUpdatedListAndUpdateContent()
              //  showAlertViewController(title: "Removed Successfully", messsage: "")
            } else {
                showAlertViewController(title: KDBErrorTitle, messsage: kDBErrorMessage)
            }
        }
    }
}
