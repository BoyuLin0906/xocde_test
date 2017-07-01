//
//  SettingViewController.swift
//  PM2.5
//
//  Created by DMCL on 2017/5/22.
//  Copyright © 2017年 DMCL. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }

    }

    @IBAction func personality(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
}
