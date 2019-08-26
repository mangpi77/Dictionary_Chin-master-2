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

var dailyWord: Results<wordOfTheDay>?
var wordOfDay = wordOfTheDay()

class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    @IBOutlet weak var todayWord: UILabel!
    @IBOutlet weak var todayWordDefination: UILabel!
    
    
    
    
    
    private let notificationPublisher = NotificationPublisher()
    
    var data123 : [[String: Any]] = [[String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            openRealm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            return true
        }
        let url = "https://www.dictionaryapi.com/account/example?key=3ef3c315-9a08-4844-affb-28a10bb35da8"
        
        Alamofire.request(url).responseJSON { (response) in
            
            if let responseValue = response.result.value as! [String: Any]? {
                if let responseDate = responseValue["meta"] as! [[String: Any]]? {
                    print (responseDate)
                }
            }
        }
        
        
        
        
        
        
        //
       loadWordOfTheDay()
        //
        ////       let searchButton = UIButton (frame:  CGRect(x: 20, y:260, width: 330, height: 40))
        ////        searchButton.backgroundColor = UIColor.red
        ////        self.view.addSubview(searchButton)
        //
        //
       // createWordOfTheDay(word: wordOfDay)
        
        
        
        //        notificationPublisher.scheduleNotification(title: "Tu ni hrang cafang", subtitle:  todayWord.text!, body: todayWordDefination.text!, badge: 1, delayInterval: nil)
        ////
        //
        //        notificationPublisher.sendNotification(title: "Word Of The Day", subtitle:  todayWord.text!, body: todayWordDefination.text!, badge: 1, delayInterval: 10)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil {
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            //            let notificationCenter = UNUserNotificationCenter.current()
            //            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            //
            //            notificationCenter.requestAuthorization(options: options) {
            //                (didAllow, error) in
            //                if !didAllow {
            //                    print("User has declined notifications")
            //                }
            //            }
            //
            //
            //
            //
            //            notificationCenter.getNotificationSettings { (settings) in
            //                if settings.authorizationStatus != .authorized {
            //                    // Notifications not allowed
            //                }
            //            }
            //
            //            notificationCenter.getNotificationSettings { (settings) in
            //                if settings.authorizationStatus != .authorized {
            //                    // Notifications not allowed
            //                }
            //            }
            //
            //            let content = UNMutableNotificationContent()
            //            content.title = "Tu ni hrang Cafang"
            //            content.body = "Beautiful"
            //            content.sound = UNNotificationSound.default
            //
            //           // var dateComponents = DateComponents()
            //
            //           //dateComponents.second = 5
            //
            //           // let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            //           // let triggerDaily = Calendar.current.dateComponents([hour, .minute, .second], from: date)
            //
            //            let Timetrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            //
            //            let date = Date(timeIntervalSinceNow: 3600)
            //            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            //
            //            //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            //
            //            let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
            //            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
            //
            //            let identifier = "UYLLocalNotification"
            //            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: Timetrigger)
            //
            //            notificationCenter.add(request, withCompletionHandler: { (error) in
            //                if error != nil {
            //                    // Something went wrong
            //                }
            //            })
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
        
        
        
        // wordOfDay.word = todayWord.text!
        //wordOfDay.Defination = todayWordDefination.text!
        
        wordOfDay.word = "\(wordCount[randomNumber].searchWord)"
        wordOfDay.Defination = "\(wordCount[randomNumber].wordDefination)"
        // print ("Daily Word: ", dailyWord)
        //print ("Daily Word Defination: ", dailyDefination)
        print ("Random Number ---> ", maxNumber)
        // print (wordOfDay.word!)
        // print (wordOfDay.Defination!)
        
        try? realm.write {
            realm.add(word)
        }
    }
    
    func openRealm() {
        let bundlePath = Bundle.main.path(forResource: "default", ofType: "realm")!
        let defaultPath = Realm.Configuration.defaultConfiguration.fileURL?.path
        let fileManager = FileManager.default
        
        // Only need to copy the prepopulated `.realm` file if it doesn't exist yet
        if !fileManager.fileExists(atPath: defaultPath!){
            print("use pre-populated database")
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: defaultPath!)
                print("Copied")
            } catch {
                print(error)
            }
        }
    }
    
    func loadWordOfTheDay()
    {
        
        let wordCount = realm.objects(wordOfTheDay.self)
        let maxNumber:Int = wordCount.count
        
        
        
        //        todayWord.text = "\(wordCount[maxNumber - 1].word!)"
        //        todayWordDefination.text = "\(wordCount[maxNumber - 1].Defination!)"
        
        let definationSplit = "\(String(describing: (wordCount[maxNumber - 1].Defination!)))"
        let completedSplit: [String] = definationSplit.components(separatedBy: ",")
        
        
        //todayWord.text = "\((wordCount[maxNumber - 1].word!))"
        
        todayWord.text = "\((wordCount[maxNumber - 1].word!))"
        
        var labelText = ""
        for (index,element) in completedSplit.enumerated() {
            
            labelText += "\(index + 1).\(element)\n"
            
            print (index,"\u{2022}",element)
            todayWordDefination.text = "\(labelText)"
            //todayWordDefination.text = "how are you"
        }
        // print ("Daily Word: ", dailyWord)
        //print ("Daily Word Defination: ", dailyDefination)
        //print ("Max Number ---> ", maxNumber)
        //print (wordOfDay.word!)
        // print (wordOfDay.Defination!)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func run24HoursTimer() {
        
        let currentDate = Date()
        let waitingDateTimeInterval:Int64 = UserDefaults.standard.value(forKey: "waiting_date") as? Int64 ?? 0
        let currentDateTimeInterval = currentDate.currentTimeMillis()
        let dateDiffrence = currentDateTimeInterval - waitingDateTimeInterval
        if dateDiffrence > 24*60*60*1000 {
            // Call the function that you want to be repeated every 24 hours here:
            notificationPublisher.scheduleNotification(title: "Word Of The Day", subtitle:  todayWord.text!, body: todayWordDefination.text!, badge: 1, delayInterval: nil)
            
            UserDefaults.standard.setValue(currentDateTimeInterval, forKey: "waiting_date")
            UserDefaults.standard.synchronize()
        }
    }
    
    
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
