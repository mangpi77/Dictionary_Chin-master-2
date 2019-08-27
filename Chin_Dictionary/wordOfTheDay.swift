//
//  recentSearch.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 6/3/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
import RealmSwift

class wordOfTheDay: Object
{
    @objc dynamic var word: String?
    @objc dynamic var Defination: String?
    @objc dynamic var dateCreated: Date?
    let items = List<Data>()
    
//    override static func primaryKey() -> String? {
//        return "word"
//    }
    
}
