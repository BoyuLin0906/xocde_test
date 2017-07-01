//
//  ViewController.swift
//  PM2.5
//
//  Created by DMCL on 2017/5/7.
//  Copyright © 2017年 DMCL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var LogoImage: UIImageView!
    @IBOutlet weak var CopyLabel: UILabel!
    @IBOutlet weak var RightLabel: UILabel!
    @IBOutlet weak var UseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LogoImage.alpha = 0
        CopyLabel.alpha = 0
        RightLabel.alpha = 0
        UseButton.alpha = 0
        
        UserDefaults.standard.set( false , forKey: "LoginNow")


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.LogoImage.alpha = 1
        }) { (true) in
            self.showCopy()
        }
    }
    
    func showCopy(){
        UIView.animate(withDuration: 1.0, animations: {
            self.CopyLabel.alpha = 1
        }, completion: { (true) in
            self.showRight()
        })
    }
    
    func showRight(){
        UIView.animate(withDuration: 1.0, animations: {
            self.RightLabel.alpha = 1
        }, completion: { (true) in
            self.showButton()
        })
    }
    
    func showButton(){
        UIView.animate(withDuration: 1.0, animations: {
            self.UseButton.alpha = 1
        })
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

