//
//  MainViewController.swift
//  memuDemo
//
//  Created by Mr.Mang Pi on 5/1/19.
//  Copyright © 2019 Parth Changela. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UINavigationBarDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var MainButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        revealViewController().rearViewRevealWidth = 200
        MainButton.target = revealViewController()
        MainButton.action = #selector(SWRevealViewController.revealToggle(_:))
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
