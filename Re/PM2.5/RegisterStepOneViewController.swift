//
//  RegisterStepOneViewController.swift
//  PM2.5
//
//  Created by DMCL on 2017/5/11.
//  Copyright © 2017年 DMCL. All rights reserved.
//

import UIKit

class RegisterStepOneViewController: UIViewController {

    

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var CheckPasswordTextField: UITextField!
    
    
    @IBOutlet weak var WarningText: UILabel!
    
    var check = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //self.performSegue(withIdentifier: "SecRegister", sender: self)
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func NextRegister(_ sender: Any) {
        let Email = EmailTextField.text
        let Password = PasswordTextField.text
        let CheckPassword = CheckPasswordTextField.text
        
        
        if(Email != "" && Password != "" && CheckPassword != ""){
            if(Password==CheckPassword){
                info(Email: Email!, Password: Password!)
                
            }else{
                self.WarningText.text = "密碼不一樣"
            }
        }else{
            self.WarningText.text = "上述框框請勿空白"
        }
        
    }
    func info(Email: String , Password: String){
        
        let request = NSMutableURLRequest(url : NSURL(string: "http://10.133.200.109/GetUserInformation.php")! as URL)
        request.httpMethod = "POST"
        
        //let postString = "IOS_user=\(Email!)&IOS_userpw=\(Password!)"
        let postString = "IOS_user=\(Email)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler :{
        (data , response , error) -> Void in
            
            if error != nil{
            print("error=\(String(describing: error))")
            }
            print("response =\(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            self.check = String(describing: responseString)
            if(self.check=="Optional(true)"){
                DispatchQueue.main.async(){
                UserDefaults.standard.set( Email , forKey: "NewUserName")
                UserDefaults.standard.set( Password , forKey: "NewUserPassword")
                self.performSegue(withIdentifier: "SecRegister", sender: self)
                }
            }
            else{
                DispatchQueue.main.async(){
                self.WarningText.text = "帳號已存在"
                }
            }
        })
        task.resume()

    }
    
    
    @IBAction func RegisterOneBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

    
}
