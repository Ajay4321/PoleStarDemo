//
//  PSBookViewController.swift
//  PolestarDemo
//
//  Created by Ajay Awasthi on 04/03/22.
//

import UIKit

class PSBookViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var seachTableView: UITableView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    lazy var viewModel = {
        PSBookViewModel()
    }()
    
    var searchActive : Bool = false
    var searchString: String = ""
    var lastSearchString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func getBooks(_ sender: Any) {
        self.performSearch()
    }
    
    func performSearch() {
        self.searchBar.resignFirstResponder()
        
        if !searchActive && !self.searchString.isEmpty {
            let isValid = isValidString(string: self.searchString)
            if isValid {
                if self.lastSearchString != self.searchString {
                    self.lastSearchString = self.searchString
                    self.indicatorView.startAnimating()
                    viewModel.getBooks(searchText: self.searchString)
                    // Reload TableView closure
                    viewModel.reloadTableView = { [weak self] in
                        DispatchQueue.main.async {
                            self?.seachTableView.isHidden = false;
                            self?.indicatorView.stopAnimating()
                            if self?.viewModel.searchResult == .NotFound {
                                self?.showToastWithMessage("Search results not found.")
                            } else if self?.viewModel.searchResult == .Failed {
                                self?.showToastWithMessage("Search request failed.")
                            } else {
                                self?.seachTableView.reloadData()
                            }
                        }
                    }
                } else {
                    self.showToastWithMessage("You are searching again for same keyword.")
                }
            } else {
                self.showToastWithMessage("Please type some valid keyword in search input to search books.")
            }
        } else {
            self.showToastWithMessage("Please type some keyword in search input to search books.")
        }
    }
    
    func showToastWithMessage(_ message: String) {
        showToast(controller: self, message: message, duration: 2)
    }
}


//MARK: - UISearchBarDelegate

extension PSBookViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.performSearch()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = searchText
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= 30
    }
    
}


//MARK: - UITableViewDelegate

extension PSBookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

//MARK: - UITableViewDataSource

extension PSBookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookTableViewCell", for: indexPath) as? PSBookTableViewCell else{ fatalError("Cell Not Found")}
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.bookCellModel = cellVM
        return cell
    }
}

