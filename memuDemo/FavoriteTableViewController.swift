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



class FavoriteTableViewController: UITableViewController {
    
    @IBOutlet weak var FavoriteButton: UIBarButtonItem!
    @IBOutlet weak var tblAppleProducts: UITableView!

    
    let realm = try! Realm()
    var favoriteWord: Results<Favorite>?
    var wordSearch: Results<Data>?
    var recentWord: Results<recentSearch>?
    var searchedWord = [String]()
    var rSearch = recentSearch()
    var wSearch = Data()
    
    var fSearch = Favorite()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        revealViewController().rearViewRevealWidth = 200
        FavoriteButton.target = revealViewController()
        FavoriteButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        loadFavorite()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteWord?.count ?? 1
    }
    
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = favoriteWord?[indexPath.row].favoriteWord ?? "No word found"
        cell.delegate = self
        return cell
    }
    
    //animate select cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "favorite", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? DetailsViewController {

            detailVC.fSearch = (favoriteWord![(tblAppleProducts.indexPathForSelectedRow?.row)!])
        }
        DetailsViewController.GlobalVariable.fromFavorite = true
        
    }
    
    func loadFavorite()
    {
        favoriteWord = realm.objects(Favorite.self).sorted(byKeyPath: "dateCreated",ascending: false)
        
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

extension FavoriteTableViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle action by updating model with deletion
            
            if let favoriteForDeletion = self.favoriteWord?[indexPath.row]{
                do {
                    try self.realm.write {
                        self.realm.delete(favoriteForDeletion)
                    }
                }
                catch{
                    print ("Error deleting Recent Word")
                }
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
}
