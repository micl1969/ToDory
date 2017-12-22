//
//  Data.swift
//  ToDory
//
//  Created by Michael on 2017/12/21.
//  Copyright © 2017年 Michael. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var hexColor:String?
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateOfCreate:Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
