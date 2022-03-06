//
//  PSBookModel.swift
//  PolestarDemo
//
//  Created by Ajay Awasthi on 04/03/22.
//

import Foundation

typealias Books = [Doc]

struct Initial: Decodable {
    
    let docs: [Doc]
    let q: String
}

struct Doc: Decodable {
    
    var title: String?
    var publish_date: Array<String>?
    var isbn: Array<String>?
    var author_name: Array<String>?
    
     init(){
        self.title = ""
        self.publish_date = []
        self.isbn = []
        self.author_name = []
    }
}
