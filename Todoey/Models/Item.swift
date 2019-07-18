//
//  ItemModel.swift
//  Todoey
//
//  Created by Tanaka Mazivanhanga on 7/18/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation
//enum Status{
//    case done
//    case notDone
//}
class Item: Codable {
    var title: String
    var done: Bool = false
    init(title: String) {
        
        self.title = title
    }
    init(title: String, done: Bool) {
        self.done = done
        self.title = title
    }
}
