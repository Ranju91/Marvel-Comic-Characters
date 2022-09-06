//
//  ComicCharacterCell.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 04/09/22.
//

import UIKit
import CoreData
class ComicCharacterCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet weak var lblChracterName: UILabel!
    @IBOutlet weak var imgVwLogo: UIImageView!
    
    //MARK: Defining Variables
    static let nib = UINib.init(nibName: "ComicCharacterCell", bundle: nil)
    static let indent = "cell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgVwLogo.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Configure Data
    func configureBookmarkList(resultData : BookmarkDB?) {
      //  let structData = CharacterDetailModel(name: resultData?.name ?? "", comicNames: resultData?.comicNames ?? "", thumbnailPath: resultData?.thumbnailPath ?? "", thumbnailExtension: resultData?.thumbnailExtension ?? "", id: resultData?.id ?? 0)
       // self.loadCellData(resultData: structData)
    }
    
    func loadCellData(resultData : CharacterDetailModel?) {
        self.lblChracterName.text = resultData?.name ?? ""
        if let path = resultData?.thumbnailPath, let imageExtension = resultData?.thumbnailExtension {
            // can set default image
            let imageURLString = path + ".\(imageExtension)"
            self.imgVwLogo?.loadImageFromCache(withUrl: imageURLString)
        }
    }
}
