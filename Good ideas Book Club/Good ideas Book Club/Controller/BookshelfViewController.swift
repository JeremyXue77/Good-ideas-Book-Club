//
//  BookshelfViewController.swift
//  Good ideas Book Club
//
//  Created by JeremyXue on 2018/10/13.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BookshelfViewController: UIViewController {
    
    let bookshelfUrl = "https://bookshelf.goodideas-studio.com/api"
    var books = [Book]() {
        didSet {
            bookshelfCollectionView.reloadData()
        }
    }
    
    // MARK: - Outlet
    @IBOutlet weak var bookshelfCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookshelfCollectionView.dataSource = self
        bookshelfCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                let deduplicationBooks = Array(Set(books))
                self.books = deduplicationBooks
                let updateTime = json["updatedAt"].doubleValue as TimeInterval
                let dateString = self.getUpdateTime(timeinterval: updateTime)
                self.showGetBooksMessage(title: "SUCCESS", message: "資料更新時間\n\(dateString)", isSuccess: response.result.isSuccess)
                
                DispatchQueue.main.async {
                    self.bookshelfCollectionView.reloadData()
                }
            case .failure(let error):
                self.showGetBooksMessage(title: "Error", message: "錯誤原因：\(error.localizedDescription)", isSuccess: response.result.isSuccess)
            }
        }
    }
    
    func showGetBooksMessage(title: String, message: String, isSuccess: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if !isSuccess {
            let retryAction = UIAlertAction(title: "重試", style: .default) { _ in
                self.getBooks()
            }
            alertController.addAction(retryAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUpdateTime(timeinterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeinterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}

// MARK: - Collection view datasource and delegate
extension BookshelfViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath)

        
        if let label = bookCell.viewWithTag(2) as? UILabel {
            label.text = books[indexPath.row].name
        }
        return bookCell
    }
    
}

// MARK: Collection view delegate flow layout
extension BookshelfViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
