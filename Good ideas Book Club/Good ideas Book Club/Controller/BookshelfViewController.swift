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

enum BookCellStyle: String {
    case simple = "BookCell"
    case detail = "BookDetailCell"
}

class BookshelfViewController: UIViewController {
    
    let bookshelfUrl = "https://bookshelf.goodideas-studio.com/api"
    var selectedBook: Book?
    var refreshControl: UIRefreshControl!
    var searchController: UISearchController!
    var cellStyle = BookCellStyle.simple
    var searchBooks = [Book]() {
        didSet {
            bookshelfCollectionView.reloadData()
        }
    }
    var books = [Book]() {
        didSet {
            bookshelfCollectionView.reloadData()
        }
    }
    
    // MARK: - Outlet
    @IBOutlet weak var scrollToTopButton: UIButton!
    @IBOutlet weak var bookshelfCollectionView: UICollectionView!
    
    // MARK: - Action
    @IBAction func changeCellStyle(_ sender: UIBarButtonItem) {
        if sender.image == UIImage(named: "detail") {
            cellStyle = .detail
            sender.image = UIImage(named: "simple")
        } else {
            cellStyle = .simple
            sender.image = UIImage(named: "detail")
        }
        bookshelfCollectionView.reloadData()
    }
    
    @IBAction func scrollToTop(_ sender: UIButton) {
        bookshelfCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = .white
        bookshelfCollectionView.dataSource = self
        bookshelfCollectionView.delegate = self
        configureSearchController()
        configureRefreshControl()
        floatingButtonShadow(scrollToTopButton)
        getBooks()
        hideFloatingButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AnimationLoadingView.remove()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case BookshelfSeugeIdenifier.linkToWebView:
            if let bookWebVC = segue.destination as? BookWebViewController {
                bookWebVC.urlString = selectedBook?.link
            }
        default:
            break
        }
    }
    
    @objc func getBooks(){
        guard let url = URL(string: bookshelfUrl) else { return }
        AnimationLoadingView.startLoading(message: "載入書籍資料...")
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
                print("更新時間：\(dateString)")
                AnimationLoadingView.endLoading(message: "更新時間：\(dateString)")
                self.refreshControl.endRefreshing()
            case .failure(let error):
                AnimationLoadingView.endLoading(message: "更新失敗")
                print("錯誤訊息：\(error.localizedDescription)")
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func getUpdateTime(timeinterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeinterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "搜尋書名..."
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.returnKeyType = .done
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
    }
    
    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.alpha = 0
        refreshControl.addTarget(self, action: #selector(getBooks), for: .valueChanged)
        bookshelfCollectionView.addSubview(refreshControl)
    }
    
    func floatingButtonShadow(_ button: UIButton) {
        button.layer.shadowOffset = CGSize(width: button.bounds.width / 10, height: button.bounds.width / 10)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
    }
    
    func showFloatingButton() {
        UIView.animate(withDuration: 0.4) {
            self.scrollToTopButton.transform = .identity
            self.scrollToTopButton.alpha = 1
        }
    }
    
    func hideFloatingButton() {
        UIView.animate(withDuration: 0.4) {
            self.scrollToTopButton.transform = CGAffineTransform(translationX: 0 , y: 50)
            self.scrollToTopButton.alpha = 0
        }
    }
}

// MARK: - Collection view datasource and delegate
extension BookshelfViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchBooks.count
        } else {
            return books.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellStyle.rawValue, for: indexPath)
        var book: Book!
        
        if searchController.isActive {
            book = searchBooks[indexPath.row]
        } else {
            book = books[indexPath.row]
        }
        
        guard let bookCellStyle = BookCellStyle(rawValue: cellStyle.rawValue) else { return UICollectionViewCell() }
        switch bookCellStyle {
        case .simple:
            guard let bookCell = cell as? BookCollectionViewCell else { return UICollectionViewCell() }
            bookCell.update(book: book)
            return bookCell
        default:
            guard let bookDetailCell = cell as? BookDetailCollectionViewCell else { return UICollectionViewCell() }
            bookDetailCell.update(book: book)
            return bookDetailCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if searchController.isActive {
            selectedBook = searchBooks[indexPath.row]
        } else {
            selectedBook = books[indexPath.row]
        }
        performSegue(withIdentifier: BookshelfSeugeIdenifier.linkToWebView, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !searchController.isActive {
            cell.alpha = 0.5
            cell.transform = CGAffineTransform(translationX: cell.bounds.width, y: cell.bounds.height / 3).concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
            UIView.animate(withDuration: 0.4) {
                cell.alpha = 1
                cell.transform = CGAffineTransform.identity
            }
        }
    }
    
}

// MARK: Collection view delegate flow layout
extension BookshelfViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellStyle == .simple {
            let width = (collectionView.bounds.width - 30) / 2
            let height = width / 2 * 3
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.bounds.width
            let height = width / 3
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - UIScrollViewDelegate
extension BookshelfViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.bounds.height {
            showFloatingButton()
        } else {
            hideFloatingButton()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension BookshelfViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            searchBooks = books.filter({ (book) -> Bool in
                return book.name.lowercased().contains(text.lowercased())
            })
        }
    }
}
