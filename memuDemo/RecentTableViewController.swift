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


class RecentTableViewController: UITableViewController {

    //ViewController.GlobalVariable.checker

   // fromRecent = true
    @IBOutlet weak var tblAppleProducts: UITableView!
    @IBOutlet weak var RecentButton: UIBarButtonItem!
    
    
    
    let realm = try! Realm()
    var recentWord: Results<recentSearch>?
    var rSearch = recentSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        revealViewController().rearViewRevealWidth = 200
        RecentButton.target = revealViewController()
        RecentButton.action = #selector(SWRevealViewController.revealToggle(_:))

        loadRecent()
       // recentLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    
    }
    
   
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "goToItems", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! TodoListViewController
//
//        if let indexPath = tableView.indexPathForSelectedRow {
//            destinationVC.selectedCategory = categories?[indexPath.row]
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentWord?.count ?? 1
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recent", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = recentWord?[indexPath.row].recentSearch ?? "No word found"
        cell.delegate = self
        return cell
    }
    
    //animate select cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? DetailsViewController {
            
            detailVC.recent = (recentWord![(tblAppleProducts.indexPathForSelectedRow?.row)!])

        }
        DetailsViewController.GlobalVariable.fromRecent = true
        
        
        
    }
    
    func loadRecent()
    {
        recentWord = realm.objects(recentSearch.self).sorted(byKeyPath: "dateCreated",ascending: false)
 
        
//        var sample = ["Cat","Simply Amazing"]
//        //var def = ["Scary animal"]
//        
//        //var searchedWord:[String] = Array()
//        //  var searchedWord = [String]()
//        
//        // searchedWord.append(sample[0])
//        
//        wSearch.searchWord = sample[0]
//        wSearch.wordDefination = sample[1]
//        
//        try! realm.write {
//            
//            
//            realm.add(wSearch)
//        }
        
        tableView.reloadData()
    }
    
    func recentLoad() {
        
        recentWord  = realm.objects(recentSearch.self)
        
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

extension RecentTableViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle action by updating model with deletion
            
            if let recentWordForDeletion = self.recentWord?[indexPath.row]{
                do {
                    try self.realm.write {
                        self.realm.delete(recentWordForDeletion)
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
