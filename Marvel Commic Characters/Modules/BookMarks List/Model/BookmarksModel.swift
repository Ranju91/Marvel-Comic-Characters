//
//  CharacterDetailModel.swift
//  Marvel Commic Characters
//
//  Created by Apple on 05/09/22.
//

import Foundation
struct CharacterDetailModel {
    var name : String
    var comicNames : String
    var thumbnailPath : String
    var thumbnailExtension : String
    var id : Int64
    
    init(record: Any) {
         // initialize all properties, ie:
        self.name = (record as AnyObject).name ?? ""
        self.comicNames = (record as AnyObject).comicNames ?? ""
        self.thumbnailPath = (record as AnyObject).thumbnailPath ?? ""
        self.thumbnailExtension = (record as AnyObject).thumbnailExtension ?? ""
        self.id = (record as AnyObject).id 
    }
}
