//
//  NotificationPublisher.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 7/31/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import RealmSwift

var notificationWord = wordOfTheDay()

struct Notification{
    public var word: String = ""
    static var defination: String = ""
}
weak var todayWord: UILabel!
weak var todayWordDefination: UILabel!
weak var dateLabel: UILabel!


class NotificationPublisher: NSObject
{
    @IBOutlet weak var tblAppleProducts: UITableView!
    
    
    func sendNotification (title: String, subtitle: String, body: String, badge: Int?, delayInterval: Int?){
        
        createWordOfTheDay(word:notificationWord)

        print ("Daily Notification")
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        
        
        var delayTimeTrigger: UNTimeIntervalNotificationTrigger?
        
        if let delayInterval = delayInterval{
            delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats: false)
            
        }
        
        if let badge = badge {
            
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
        }
        notificationContent.sound = UNNotificationSound.default
        
        UNUserNotificationCenter.current().delegate = self
        
        let request = UNNotificationRequest (identifier: "UNLocalNotification", content: notificationContent, trigger: delayTimeTrigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print (error.localizedDescription)
            }
        }
    }
    
    
    func scheduleNotification (title: String, subtitle: String, body: String, badge: Int?, delayInterval: Int?){
        
       

       // DetailsViewController.GlobalVariable.fromRecent1 = true

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        
        if let badge = badge {
            
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
        }
        notificationContent.sound = UNNotificationSound.default
        
        UNUserNotificationCenter.current().delegate = self
        
        let secondRequest = UNNotificationRequest (identifier: "UNLocalNotification", content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(secondRequest) { error in
            if let error = error {
                print (error.localizedDescription)
            }
        }
        
        
        
        
        
        
    }
    
}

extension NotificationPublisher: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print ("The notification is comming....")
        createWordOfTheDay(word:notificationWord)

        
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        switch identifier {
            
        case UNNotificationDismissActionIdentifier:
            print ("Notification was dissmissed")
            completionHandler()
            
        case UNNotificationDefaultActionIdentifier:
            print ("The user tapped the notification:")
            completionHandler()
            
        default:
            print ("The default case was called")
            completionHandler()
        }
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
        notificationWord.dateCreated = Date()
        
        
        guard let realm = try? Realm() else {
            return
        }
        
        
        notificationWord.word = "\(wordCount[randomNumber].searchWord)"
        notificationWord.Defination = "\(wordCount[randomNumber].wordDefination)"
        // print ("Daily Word: ", dailyWord)
        //print ("Daily Word Defination: ", dailyDefination)
        print ("Random Number ---> ", maxNumber)
        // print (wordOfDay.word!)
        // print (wordOfDay.Defination!)
        
        try? realm.write {
            realm.add(word)
        }
    }
    
    
}
