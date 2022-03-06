//
//  PSDBHelper.swift
//  PolestarDemo
//
//  Created by Ajay Awasthi on 05/03/22.
//

import Foundation
import SQLite3

class PSDBHelper: NSObject {
    
    static let shared = PSDBHelper()
    var db: OpaquePointer?
    
    
    private override init() {
        super.init()
        db = openDatabase()
    }
    
    func openDatabase() -> OpaquePointer? {
    var db: OpaquePointer?
    let dbPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0].appending("/Database/Book.db")
    
    if sqlite3_open(dbPath, &db) == SQLITE_OK {
        return db
      } else {
        sqlite3_close(db)
        db = nil
        return db
      }
    }
    
    //MARK: Activity
    func insertBookResult(book : Doc, searchString: String) {
    let insertStatementString = "INSERT INTO book_entry (title, authorName, publishDate, imageUrl, searchString) VALUES (?, ?, ?, ?, ?)"

        var status : Bool = false
        var insertStatement: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
            SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, book.title, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 2, book.author_name?[0], -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 3, book.publish_date?[0], -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 4, book.isbn?[0], -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 5, searchString, -1, SQLITE_TRANSIENT)

          if sqlite3_step(insertStatement) == SQLITE_DONE {
            status = true
          } else {
            status = false
          }
        } else {
            status = false
        }
        sqlite3_finalize(insertStatement)
    }
    
    func searchBook(searchString: String) -> [Doc] {
        let queryStatementString = NSString.init(format: "SELECT * FROM book_entry where searchString = '%@'", searchString)
        var allBooks : [Doc] = []
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString.utf8String, -1, &queryStatement, nil) ==
              SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let title = sqlite3_column_text(queryStatement, 0) == nil ? "" : String(cString: sqlite3_column_text(queryStatement, 0))
                let authorName = sqlite3_column_text(queryStatement, 1) == nil ? "" : String(cString: sqlite3_column_text(queryStatement, 1))
                let publishDate = sqlite3_column_text(queryStatement, 2) == nil ? "" : String(cString: sqlite3_column_text(queryStatement, 2))
                let imageUrl = sqlite3_column_text(queryStatement, 3) == nil ? "" : String(cString: sqlite3_column_text(queryStatement, 3))
                
                var book = Doc.init()

                book.title = title
                book.author_name?.append(authorName)
                book.publish_date?.append(publishDate)
                book.isbn?.append(imageUrl)
                allBooks.append(book)
          }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return allBooks
    }
}
