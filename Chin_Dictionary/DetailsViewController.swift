//
//  DetailsViewController.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 6/23/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation
import SwiftyJSON
import Alamofire



class DetailsViewController: UIViewController {
    
    struct GlobalVariable{
        static var fromRecent: Bool = false
        static var fromFavorite: Bool = false
        static var fromSearch: Bool = false
        static var searched: Bool = false
        static var fromWordOfDay: Bool = false
        static var wordOfDay: Bool = false
        static var songCategory: String = ""
        static var songPath: String = ""
        static var deleteFavorite = Favorite()
        static var isFavorite: Bool = false
        public var normalColor:     UIColor
        public var selectedColor:   UIColor
        
    }
    
    
    let realm = try! Realm()
    
    var favoriteWord: Results<Favorite>?
    var wordSearch: Results<Data>?
    var recentWord: Results<recentSearch>?
    
    var dailyWord: Results<wordOfTheDay>?
    var wordOfDay = wordOfTheDay()
    
    
    
    var fSearch = Favorite()
    var searched = Data()
    var recent = recentSearch()
    
    //@IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var wordDescription: UILabel!
    @IBOutlet weak var syns: UILabel!
    @IBOutlet weak var ants: UILabel!
    @IBOutlet weak var hwi: UILabel!
    @IBOutlet weak var hwiPrs: UILabel!
    @IBOutlet weak var DefinationBox: UIView!
    @IBOutlet weak var SynBox: UIView!
    @IBOutlet weak var AntBox: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    
    @IBOutlet weak var wordDescriptionHC: NSLayoutConstraint!
    
    var isFavorite: Bool = false
    var isRecent: Bool = false
    var favoriteCounter: Int = 0
    
    var player:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (GlobalVariable.fromSearch == true ){
            
            GlobalVariable.fromFavorite = false
            GlobalVariable.fromRecent = false
            
            let definationSplit = "\(String(describing: (searched.wordDefination)))"
            let completedSplit: [String] = definationSplit.components(separatedBy: ".")
            
            word.text = "\((searched.searchWord))"
            
            var labelText = ""
            for (index,element) in completedSplit.enumerated() {
                
                labelText += "\(element)\n"
                
                print (index,"\u{2022}",element)
                wordDescription.text = "\(labelText)"
            }
            GlobalVariable.fromSearch = false
        }
        else if ( GlobalVariable.fromFavorite == true )
        {
            
            isFavorite.toggle()
            switch isFavorite {
            case true :
                favoriteButton.tintColor = UIColor.white
            case false:
                favoriteButton.tintColor = UIColor.darkGray
            }
            
            
            GlobalVariable.fromRecent = false
            GlobalVariable.fromSearch = false
            
            let definationSplit = "\(String(describing: (fSearch.favoriteDefination)))"
            let completedSplit: [String] = definationSplit.components(separatedBy: ",")
            
            
            word.text = "\((fSearch.favoriteWord))"
            
            var labelText = ""
            for (index,element) in completedSplit.enumerated() {
                
                labelText += "\(element)\n"
                
                print (index,"\u{2022}",element)
                wordDescription.text = "\(labelText)"
            }
            GlobalVariable.fromFavorite = false
        }
        else if (GlobalVariable.fromRecent == true)
            
        {
            GlobalVariable.fromSearch = false
            GlobalVariable.fromFavorite = false
            
            let definationSplit = "\(String(describing: (recent.recentDefination)))"
            let completedSplit: [String] = definationSplit.components(separatedBy: ",")
            
            word.text = "\((recent.recentSearch))"
            
            var labelText = ""
            for (index,element) in completedSplit.enumerated() {
                
                labelText += "\(element)\n"
                
                print (index,"\u{2022}",element)
                wordDescription.text = "\(labelText)"
            }
            GlobalVariable.fromRecent = false
        }
            
        else if (GlobalVariable.fromWordOfDay == true)
            
