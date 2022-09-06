//
//  ListComicCharactersVC.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 04/09/22.
//

import UIKit

class ListComicCharactersVC: UIViewController {
    
    //MARK: - IBOutlets Connection
    @IBOutlet weak var tblVwCharactersList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let refreshControl = UIRefreshControl()
    
    //MARK: - Initialilizing ViewModel instance(Variable) for List of Characters
    var characterListVM = ComicCharactersListVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetUp()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblVwCharactersList.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    func configureUI() {
        self.tblVwCharactersList.register(ComicCharacterCell.nib, forCellReuseIdentifier: ComicCharacterCell.indent)
    }
    
    func viewSetUp() {
        self.characterListVM.delegate = self
        self.startLoadingActivityIndicator()
        self.characterListVM.checkDatabaseIfDataExists()
        
        //Refresh Control Setup
        if #available(iOS 10.0, *) {
            tblVwCharactersList.refreshControl = refreshControl
        } else {
            tblVwCharactersList.addSubview(refreshControl)
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...")
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        characterListVM.getComicCharactersList()
    }
}

//MARK: - Conforming to Protocol Functions
extension ListComicCharactersVC: ComicCharactersListVMProtocols {

    //MARK: - Handle Success Response of API (code - 200)
    func handleSuccessResponse() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.stopLoadingActivityIndicator()
            self.tblVwCharactersList.reloadData()
        }
        debugPrint("success")
    }
    
    //MARK: - Handle Nil Response of API (Either code error or data error)
    func handleNilResponse() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.stopLoadingActivityIndicator()
        }
        debugPrint("failure")
    }
}

//MARK: - TableView DataSource & Delegates
extension ListComicCharactersVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !InternetConnectCheckClass.isConnectedToNetwork() && self.characterListVM.filteredCharacterDetailModel?.count ?? 0 == 0 {
            return 1
        }
        let totalRecords = self.characterListVM.characterDetailModel?.count ?? 0
        return (totalRecords > 0) ? totalRecords : ((searchBar.text?.isEmpty ?? true) ? totalRecords : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.characterListVM.characterDetailModel?.isEmpty ?? true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell") ?? UITableViewCell()
            cell.selectionStyle = .none
            if !InternetConnectCheckClass.isConnectedToNetwork() && self.characterListVM.filteredCharacterDetailModel?.count ?? 0 == 0 {
                (cell.viewWithTag(1) as? UILabel)?.text = kConnectionErrorMsg
            } else {
                (cell.viewWithTag(1) as? UILabel)?.text = kNoDataFound
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ComicCharacterCell.indent) as! ComicCharacterCell
        cell.selectionStyle = .none
        cell.loadCellData(resultData:  self.characterListVM.characterDetailModel?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalRecords = self.characterListVM.characterDetailModel?.count ?? 0
        return (totalRecords > 0) ? UITableView.automaticDimension : tableView.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.characterListVM.characterDetailModel?.count ?? 0 > 0 {
            let viewControllerInstance = CharacterDetailVC.instance()
            viewControllerInstance.comicCharacterDetail = self.characterListVM.characterDetailModel?[indexPath.row]
            self.navigationController?.pushViewController(viewControllerInstance, animated: true)
        }
    }
}

extension ListComicCharactersVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.characterListVM.filterContent(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
