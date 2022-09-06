//
//  BookmarksListVC.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 04/09/22.
//

import UIKit

class BookmarksListVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var tblVwBookmarkList: UITableView!
    
    //MARK: - Initialilizing ViewModel instance(Variable) for List of Characters
    var bookmarksListVM : BookmarksListVM?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetUp()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getBookmarks()
    }
    
    func configureUI() {
        self.tblVwBookmarkList.register(ComicCharacterCell.nib, forCellReuseIdentifier: ComicCharacterCell.indent)
    }
    
    func viewSetUp() {
        self.bookmarksListVM = BookmarksListVM()
        self.bookmarksListVM?.delegate = self
        self.bookmarksListVM?.bookmarksListVC = self
    }
    
    func getBookmarks() {
        self.bookmarksListVM?.getAllBookmarkedValues()
    }
}

//MARK: - TableView DataSource & Delegates
extension BookmarksListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalRecords = self.bookmarksListVM?.listofBooksmarks?.count ?? 0
        return (totalRecords > 0) ? totalRecords : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.bookmarksListVM?.listofBooksmarks?.isEmpty ?? true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell") ?? UITableViewCell()
            cell.selectionStyle = .none
            (cell.viewWithTag(1) as? UILabel)?.text = kEmptyBookmarkMessage
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ComicCharacterCell.indent) as! ComicCharacterCell
        cell.selectionStyle = .none
        cell.loadCellData(resultData: self.bookmarksListVM?.listofBooksmarks?[indexPath.row])
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.bookmarksListVM?.listofBooksmarks?.count ?? 0 > 0 {
            let viewControllerInstance = CharacterDetailVC.instance()
            viewControllerInstance.comicCharacterDetail = self.bookmarksListVM?.listofBooksmarks?[indexPath.row]
            self.navigationController?.pushViewController(viewControllerInstance, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalRecords = self.bookmarksListVM?.listofBooksmarks?.count ?? 0
        return (totalRecords > 0) ? UITableView.automaticDimension : tableView.bounds.size.height 
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let data = self.bookmarksListVM?.listofBooksmarks?[indexPath.row]
            self.bookmarksListVM?.removeBookmarkFromDatabase(idToDelete: data?.id ?? 0)
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}

//MARK: - Conforming to Protocol Functions
extension BookmarksListVC: BookmarksListVMProtocols {
    func fetchUpdatedListAndUpdateContent() {
        self.getBookmarks()
    }
    
    func updateContent() {
        DispatchQueue.main.async {
            self.tblVwBookmarkList.reloadData()
        }
    }
    
}
