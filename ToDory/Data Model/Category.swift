//
//  Category.swift
//  ToDory
//
//  Created by Michael on 2017/12/21.
//  Copyright © 2017年 Michael. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    var items = List<Item>()
}
