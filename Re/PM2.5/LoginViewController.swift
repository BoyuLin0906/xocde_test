//
//  LoginViewController.swift
//  PM2.5
//
//  Created by DMCL on 2017/5/9.
//  Copyright © 2017年 DMCL. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {

    
    @IBOutlet weak var UserEmailTextField: UITextField!
    @IBOutlet weak var UserPasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UserEmailTextField.delegate = self
        UserPasswordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UserEmailTextField.resignFirstResponder()
        UserPasswordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    @IBAction func LoginButton(_ sender: Any) {
        
        let userEmail = UserEmailTextField
        let userPassword = UserPasswordTextField
        
        info(Email: (userEmail?.text)! , Password: (userPassword?.text)!)
       /*
        let Login = UserDefaults.standard.value(forKey: "UserPassword_TF")! as! Bool
        
        if(Login==true){
                // 內存
                UserDefaults.standard.set( true, forKey: "LoginNow")
                UserDefaults.standard.set( userEmail?.text , forKey: "UserEmail")
                let userName = "林柏榆"
                UserDefaults.standard.set( userName , forKey: "UserName")
                let userSex = "男"
                UserDefaults.standard.set( userSex , forKey: "ＵserSex")
                let userBirthday = "1993/9/6"
                UserDefaults.standard.set( userBirthday , forKey: "UserBirth")
                let userHeight = 169.9
                UserDefaults.standard.set( userHeight , forKey: "UserHeight")
                let userWeight = 60.1
                UserDefaults.standard.set( userWeight , forKey: "UserWeight")
                
                self.dismiss(animated: true, completion: nil)
        }
         */
    }
    
    // 判斷登陸是否成功
    func info(Email: String , Password: String){
        
        let request = NSMutableURLRequest(url : NSURL(string: "http://10.133.200.109/info.php")! as URL)
        request.httpMethod = "POST"
        
        //let postString = "IOS_user=\(Email!)&IOS_userpw=\(Password!)"
        let postString = "IOS_user=\(Email)&IOS_password=\(Password)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler :{
            (data , response , error) -> Void in
            
            if error != nil{
                print("error=\(String(describing: error))")
            }
            print("response =\(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            let check = String(describing: responseString)
            if(check=="Optional(true)"){
                DispatchQueue.main.async(){
                    UserDefaults.standard.set( true , forKey: "UserPassword_TF")
                    self.loginSucces(Email : Email)
                }
            }else{
                 DispatchQueue.main.async(){
                    let userAlert:UIAlertController = UIAlertController(title:"輸入錯誤", message: "請重新輸入！", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.default , handler: {action in print("done")})
                    userAlert.addAction(action)
                    self.present(userAlert , animated: true , completion: nil)
                }
            }
            
            
        })
        task.resume()
        
    }
    
    // 成功登陸後，載入內存
    func loginSucces(Email : String){
        let Login = UserDefaults.standard.value(forKey: "UserPassword_TF")! as! Bool
        
        if(Login==true){
            // 內存
            
            let request = NSMutableURLRequest(url : NSURL(string: "http://10.133.200.109/userlogin.php")! as URL)
            request.httpMethod = "POST"
            
            //let postString = "IOS_user=\(Email!)&IOS_userpw=\(Password!)"
            let postString = "IOS_user=\(Email)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler :{
                (data , response , error) -> Void in
                
                if error != nil{
                    print("error=\(String(describing: error))")
                }
                //print("response =\(String(describing: response))")
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(String(responseString!))
                
                 DispatchQueue.main.async(){
                var text = String(responseString!)
                text = text.replacingOccurrences(of: "{", with: "")
                text = text.replacingOccurrences(of: "}", with: "")
                text = text.replacingOccurrences(of: "[", with: "")
                text = text.replacingOccurrences(of: "]", with: "")
                text = text.replacingOccurrences(of: "\"", with: "")
                var textArr = text.components(separatedBy: ",")
                let Email: String = textArr[1].components(separatedBy: ":")[1]
                let userName: String = textArr[3].components(separatedBy: ":")[1]
                let userSex: String = textArr[7].components(separatedBy: ":")[1]
                let userHeight: String = textArr[6].components(separatedBy: ":")[1]
                let userWeight: String = textArr[5].components(separatedBy: ":")[1]
                let userBirthday: String = textArr[4].components(separatedBy: ":")[1]
                
                UserDefaults.standard.set( true, forKey: "LoginNow")
                UserDefaults.standard.set( Email , forKey: "UserEmail")
                UserDefaults.standard.set( userName , forKey: "UserName")
                UserDefaults.standard.set( userSex , forKey: "ＵserSex")
                UserDefaults.standard.set( userBirthday , forKey: "UserBirth")
                UserDefaults.standard.set( userHeight , forKey: "UserHeight")
                UserDefaults.standard.set( userWeight , forKey: "UserWeight")
                
                self.dismiss(animated: true, completion: nil)
                }
            })
            task.resume()

            
            
            
            UserDefaults.standard.set( true, forKey: "LoginNow")
            UserDefaults.standard.set( Email , forKey: "UserEmail")
            let userName = "林柏榆"
            UserDefaults.standard.set( userName , forKey: "UserName")
            let userSex = "男"
            UserDefaults.standard.set( userSex , forKey: "ＵserSex")
            let userBirthday = "1993/9/6"
            UserDefaults.standard.set( userBirthday , forKey: "UserBirth")
            let userHeight = 169.9
            UserDefaults.standard.set( userHeight , forKey: "UserHeight")
            let userWeight = 60.1
            UserDefaults.standard.set( userWeight , forKey: "UserWeight")
            
            self.dismiss(animated: true, completion: nil)
        }

    }

   
}
