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
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var questionCount: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    
    
    var currentQuestion = 0
    var questionLength = 10
    var rightAnswer:UInt32 = 0
    var userPoint = 0
    
  
    
    @IBAction func checkAnswer(_ sender: AnyObject) {
        
        if (sender.tag == Int(rightAnswer)){
            print ("correct answer")
            ProgressHUD.showSuccess("Correct")
            
            userPoint += 100
        }
        else{
            print ("wrong answer")
            ProgressHUD.showError("Wrong!")
            
        }
                if (currentQuestion <= questionLength){
                    newQuestion()
                }
                else{
                    print ("end of quiz")
                   
                    
                    let alert = UIAlertController(title: "Quiz completed", message: "You have completed the Quiz", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: startOver)
                    
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        revealViewController().rearViewRevealWidth = 200
        SettingButton.target = revealViewController()
        SettingButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        newQuestion()
    }
    
    func startOver(){
         currentQuestion = 0
         userPoint = 0
    }
    func newQuestion(){
        
        totalScore.text = "\(userPoint)\n" + "/" + "10"
        questionCount.text = "\(currentQuestion)"
        
        let wordCount = realm.objects(Data.self)
        let random0 = createWordOfTheDay(word: numQuestion)
        let random1 = createWordOfTheDay(word: numQuestion)
        let random2 = createWordOfTheDay(word: numQuestion)
        
        let randomQuestion = wordCount[random0].wordDefination
        
        var question1 = ""
        var question2 = ""
        var question3 = ""
        var questions = [String]()
        
        question1 = wordCount[random0].searchWord
        question2 = wordCount[random1].searchWord
        question3 = wordCount[random2].searchWord
        
        questions.append(question1)
        questions.append(question2)
        questions.append(question3)
        
        question.text! = randomQuestion
        rightAnswer = arc4random_uniform(3) + 1
        
        
        var x = 1
        
        for i in 1...3{
            
            let answer = view.viewWithTag(i) as? UIButton
            if (i == rightAnswer){
                answer!.setTitle(questions[0], for: .normal)
            }
            else {
                answer!.setTitle(questions[x], for: .normal)
                x = 2
            }
        }
         currentQuestion += 1
    }
    
    func createWordOfTheDay(word:Data) -> Int{
        
        let wordCount = realm.objects(Data.self)
        let maxNumber:Int = wordCount.count
        var randomNumber = Int.random(in: 0..<maxNumber)
        var previousNumber:Int = 0
        
        while previousNumber == randomNumber {
            
            randomNumber = Int.random(in: 0..<maxNumber)
            previousNumber = randomNumber
        }
        return randomNumber
    }
    
}
