//
//  BookCollectionViewCell.swift
//  Good ideas Book Club
//
//  Created by JeremyXue on 2018/10/17.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import UIKit
import Kingfisher

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var originPriceLabel: UILabel!
    @IBOutlet weak var sellPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var showMoreLabel: UILabel!
    
    func update(book: Book) {
        if let discount = book.discount {
            originPriceLabel.text = "原價: $\(book.originPrice)"
            discountLabel.text = "(\(discount)%)"
            originPriceLabel.isHidden = false
            discountLabel.isHidden = false
        } else {
            originPriceLabel.isHidden = true
            discountLabel.isHidden = true
        }
        if let imageUrl = URL(string: book.image) {
            bookImageView.kf.setImage(with: imageUrl)
        }
        sellPriceLabel.text = "售價: $\(book.sellPrice)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.bounds.width / 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0.4723072052, green: 0.740311563, blue: 0.5356696248, alpha: 1)
        showMoreLabel.layer.cornerRadius = showMoreLabel.bounds.height / 4
        showMoreLabel.clipsToBounds = true
        showMoreLabel.layer.borderWidth = 1
        showMoreLabel.layer.borderColor = #colorLiteral(red: 0.4723072052, green: 0.740311563, blue: 0.5356696248, alpha: 1)
    }
}
