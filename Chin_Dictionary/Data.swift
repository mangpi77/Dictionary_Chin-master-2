//
//  Data.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 6/1/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//
import Foundation
import RealmSwift

class Data: Object{
    
    @objc dynamic var searchWord: String = ""
    @objc dynamic var wordDefination: String = ""
    
    override static func primaryKey() -> String? {
        return "searchWord"
    }
    //@objc dynamic var recentSearch: String = ""
   // @objc dynamic var favoriteWord: String = ""
    
  // let items = List<Data>.self()
  // var parentWord = LinkingObjects(fromType: recentSearch.self, property: "items")
}
