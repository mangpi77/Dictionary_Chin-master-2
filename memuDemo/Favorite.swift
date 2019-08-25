//
//  Favorite.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 7/7/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object
{
    @objc dynamic var favoriteWord: String = ""
    @objc dynamic var favoriteDefination: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var isFavorite: Bool = false
    let items = List<Data>()
    
    override static func primaryKey() -> String? {
        return "favoriteWord"
    }
    
}

