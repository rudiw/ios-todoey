//
//  Category.swift
//  Todoey
//
//  Created by Rudi Wijaya on 28/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = "";
    let items: List<Item> = List<Item>();
}
