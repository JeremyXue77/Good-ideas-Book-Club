//
//  Bookshelf.swift
//  Good ideas Book Club
//
//  Created by JeremyXue on 2018/10/12.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Book: Hashable {
    var image: String
    var originPrice: String
    var sellPrice: String
    var name: String
    var link: String
    var ISBN: String
    var discount: Int? {
        let origin = (originPrice.replacingOccurrences(of: ",", with: "") as NSString).doubleValue
        let sell = (sellPrice.replacingOccurrences(of: ",", with: "") as NSString).doubleValue
        if origin != 0 && sell != 0 && origin > sell {
            return Int(sell / origin * 100.0)
        }
        return nil
    }

    init(json: JSON) {
        self.image = json["image"].stringValue
        self.originPrice = json["originPrice"].stringValue
        self.sellPrice = json["sellPrice"].stringValue
        self.name = json["name"].stringValue
        self.link = json["link"].stringValue
        self.ISBN = json["ISBN"].stringValue
    }
}



