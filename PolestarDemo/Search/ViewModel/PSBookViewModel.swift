//
//  PSBookViewModel.swift
//  PolestarDemo
//
//  Created by Ajay Awasthi on 04/03/22.
//

import Foundation

class PSBookViewModel: NSObject {
    
    enum SearchResult {
        case Found
        case NotFound
        case Failed
    }
    
    var searchResult: SearchResult?
    private var bookService: PolestarProtocol
    
    var reloadTableView: (() -> Void)?
    
    var books = Books()
    
    var bookCellViewModels = [PSBookCellModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    init(bookService: PolestarProtocol = PSNetworkManager()) {
        self.bookService = bookService
    }
    
    func getBooks(searchText: String) {
        
        let dbObject = PSDBHelper.shared
        let results =  dbObject.searchBook(searchString: searchText)
        if results.count > 0{
            self.fetchData(book: results, searchString: searchText, shouldSave: false)
        } else {
            bookService.getBooks(queryString: searchText) { [weak self] success, model, error in
                if success, let books = model {
                    let filterArray = books.count >= 10 ? Array(books[0...9]) : books
                    self?.searchResult = filterArray.count == 0 ? .NotFound : .Found
                    self?.fetchData(book: filterArray, searchString: searchText, shouldSave: true)
                } else {
                    self?.searchResult = .Failed
                    print(error!)
                }
            }
        }
        
    }
    
    func fetchData(book: Books, searchString: String, shouldSave: Bool) {
        self.books = book // Cache
        var vms = [PSBookCellModel]()
        let dbObject = PSDBHelper.shared
        for book in books {
            if shouldSave {
                dbObject.insertBookResult(book: book, searchString: searchString)

            }
            vms.append(createCellModel(book: book))
        }
        DispatchQueue.main.async {
            self.bookCellViewModels = vms
        }
    }
    
    func createCellModel(book: Doc) -> PSBookCellModel {
        let title = book.title!
        let authorName = book.author_name?[0]
        let publishDate = book.publish_date?[0]
        let imageUrl = book.isbn?[0]
        return PSBookCellModel(title: title, authorName: authorName, publish_date: publishDate, imageUrl: imageUrl)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PSBookCellModel {
        return bookCellViewModels[indexPath.row]
    }
}
