//
//  SettingViewController.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 5/27/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

var questionBank: Results<recentSearch>?
var question: Results<Data>?
var numQuestion = Data()


class SettingViewController: UIViewController {

    @IBOutlet weak var SettingButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wordCount = realm.objects(Data.self)
        
        let random0 = createWordOfTheDay(word: numQuestion)
        let random1 = createWordOfTheDay(word: numQuestion)
        let random2 = createWordOfTheDay(word: numQuestion)
        
        var question1 = ""
        var question2 = ""
        var question3 = ""
        


        var questionCounter = 3
        var questions = [Int]()

       
        
        question1 = wordCount[random0].searchWord
        question2 = wordCount[random1].searchWord
        question3 = wordCount[random2].searchWord
        
        print (question1)
        print (question2)
        print (question3)
        
        revealViewController().rearViewRevealWidth = 200
        SettingButton.target = revealViewController()
        SettingButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        for _ in 0..<questionCounter{
        createWordOfTheDay(word: numQuestion)
        }
        questionCounter = questionCounter + 1


    }
    

    func createWordOfTheDay(word:Data) -> Int{
        
        let wordCount = realm.objects(Data.self)
        let maxNumber:Int = wordCount.count
        var randomNumber = Int.random(in: 0..<maxNumber)
        
        var random1 = 0
        var random2 = 0
        var random3 = 0
        var previousNumber:Int = 0
        
        while previousNumber == randomNumber {
            
                randomNumber = Int.random(in: 0..<maxNumber)
                previousNumber = randomNumber
           
            
           
        }
        

        return randomNumber
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
