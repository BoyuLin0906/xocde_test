//
//  MenuViewController.swift
//  PM2.5
//
//  Created by DMCL on 2017/5/10.
//  Copyright © 2017年 DMCL. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController  {

    
    
    
    @IBOutlet weak var underbackground: UIView!
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var View3: UIView!
    @IBOutlet weak var View4: UIView!
    @IBOutlet weak var View5: UIView!
    @IBOutlet weak var NameView: UIView!
    @IBOutlet weak var MailView: UIView!
    
    @IBOutlet weak var SexLabel: UILabel!
    @IBOutlet weak var BirthLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var HeightLabel: UILabel!
    @IBOutlet weak var WeightLabel: UILabel!
    
    
    @IBOutlet weak var UserImg: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    
    /*
    let sections: [String] = ["Section 1","Section 2"]
    let s1Data: [String] = ["Row1","Row2"]
    let s2Data: [String] = ["Row1","Row2"]
    let s3Data: [String] = ["Row1","Row2"]
    
    var sectionData: [Int: [String]]=[:]
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        //個人圖片
        self.UserImg.layer.cornerRadius = UserImg.frame.size.width/2
        self.UserImg.clipsToBounds = true
        self.UserImg.layer.borderColor = UIColor.white.cgColor
        self.UserImg.layer.borderWidth = 3
        //profie
        self.underbackground.layer.cornerRadius = 10
        self.underbackground.clipsToBounds = true
        
        self.View1.layer.cornerRadius = 10
        self.View1.clipsToBounds = true
        
        self.View2.layer.cornerRadius = 10
        self.View2.clipsToBounds = true
        
        self.View3.layer.cornerRadius = 10
        self.View3.clipsToBounds = true
        
        self.View4.layer.cornerRadius = 10
        self.View4.clipsToBounds = true
        
        self.View5.layer.cornerRadius = 10
        self.View5.clipsToBounds = true
        
        self.NameView.layer.cornerRadius = 5
        self.NameView.clipsToBounds = true
        
        self.MailView.layer.cornerRadius = 5
        self.MailView.clipsToBounds = true
        //
        /*
        tableView.delegate = self
        tableView.dataSource = self
        sectionData = [0 : s1Data, 1 : s2Data , 3 : s3Data]
        */
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLogin = UserDefaults.standard.value(forKey: "LoginNow") as! Bool
        if(!isUserLogin){
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
        else if(isUserLogin){
        let userEmail = UserDefaults.standard.value(forKey: "UserEmail")!
        let userName = UserDefaults.standard.value(forKey: "UserName")!
        let userBirthday = UserDefaults.standard.value(forKey: "UserBirth")!
        let userSex = UserDefaults.standard.value(forKey: "ＵserSex")!
        let userHeight = UserDefaults.standard.value(forKey: "UserHeight")!
        let userWeight = UserDefaults.standard.value(forKey: "UserWeight")!
            
        self.SexLabel.text = String(describing: userSex)
        self.BirthLabel.text = String(describing: userBirthday)
        self.HeightLabel.text = String(describing: userHeight)
        self.WeightLabel.text = String(describing: userWeight)
        self.PhoneLabel.text = "09XXXXXXXX"
            
        self.NameLabel.text = String(describing: userName)
        self.EmailLabel.text = String(describing: userEmail)
        self.UserImg.image = UIImage(named: "person")
        }
    }

    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionData[section]?.count)!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell!.textLabel?.text = sectionData[indexPath.section]![indexPath.row]
        return cell!
    }
    */
    
    
    @IBAction func Logout(_ sender: Any) {
        UserDefaults.standard.set( false , forKey: "LoginNow")
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
   
    
}
