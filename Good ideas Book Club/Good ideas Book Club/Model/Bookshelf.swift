//
//  Bookshelf.swift
//  Good ideas Book Club
//
//  Created by JeremyXue on 2018/10/12.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Book {
    var image: String
    var originPrice: Int
    var sellPrice: Int
    var name: String
    var link: String
    var ISBN: Int
    
    init(json: JSON) {
        self.image = json["image"].stringValue
        self.originPrice = json["originPrice"].intValue
        self.sellPrice = json["sellPrice"].intValue
        self.name = json["name"].stringValue
        self.link = json["link"].stringValue
        self.ISBN = json["ISBN"].intValue
    }
}



//var discount: Int {
//    if originPrice != 0 && sellPrice != 0 {
//        let result = Int((Double(sellPrice) / Double(originPrice)) * 100.0)
//        return result
//    } else {
//        return 0
//    }
//}