        {
            GlobalVariable.fromSearch = false
            GlobalVariable.fromFavorite = false
            
            let wordCount = realm.objects(wordOfTheDay.self)
            let maxNumber:Int = wordCount.count
            
            let definationSplit = "\(String(describing: (wordCount[maxNumber - 1].Defination!)))"
            let completedSplit: [String] = definationSplit.components(separatedBy: ",")
            
            
            word.text = "\((wordCount[maxNumber - 1].word!))"
            
            var labelText = ""
            for (index,element) in completedSplit.enumerated() {
                
                labelText += "\(element)\n"
                
                print (index,"\u{2022}",element)
                wordDescription.text = "\(labelText)"
            }
            print ("Recent Test: " ,GlobalVariable.fromSearch)
            GlobalVariable.fromRecent = false
            
        }
            
        else if (GlobalVariable.wordOfDay == true)
        {
            GlobalVariable.fromSearch = false
            GlobalVariable.fromFavorite = false
            
            let definationSplit = "\(String(describing: (wordOfDay.Defination!)))"
            let completedSplit: [String] = definationSplit.components(separatedBy: " ")
            
            
            word.text = "\(String(describing: (wordOfDay.word!)))"
            
            
            var labelText = ""
            for (index,element) in completedSplit.enumerated() {
                
                labelText += "\(element)\n"
                
                print (index,"\u{2022}",element)
                wordDescription.text = "\(labelText)"
            }
            
            print ("Recent Test: " ,GlobalVariable.fromSearch)
            GlobalVariable.fromRecent = false
            
            print ("Then -->\(completedSplit)")
        }
        
        print ("Searched Word: ", word.text!)
        print ("Defination: ",wordDescription.text!)
        
        if (findRecent(wordSearch: word.text!) != nil && GlobalVariable.fromRecent == false)
        {
            print ("Already exists in recent")
            isRecent = true
            print (GlobalVariable.fromRecent)
            
        }
        else
        {
            print ("Running Recent")
            loadRecent()
        }
        
        //
        dataAPI()
        
