//
//  BookDetailCollectionViewCell.swift
//  Good ideas Book Club
//
//  Created by JeremyXue on 2018/10/17.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import UIKit

class BookDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookISBNLabel: UILabel!
    @IBOutlet weak var originPriceLabel: UILabel!
    @IBOutlet weak var sellPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    func update(book: Book) {
        if let imageUrl = URL(string: book.image) {
            bookImageView.kf.setImage(with: imageUrl)
        }
        if let discount = book.discount {
            discountLabel.isHidden = false
            originPriceLabel.isHidden = false
            discountLabel.text = "(\(discount)%)"
            originPriceLabel.text = "原價: $\(book.originPrice)"
        } else {
            discountLabel.isHidden = true
            originPriceLabel.isHidden = true
        }
        bookNameLabel.text = book.name
        bookISBNLabel.text = "ISBN:\(book.ISBN)"
        sellPriceLabel.text = "售價: $\(book.sellPrice)"
    }
    
}
