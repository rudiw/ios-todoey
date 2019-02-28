//
//  Data.swift
//  Todoey
//
//  Created by Rudi Wijaya on 28/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import Foundation
import RealmSwift


class Data: Object {
    @objc dynamic var name: String = "";
    @objc dynamic var age: Int = 0;
}
