//
//  ViewController.swift
//  Good ideas Book Club
//
//  Created by JeremyXue on 2018/10/9.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    fileprivate let bookshelfUrl = "https://bookshelf.goodideas-studio.com/api"
    
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBooks()
    }
    
    func getBooks(){
        guard let url = URL(string: bookshelfUrl) else { return }
        
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let list = json["list"].arrayValue
                var books = [Book]()
                for bookJson in list {
                    let book = Book(json: bookJson)
                    books.append(book)
                }
                self.books = books
                print(self.books)
            case .failure(let error):
                print(error)
            }
        }
    }
}

