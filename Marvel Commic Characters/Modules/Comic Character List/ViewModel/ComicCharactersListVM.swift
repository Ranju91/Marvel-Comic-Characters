//
//  ComicCharactersListVM.swift
//  Marvel Commic Characters
//
//  Created by Apple on 04/09/22.
//

import Foundation
import CoreData
//MARK: ViewModel Protocols
protocol ComicCharactersListVMProtocols: AnyObject {
    func handleSuccessResponse()
    func handleNilResponse()
}

class ComicCharactersListVM {
    //MARK: Defining Variables
    weak var delegate : ComicCharactersListVMProtocols?
    var characterDetailModel : [CharacterDetailModel]?
    var filteredCharacterDetailModel : [CharacterDetailModel]?
    
    // MARK: Output Events
    var reloadTable: () -> () = { }
    
    //MARK: - Check database & Maintain API Call
    func checkDatabaseIfDataExists() {
        guard let details =  DataStoreManager.shared.fetchAllComicCharactersList() else {
            self.getComicCharactersList()
            return
        }
        if !details.isEmpty {
            self.characterDetailModel = details
            self.filteredCharacterDetailModel = self.characterDetailModel
            self.delegate?.handleSuccessResponse()
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.getComicCharactersList()
        }
    }
    
    //MARK: - Calling an API to get Marvel's comic characters list with detail
    func getComicCharactersList() {
        let ts = String(Int(Date().timeIntervalSinceNow))
        let hash = md5Hash("\(ts)\(kMarvelsPrivateKey)\(kMarvelsPublicKey)")
        let params = ["ts": ts, "apikey":kMarvelsPublicKey, "hash":hash]
        APIRequest.init().GETRequestCall(url: kGetComicList, params: params) { [weak self] response in
            guard let responseValue = response else {
                self?.delegate?.handleNilResponse()
                return
            }
            let jsonDecoder = JSONDecoder()
            let comicCharactersModel = try? jsonDecoder.decode(ComicModel.self, from: responseValue)
            // DataBase Management ***********
            //Save Data In database (Firstly Clear all Data)
            DataStoreManager.shared.deleteAllComicCharactersList()
            for record in comicCharactersModel?.data?.results ?? [] {
                let comicRecords = record.comicsDetail?.items ?? []
                let comicRecordNames = comicRecords.map { $0.name ?? ""}.joined(separator: ",")
                DataStoreManager.shared.saveComicCharactersList(id: record.id ?? 0, name: record.name ?? "", thumbnail: record.thumbnail?.path ?? "", extensionUrl: record.thumbnail?.extensionValue ?? "",comicNames:comicRecordNames)
            }
            // ***********
            self?.characterDetailModel =  DataStoreManager.shared.fetchAllComicCharactersList()
            self?.filteredCharacterDetailModel = self?.characterDetailModel
            self?.delegate?.handleSuccessResponse()
            /* do{
                // here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with: response!, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                debugPrint(parsingError.localizedDescription)
            } */
        }
    }
}

//MARK: - Search tasks
extension ComicCharactersListVM {
    func filterContent(searchText:String) {
        self.characterDetailModel = searchText.isEmpty ? self.filteredCharacterDetailModel : self.filteredCharacterDetailModel?.filter({ $0.name.localizedCaseInsensitiveContains(searchText) })
        self.delegate?.handleSuccessResponse()
    }
}
