//
//  SearchViewController.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 5/27/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

var fSearch = Favorite()

var recentWord: Results<recentSearch>?
var wordSearch: Results<Data>?



//var dailyWord: Results<wordOfTheDay>?

var searchedWord = [String]()
var rSearch = recentSearch()
var wSearch = Data()
//var wordOfDay = wordOfTheDay()


class SearchViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tblAppleProducts: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        revealViewController().rearViewRevealWidth = 200
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //        if (wordOfDay.word != nil){
        //wordOfTheDay(word: wordOfDay)
        //        }
        
        loadDictionary()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordSearch?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchBar", for: indexPath)
        cell.textLabel?.text = wordSearch?[indexPath.row].searchWord ?? "Search for word"
        return cell
    }
    
    //animate select cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destination = segue.destination as? DetailsViewController {
            
            destination.searched = (wordSearch![(tblAppleProducts.indexPathForSelectedRow?.row)!])
            
            DetailsViewController.GlobalVariable.fromSearch = true;
        }
    }
    
    
    func wordOfTheDay(word:wordOfTheDay) {
        
        let wordCount = realm.objects(Data.self)
        let maxNumber:Int = wordCount.count
        var randomNumber = Int.random(in: 0..<maxNumber)
        
        var previousNumber:Int = 0
        
        while previousNumber == randomNumber {
            randomNumber = Int.random(in: 0..<maxNumber)
        }
        previousNumber = randomNumber
        
        
        guard let realm = try? Realm() else {
            return
        }
        
        wordOfDay.word = wordCount[randomNumber].searchWord
        wordOfDay.Defination = wordCount[randomNumber].wordDefination
        
        // print ("Daily Word: ", dailyWord)
        //print ("Daily Word Defination: ", dailyDefination)
        print ("Random Number ---> ", randomNumber)
        
        try? realm.write {
            realm.add(word)
        }
    }
    
    // destination.searched = wordSearch![(tblAppleProducts!.indexPathForSelectedRow?.row)!]
    //print ("hello,it's me")
    //test = (test[(tblAppleProducts.indexPathForSelectedRow?.row)!])
    //String(Array(stringToIndex)[index])
    //tblAppleProducts.deselectRow(at: tblAppleProducts.indexPathForSelectedRow!, animated: true)
    
    //Display recent search
    func loadRecent()
    {
        recentWord = recentWord?.self.sorted(byKeyPath: "recentSearch", ascending: false)
        tableView.reloadData()
    }
    
    //Display Dictionary
    func loadDictionary()
    {
        wordSearch = realm.objects(Data.self)
        wordSearch = wordSearch?.self.sorted(byKeyPath: "searchWord", ascending: true)
        
        tableView.reloadData()
    }
    
}

//MARK: - SearchBar methods
extension SearchViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        wordSearch = wordSearch?.filter("searchWord CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "searchWord", ascending: true)
        
        DetailsViewController.GlobalVariable.searched = true
        
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            
            loadDictionary()
            
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
    
    
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        var searchedWord = recentWord?.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
    //       // searching = true
    //        tableView.reloadData()
    //    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func removeFavorite(fav:Favorite) {
        
        if ( DetailsViewController.GlobalVariable.isFavorite == false){
            guard let realm = try? Realm() else {
                return
            }
            try? realm.write {
                realm.delete(fSearch)
            }
        }
    }
    
}




