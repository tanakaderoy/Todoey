//
//  Category.swift
//  Todoey
//
//  Created by Tanaka Mazivanhanga on 7/19/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
   let items = List<Item>()
}

