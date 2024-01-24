//
//  Category.swift
//  Todoey
//
//  Created by Fırat AKBULUT on 2.10.2023.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
