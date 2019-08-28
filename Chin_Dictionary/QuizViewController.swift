//
//  QuizViewController.swift
//  Chin_Dictionary
//
//  Created by Mr.Mang Pi on 8/28/19.
//  Copyright © 2019 Chin Community USA. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var aboutLbl: UILabel!
    
    @IBOutlet weak var QuizButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        aboutLbl.text = "This app is developed and managed by Chin Community USA.\n"
        + "\n ©Lailun Foundation - Mirang - Lai\n" +
        "\nFor more information, please visit Chin Community USA\n" +
        "www.chincommunityusa.org";
        revealViewController().rearViewRevealWidth = 200
        QuizButton.target = revealViewController()
        QuizButton.action = #selector(SWRevealViewController.revealToggle(_:))

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
