//
//  PSNetworkManager.swift
//  PoleStarDemo
//
//  Created by Ajay Awasthi on 04/03/22.
//

import Foundation

protocol PolestarProtocol {
    func getBooks(queryString: String,completion: @escaping (_ success: Bool, _ results: Books?, _ error: String?) -> ())
}

class PSNetworkManager: PolestarProtocol {
    func getBooks(queryString: String, completion: @escaping (Bool, Books?, String?) -> ()) {
        PSHttpRequestHelper().GET(url: PSUrlConstants.BookSearchBaseURL, params: ["q": queryString], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(Initial.self, from: data!)
                    let booksData = model.docs
                    completion(true, booksData, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Books to model")
                }
            } else {
                completion(false, nil, "Error: Books GET Request failed")
            }
        }
    }
}