        API2()
        
    }
    
    // -------- API Data -----------
    
    func dataAPI(){
        let inputText = word.text!
        
        print (inputText)
        
        let urlData = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/\(inputText)?key=b5cb97b1-54aa-4f93-a336-31668e089d7d"
        
        
        guard let url3 = URL(string: urlData) else {return}
        
        let task = URLSession.shared.dataTask(with: url3) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                _ = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                let json = try? JSON (data:dataResponse)
                
                
                let synonymLength = json![0]["meta"]["syns"]
                let anonymLength = json![0]["meta"]["ants"]
                
                let anonymCounter = anonymLength.count
                let synonymCounter = synonymLength.count
                
                var synResults: [String] = []
                var antResults: [String] = []
                var synText = "Synonym: \n"
                var antText = "Anonym: \n"
                var sCrement = 1
                var aCrement = 1
                var innerSynTracker = 0
                var innerAntsTracker = 0
                
                
                DispatchQueue.main.async {
                    if (synonymCounter == 0){
                        self.syns.isHidden = true
                        self.SynBox.isHidden = true
                        
                    }
                    
                    
                    for k in 0..<synonymCounter
                    {
                        let innerSyn = json![0]["meta"]["syns"][k]
                        
                        for i in 0..<innerSyn.count{
                            
                            synResults = [json![0]["meta"]["syns"][k][i].stringValue]
                            
                            for s in synResults {
                                
                                if(innerSynTracker >= sCrement) && (innerSynTracker >= synResults.count)  {
                                    synText += ", "
                                    sCrement = 0
                                }
                                synText += "\(s)"
                            }
                            innerSynTracker = innerSynTracker + 1
                        }
                    }
                    sCrement = sCrement + 1
                    self.syns.text = synText
                }
                
                // Get anynom
                DispatchQueue.main.async {
                    
                    if (anonymCounter == 0){
                        self.ants.isHidden = true
                        self.AntBox.isHidden = true
                    }
                    for m in 0..<anonymCounter
                    {
                        let innerAnt = json![0]["meta"]["ants"][m]
                        
                        for n in 0..<innerAnt.count
                        {
                            antResults = [json![0]["meta"]["ants"][m][n].stringValue]
                            for a in antResults {
                                
                                if(innerAntsTracker >= aCrement) && (innerAntsTracker >= antResults.count)  {
                                    antText += ", "
                                    aCrement = 0
                                }
                                antText += "\(a)"
                            }
                            innerAntsTracker = innerAntsTracker + 1
                        }
                    }
                    aCrement = aCrement + 1
                    self.ants.text = antText
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    
    func API2() {
        
        let inputText = word.text!
        
        let prsData = "https://dictionaryapi.com/api/v3/references/collegiate/json/\(inputText)?key=3ef3c315-9a08-4844-affb-28a10bb35da8"
        
        
        guard let url2 = URL(string: prsData) else {return}
        
        let task = URLSession.shared.dataTask(with: url2) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                _ = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                let json = try? JSON (data:dataResponse)
                
                var textForm = ""
                var textPrs = ""
                
                let filePath = "https://media.merriam-webster.com/soundc11"
                
                var fileName = ""
                var soundURL = ""
                var subDirectory = String(inputText.prefix(1)).lowercased()
                
                
                
                DispatchQueue.main.async {
                    textForm = json![0]["fl"].stringValue
                    textPrs = json![0]["hwi"]["prs"][0]["mw"].stringValue
                    fileName = json![0]["hwi"]["prs"][0]["sound"]["audio"].stringValue
                    self.hwi.text = textForm + " | " + textPrs
                    
                    let checkSubdirectory = String(fileName.prefix(2)).lowercased()
                    
                    let check1 = "gg"
                    let check2 = "bix"
                    
                    if (checkSubdirectory == check1){
                        subDirectory = check1
                    }
                    else if (checkSubdirectory == check2){
                        subDirectory = check2
                    }
                    
                    soundURL = filePath + "/" + subDirectory + "/" + fileName + ".wav"
                    let soundFinal = soundURL.trimmingCharacters(in: .whitespaces)
                    if (soundURL != ""){
                    GlobalVariable.songPath = soundFinal
                    }
                    else{
                    GlobalVariable.songPath = ""
                    }
                    print (soundURL)
                }
                // Get anynom
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func results ()
    {
        
    }
    
    
    @IBAction func shareButton(_ sender: Any)
    {
        let activityVC = UIActivityViewController(activityItems: ["\(word.text!)\n","\(wordDescription.text!)","Chin Dictionary"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func soundButton(_ sender: Any) {
        
        let passSound = word.text!
        let trimmedString = passSound.trimmingCharacters(in: .whitespaces)
        playSound(sound: trimmedString)
        
    }
    var checked = false
    var tracker = 0
    @IBAction func favoriteButton(_ sender: Any) {
        isFavorite.toggle()
        let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(image, for: .normal)
        if (isFavorite == true){
            favoriteButton.tintColor = UIColor.white

        }
        else {
            favoriteButton.tintColor = UIColor.darkGray

        }
        
        tracker = tracker + 1
        print (tracker)
        if (isFavorite == true && tracker <= 1){
            GlobalVariable.isFavorite = true
            GlobalVariable.deleteFavorite = fSearch
            
            
            //            print (GlobalVariable.isFavorite)
            //            print (GlobalVariable.deleteFavorite)
            addFavorite(fav: fSearch)
            
        }
            
        else {
            GlobalVariable.isFavorite = false
            //            tracker = tracker + 1
            //            print (GlobalVariable.isFavorite)
            //removeFavorite(fav: fSearch)
        }
        
        print ("Favorite Status",isFavorite)
        print ("isFavorite", GlobalVariable.isFavorite)
 
    }
    
    
    func  playSound(sound:String)
    {
        _ = sound.trimmingCharacters(in: .whitespacesAndNewlines)
        let url = URL(string: GlobalVariable.songPath)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        player!.play()
    }
    
    func findRecent(wordSearch:String)->recentSearch? {
        guard let realm = try? Realm() else {
            return nil
        }
        let fav = realm.object(ofType: recentSearch.self, forPrimaryKey: wordSearch)
        return fav
    }
    
    func findFavorite(wordSearch:String)->Favorite? {
        guard let realm = try? Realm() else {
            return nil
        }
        let fav = realm.object(ofType: Favorite.self, forPrimaryKey: wordSearch)
        return fav
    }
    
    func recentAdd(fav:recentSearch) {
        guard let realm = try? Realm() else {
            return
        }
        recentWord = realm.objects(recentSearch.self).sorted(byKeyPath: "dateCreated",ascending: false)
        rSearch.recentSearch = searched.searchWord
        rSearch.recentSearch = searched.wordDefination
        rSearch.dateCreated = Date()
        try? realm.write {
            realm.add(fav)
        }
    }
    
    //add Favorite
    func addFavorite(fav:Favorite) {
        guard let realm = try? Realm() else {
            return
        }
        favoriteWord = realm.objects(Favorite.self).sorted(byKeyPath: "dateCreated",ascending: false)
        fSearch.favoriteWord = searched.searchWord
        fSearch.favoriteDefination = searched.wordDefination
        fSearch.dateCreated = Date()
        fSearch.isFavorite = true
        try? realm.write {
            realm.add(fav, update: true)
        }
    }
    //update isFavorite
    func updateFavorite(fav:Favorite) {
        guard let realm = try? Realm() else {
            return
        }
        favoriteWord = realm.objects(Favorite.self).sorted(byKeyPath: "dateCreated",ascending: false)
        fSearch.favoriteWord = searched.searchWord
        fSearch.favoriteDefination = searched.wordDefination
        fSearch.dateCreated = Date()
        fSearch.isFavorite = false
        try? realm.write {
            realm.add(fav, update: true)
        }
    }
    
    //find favorite
    func findFavorite(favoriteWord:String)->Favorite? {
        guard let realm = try? Realm() else {
            return nil
        }
        let fav = realm.object(ofType: Favorite.self, forPrimaryKey: favoriteWord)
        return fav
    }
    
    //remove favorite
    func removeFavorite(fav:Favorite) {
        guard let realm = try? Realm() else {
            return
        }
        try? realm.write {
            realm.delete(fav)
        }
    }
    //load recent
    func loadRecent()
    {
        do{
            
            try self.realm.write {
                
                let newRealm = recentSearch()
                newRealm.recentSearch = searched.searchWord
                newRealm.dateCreated = Date()
                newRealm.recentDefination = searched.wordDefination
                realm.add(newRealm)
            }
            
        } catch
        {
            print ("error")
        }
    }
    
}



//    func faveButton(_ favesButton: FaveButton, didSelected selected: Bool) {
//        favesButton.selectedColor = UIColor.black
//        favesButton.normalColor = UIColor.white

// faveButton.isSelected = true


//
//        if (selected == true && favoriteCounter < 2)
//        {
//
//            if (findFavorite(wordSearch: word.text!) != nil )
//            {
//
//            }
//            else
//            {
//                addFavorite(fav: fSearch)
//                isFavorite = true
//            }
//            print ("Saved to favorite : - >" , fSearch)
//            print ("Favorite Status: " , isFavorite)
//            print ("Favorite Counter:", favoriteCounter)
//
//        }
//        else
//        {
//            GlobalVariable.removeFavorite = selected
//            GlobalVariable.deleteFavorite = fSearch
//            print ("Selected",selected)
//
//
//
//        }







