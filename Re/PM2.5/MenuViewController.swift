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
        let userphone = UserDefaults.standard.value(forKey: "UserPhone")!
            
        self.SexLabel.text = String(describing: userSex)
        self.BirthLabel.text = String(describing: userBirthday)
        self.HeightLabel.text = String(describing: userHeight)
        self.WeightLabel.text = String(describing: userWeight)
        self.PhoneLabel.text = String(describing: userphone)
        self.NameLabel.text = String(describing: userName)
        self.EmailLabel.text = String(describing: userEmail)
        
        }
    }

   
    @IBAction func update_name(_ sender: Any) {
        let Alert: UIAlertController = UIAlertController(title: "名字更改", message: "請輸入要更改的名稱" , preferredStyle: .alert)
        
        Alert.addTextField{ (textField) in
            textField.placeholder = "名字"
        }
        
        let cancelaction = UIAlertAction(title: "取消", style: .cancel,handler: nil)
        Alert.addAction(cancelaction)
        let okaction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {action in self.update_info(obj: "name", input: (Alert.textFields?.first?.text)!)})
        Alert.addAction(okaction)
        self.present(Alert , animated: true, completion: nil)
    }
    
    @IBAction func update_password(_ sender: Any) {
        let Alert: UIAlertController = UIAlertController(title: "密碼更改", message: "請輸入要更改的密碼" , preferredStyle: .alert)
        
        Alert.addTextField{ (textField) in
            textField.placeholder = "新密碼"
            textField.isSecureTextEntry = true
        }
        Alert.addTextField{ (textField) in
            textField.placeholder = "確認密碼"
            textField.isSecureTextEntry = true
        }
        let cancelaction = UIAlertAction(title: "取消", style: .cancel,handler: nil)
        Alert.addAction(cancelaction)
        let okaction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {action in self.update_info(obj: "password", input: (Alert.textFields?.first?.text)!+":"+(Alert.textFields?.last?.text)!)})
        Alert.addAction(okaction)
        self.present(Alert , animated: true, completion: nil)

    }
    
    @IBAction func update_height(_ sender: Any) {
        let Alert: UIAlertController = UIAlertController(title: "身高更改", message: "請輸入要更改的身高" , preferredStyle: .alert)
        
        Alert.addTextField{ (textField) in
            textField.placeholder = "身高"
        }
        
        let cancelaction = UIAlertAction(title: "取消", style: .cancel,handler: nil)
        Alert.addAction(cancelaction)
        let okaction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {action in self.update_info(obj: "height", input: (Alert.textFields?.first?.text)!)})
        Alert.addAction(okaction)
        self.present(Alert , animated: true, completion: nil)

    }
    
    @IBAction func update_weight(_ sender: Any) {
        let Alert: UIAlertController = UIAlertController(title: "體重更改", message: "請輸入要更改的體重" , preferredStyle: .alert)
        
        Alert.addTextField{ (textField) in
            textField.placeholder = "體重"
        }
        
        let cancelaction = UIAlertAction(title: "取消", style: .cancel,handler: nil)
        Alert.addAction(cancelaction)
        let okaction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {action in self.update_info(obj: "weight", input: (Alert.textFields?.first?.text)!)})
        Alert.addAction(okaction)
        self.present(Alert , animated: true, completion: nil)
    }
    
    @IBAction func update_phone(_ sender: Any) {
        let Alert: UIAlertController = UIAlertController(title: "電話更改", message: "請輸入要更改的電話" , preferredStyle: .alert)
        
        Alert.addTextField{ (textField) in
            textField.placeholder = "電話"
        }
        
        let cancelaction = UIAlertAction(title: "取消", style: .cancel,handler: nil)
        Alert.addAction(cancelaction)
        let okaction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {action in self.update_info(obj: "phone", input: (Alert.textFields?.first?.text)!)})
        Alert.addAction(okaction)
        self.present(Alert , animated: true, completion: nil)
    }
    
    private func update_info( obj : String , input : String){
        let userEmail = UserDefaults.standard.value(forKey: "UserEmail")!
       
        let request = NSMutableURLRequest(url : NSURL(string: "http://120.126.145.118/PM/update.php")! as URL)
        request.httpMethod = "POST"
        
        var postString = ""
        if(obj == "name"){
            postString = "Email=\(userEmail)&realname=\(input)"
        }else if(obj == "height"){
            postString = "Email=\(userEmail)&height=\(input)"
        }else if(obj == "weight"){
            postString = "Email=\(userEmail)&weight=\(input)"
        }else if(obj == "phone"){
            postString = "Email=\(userEmail)&phone=\(input)"
        }else if(obj == "password"){
            let password1 = input.components(separatedBy: ":")[0]
            let password2 = input.components(separatedBy: ":")[1]
            if(password1 != password2){
                let Alert: UIAlertController = UIAlertController(title: "更改失敗", message: "密碼有誤" , preferredStyle: .alert)
                let action = UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {action in self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)})
                Alert.addAction(action)
                self.present(Alert , animated: true, completion: nil)
            }else{
                postString = "Email=\(userEmail)&password=\(password1)"
                
            }
        }
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data , response , error in
            
            if error != nil{
                print("error=\(String(describing: error))")
            }
            print("response =\(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(String(describing: responseString))
            
            DispatchQueue.main.async(){
                
                if( String(describing: responseString)=="Optional(true)" && obj != "password"){
                    self.updateLabel(obj : obj , input : input)
                }else if(String(describing: responseString)=="Optional(true)"){
                    let Alert: UIAlertController = UIAlertController(title: "成功", message: "密碼更改成功" , preferredStyle: .alert)
                    let action = UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {action in self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)})
                    Alert.addAction(action)
                    self.present(Alert , animated: true, completion: nil)

                }
            }
            
            
        }
        task.resume()

    }
    
     func updateLabel(obj : String , input : String){
        

        if(obj=="name"){
            UserDefaults.standard.set( input , forKey: "UserName")
            self.NameLabel.text = input
        }else if(obj == "height"){
            UserDefaults.standard.set( input , forKey: "UserHeight")
            self.HeightLabel.text = input
        }else if(obj == "weight"){
            UserDefaults.standard.set( input , forKey: "UserWeight")
            self.WeightLabel.text = input
        }else if(obj == "phone"){
            UserDefaults.standard.set( input , forKey: "UserPhone")
            self.PhoneLabel.text = input
        }

    }
    
    @IBAction func Logout(_ sender: Any) {
        UserDefaults.standard.set( false , forKey: "LoginNow")
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
   
    
}
