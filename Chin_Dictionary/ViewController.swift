//
//  ViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//


import UIKit
import UserNotifications
import RealmSwift
import Alamofire
var wordOfDay = wordOfTheDay()

class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    @IBOutlet weak var todayWord: UILabel!
    @IBOutlet weak var todayWordDefination: UILabel!
    
    private let notificationPublisher = NotificationPublisher()
    
    var data123 : [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(Realm.Configuration.defaultConfiguration.fileURL!)

        let url = "https://www.dictionaryapi.com/account/example?key=3ef3c315-9a08-4844-affb-28a10bb35da8"
        
        Alamofire.request(url).responseJSON { (response) in
            
            if let responseValue = response.result.value as! [String: Any]? {
                if let responseDate = responseValue["meta"] as! [[String: Any]]? {
                    print (responseDate)
                }
            }
        }
        
        let wordCount1 = realm.objects(wordOfTheDay.self)


        print ("word count",wordCount1.count)
        if (wordCount1.count > 0){
            loadWordOfTheDay()
        }
        else {
            print ("no to day word")
        }
                
                notificationPublisher.scheduleNotification(title: "Tu ni hrang cafang", subtitle:  todayWord.text!, body: todayWordDefination.text!, badge: 1, delayInterval: nil)


        if revealViewController() != nil {
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
    
    @IBAction func todayWordButton(_ sender: Any) {
        
        performSegue(withIdentifier: "wordOfTheDay", sender: self)
        print ("Performing Segue")
        DetailsViewController.GlobalVariable.fromWordOfDay = true
    }
    
    func createWordOfTheDay(word:wordOfTheDay) {
        
        let wordCount = realm.objects(Data.self)
        let maxNumber:Int = wordCount.count
        var randomNumber = Int.random(in: 0..<maxNumber)
        
        var previousNumber:Int = 0
        
        while previousNumber == randomNumber {
            randomNumber = Int.random(in: 0..<maxNumber)
        }
        previousNumber = randomNumber
        wordOfDay.dateCreated = Date()
        
        
        guard let realm = try? Realm() else {
            return
        }
        
        wordOfDay.word = "\(wordCount[randomNumber].searchWord)"
        wordOfDay.Defination = "\(wordCount[randomNumber].wordDefination)"
    
        print ("Random Number ---> ", maxNumber)
  
        try? realm.write {
            realm.add(word)
        }
    }
    

    func loadWordOfTheDay()
    {
        let wordCount = realm.objects(wordOfTheDay.self)
        let maxNumber:Int = wordCount.count
        
        let definationSplit = "\(String(describing: (wordCount[maxNumber - 1].Defination!)))"
        let completedSplit: [String] = definationSplit.components(separatedBy: ",")
        
        todayWord.text = "\((wordCount[maxNumber - 1].word!))"
        dateLabel.text = "\((wordCount[maxNumber - 1].dateCreated!))"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        if let date = dateFormatter.date(from: dateLabel.text!) {
            print(dateFormatter.string(from: date))
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        
        var labelText = ""
        for (index,element) in completedSplit.enumerated() {
            
            labelText += "\(index + 1).\(element)\n"
            
            print (index,"\u{2022}",element)
            todayWordDefination.text = "\(labelText)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func run24HoursTimer() {
//        
//        let currentDate = Date()
//        let waitingDateTimeInterval:Int64 = UserDefaults.standard.value(forKey: "waiting_date") as? Int64 ?? 0
//        let currentDateTimeInterval = currentDate.currentTimeMillis()
//        let dateDiffrence = currentDateTimeInterval - waitingDateTimeInterval
//        if dateDiffrence > 24*60*60*1000 {
//            // Call the function that you want to be repeated every 24 hours here:
//            createWordOfTheDay(word: wordOfDay)
//            
//            UserDefaults.standard.setValue(currentDateTimeInterval, forKey: "waiting_date")
//            UserDefaults.standard.synchronize()
//        }
//    }
    
    }


extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
