//
//  SettingViewController.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 5/27/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit
import UserNotifications

class SettingViewController: UIViewController {
    
    
    
    

    @IBOutlet weak var SettingButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        revealViewController().rearViewRevealWidth = 200
        SettingButton.target = revealViewController()
        SettingButton.action = #selector(SWRevealViewController.revealToggle(_:))
        

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
