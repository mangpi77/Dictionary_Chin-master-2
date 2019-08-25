//
//  RecentTableViewController.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 6/5/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

//checker = 1



class DailyWordTableViewController: UITableViewController {
    
   
    
    @IBOutlet weak var dailyWordButton: UIBarButtonItem!
    @IBOutlet weak var tblAppleProducts: UITableView!
    
    
    let realm = try! Realm()
    var favoriteWord: Results<Favorite>?
    var wordSearch: Results<Data>?
    var recentWord: Results<recentSearch>?
    var searchedWord = [String]()
    var rSearch = recentSearch()
    var wSearch = Data()
    
    var fSearch = Favorite()
    
    var dailyWord: Results<wordOfTheDay>?
    var wordOfDay = wordOfTheDay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        revealViewController().rearViewRevealWidth = 200
        dailyWordButton.target = revealViewController()
        dailyWordButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        loadDailyWord()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWord?.count ?? 1
    }
    
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite", for: indexPath) as! SwipeTableViewCell
        
        //print (dailyWord?[indexPath.row].dateCreated! as Any)
        //let dateString = dailyWord?[indexPath.row].dateCreated!.toString(dateFormat: "MMM/dd/yyyy")
        //print( dateString!)
        
      // var  converteDdate = (dailyWord?[indexPath.row].dateCreated)
        
       // var final  = converteDdate!.toString(dateFormat: "yyyy/MMM/dd HH:mm:ss")
        
        cell.textLabel?.text = dailyWord?[indexPath.row].word ?? "No word found"
        //print (final)
        return cell
    }
    
    //animate select cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "favorite", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? DetailsViewController {
            
            detailVC.wordOfDay = (dailyWord![(tblAppleProducts.indexPathForSelectedRow?.row)!])
        }
        DetailsViewController.GlobalVariable.wordOfDay = true
        
    }
    
    func loadDailyWord()
    {
        dailyWord = realm.objects(wordOfTheDay.self).sorted(byKeyPath: "dateCreated",ascending: false)
        
        //               var sample = ["Tiger"]
        //               var searchedWord = [String]()
        //
        //                searchedWord.append(sample[0])
        //
        //                fSearch.favoriteWord = searchedWord[0]
        //                fSearch.dateCreated = Date()
        //
        //                try! realm.write {
        //                    realm.add(fSearch)
        //                }
        
        tableView.reloadData()
    }
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
//extension RecentViewController: UISearchBarDelegate
//{
//
//        //        recentWord = recentWord?.filter("recentSearch CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "recentSearch", ascending: true)
//
//        recentWord = recentWord?.filter("searchWord CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "searchWord", ascending: true)
//
//       // rSearch.recentSearch = searchBar.text!
//
//       // print (rSearch)
//
//
//      //  try! realm.write {
//      //      realm.add(rSearch)
////}
//
//

// tableView.reloadData()

//extension FavoriteTableViewController: SwipeTableViewCellDelegate{
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
//            // handle action by updating model with deletion
//
//            if let favoriteForDeletion = self.favoriteWord?[indexPath.row]{
//                do {
//                    try self.realm.write {
//                        self.realm.delete(favoriteForDeletion)
//                    }
//                }
//                catch{
//                    print ("Error deleting Recent Word")
//                }
//            }
//
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//    }
//
////    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }

