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

var wordOfDay1 = wordOfTheDay()

class NotificationPublisher: NSObject
{
    @IBOutlet weak var tblAppleProducts: UITableView!
    
    
    func sendNotification (title: String, subtitle: String, body: String, badge: Int?, delayInterval: Int?){
        
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
        
        let creteWordOfDay = ViewController();
        
        creteWordOfDay.createWordOfTheDay(word: wordOfDay1)
        
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
}
