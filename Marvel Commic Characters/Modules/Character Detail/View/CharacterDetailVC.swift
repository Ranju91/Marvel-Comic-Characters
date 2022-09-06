//
//  CharacterDetailVC.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 05/09/22.
//

import UIKit

class CharacterDetailVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tblVwCharacterDetail: UITableView!
    @IBOutlet weak var lblCharacterName: UILabel!
    @IBOutlet weak var imgVwCharacterLogo: UIImageView!
    @IBOutlet weak var btnMarkBookmark: UIButton!
    
    //MARK: - Variables
    var comicCharacterDetail : CharacterDetailModel?
    var comicCharacterName : [String] = []
    
    //MARK: - Initialilizing ViewModel instance(Variable) for List of Character detail
    var characterDetailVM : CharacterDetailVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.characterDetailVM = CharacterDetailVM()
        self.characterDetailVM?.characterDetailVC = self
        self.configureUI()
    }
    
    func configureUI() {
        self.imgVwCharacterLogo.layer.cornerRadius = 4.0
        self.btnMarkBookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.btnMarkBookmark.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        self.lblCharacterName.text = characterDetailVM?.characterName
        self.imgVwCharacterLogo?.loadImageFromCache(withUrl: characterDetailVM?.loadImgUrl ?? "")
        self.comicCharacterName = characterDetailVM?.comicNames ?? []
        self.characterDetailVM?.checkIfCharacterBookmarked()
    }
    
    @IBAction func btnBookmarkAct(_ sender: Any) {
        if self.btnMarkBookmark.isSelected {
            //Remove Bookmark
            self.characterDetailVM?.removeBookmarkFromDatabase()
        } else {
            //Add Bookmark
            self.characterDetailVM?.saveBookmarkInDatabase()
        }
    }
}

//MARK: Navigation Extension
extension CharacterDetailVC {
    class func instance()-> CharacterDetailVC {
        let detailStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        return detailStoryBoard.instantiateViewController(withIdentifier: "CharacterDetailVC") as! CharacterDetailVC
    }
}

//MARK: - TableView DataSource & Delegates
extension CharacterDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comicCharacterName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let name = self.comicCharacterName[indexPath.row]
        cell.textLabel?.text = name.isEmpty ? "Not found" : name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "COMIC CHARACTER NAMES (BELOW)"
    }
}
