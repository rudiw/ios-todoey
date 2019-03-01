//
//  Item.swift
//  Todoey
//
//  Created by Rudi Wijaya on 28/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = "";
    
    @objc dynamic var done: Bool = false;
    
    @objc dynamic var dateCreated: Date?;
    
    var category = LinkingObjects(fromType: Category.self, property: "items");
}
