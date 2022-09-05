//
//  DataStoreManager.swift
//  Marvel Commic Characters
//
//  Created by Apple on 04/09/22.
//

import Foundation
import CoreData

class DataStoreManager {
    
    public static var shared: DataStoreManager! = nil
    var managedContext: NSManagedObjectContext
    
    private init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    public class func shared(context: NSManagedObjectContext) {
        if (self.shared == nil) {
            self.shared = DataStoreManager(context: context)
            self.shared.managedContext = context
        }
    }

    //MARK: - ********************* List of Comic Characters *********************
    public func saveComicCharactersList(id: Int, name: String, thumbnail:String, extensionUrl:String, comicNames:String) {
        // Create Entity
        
        let entity = NSEntityDescription.entity(forEntityName: "\(ListComicCharactersDB.self)", in: managedContext)
        // Initialize Record
       let record = ListComicCharactersDB(entity: entity!, insertInto: managedContext)
        record.id = Int64(id)
        record.name = name
        record.thumbnailPath = thumbnail
        record.thumbnailExtension = extensionUrl
        record.comicNames = comicNames
        managedContext.performAndWait {
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save, managedobject \(error), \(error.userInfo)")
            }
        }
    }
    
    public func fetchAllComicCharactersList() -> [CharacterDetailModel]? {
        let request: NSFetchRequest<ListComicCharactersDB> = ListComicCharactersDB.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            let model = result.map { CharacterDetailModel.init(record: $0) }
            return model
        } catch {
            print("fetch request failed, managedobject")
            return []
        }
    }
    
    public func fetchAllComicCharactersListForDeletion() -> [ListComicCharactersDB]? {
        let request: NSFetchRequest<ListComicCharactersDB> = ListComicCharactersDB.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            return result
        } catch {
            print("fetch request failed, managedobject")
            return []
        }
    }
    
    public func deleteAllComicCharactersList() {
        let savedItems = fetchAllComicCharactersListForDeletion()
        for savedItem in savedItems ?? [] {
            managedContext.performAndWait {
                managedContext.delete(savedItem)
               // try managedContext.save()
            }
        }
    }
    //********************* ListComicCharacters *********************
    
    
    //MARK: - Fetch List of all marked Bookmarks
    public func fetchAllBookmarkedList() -> [CharacterDetailModel] {
        let request: NSFetchRequest<BookmarkDB> = BookmarkDB.fetchRequest()
        request.returnsObjectsAsFaults = false
        let sectionSortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkDB.objectID), ascending: false)
        request.sortDescriptors = [sectionSortDescriptor]
        do {
            let result = try managedContext.fetch(request)
            let model = result.map { CharacterDetailModel.init(record: $0) }
            /*for data in result {
                print(data)
            }*/
            return model
        } catch {
            print("fetch request failed, managedobject")
            return []
        }
    }
    
    //MARK: - Add Bookmark
    public func saveBookmark(id: Int64, name: String, thumbnail:String, extensionUrl:String, comicNames:String, completion:(Bool)->()) {
        // Create Entity
        let entity = NSEntityDescription.entity(forEntityName: "\(BookmarkDB.self)", in: managedContext)
        // Initialize Record
       let record = BookmarkDB(entity: entity!, insertInto: managedContext)
        record.id = Int64(id)
        record.name = name
        record.thumbnailPath = thumbnail
        record.thumbnailExtension = extensionUrl
        record.comicNames = comicNames
        if record.id == 0 {
            completion(false)
        } else {
            managedContext.performAndWait {
                do {
                    try managedContext.save()
                    completion(true)
                } catch let error as NSError {
                    print("could not save, managedobject \(error), \(error.userInfo)")
                    completion(false)
                }
            }
        }
    }

    public func removeBookmark(id:Int64, completion:(Bool)->()) {
        let request : NSFetchRequest<BookmarkDB> = BookmarkDB.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %lld", id)
        request.fetchLimit = 1
        do {
            let results = try managedContext.fetch(request)
            if results.count > 0 {
                managedContext.delete(results.first!)
                try managedContext.save()
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
    
    public func checkCharacterBookmarked(id:Int64, completion:(Bool)->()) {
        let request : NSFetchRequest<BookmarkDB> = BookmarkDB.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", id)
        request.fetchLimit = 1
        do {
            let results = try managedContext.fetch(request)
            if results.count > 0 {
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
}
