//
//  helpViewController.swift
//  PM2.5
//
//  Created by 林柏榆 on 2017/7/4.
//  Copyright © 2017年 DMCL. All rights reserved.
//

import UIKit

class helpViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var suggestionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        
        let userEmail = UserDefaults.standard.value(forKey: "UserEmail")!
        let text = suggestionTextField.text!
        
        let request = NSMutableURLRequest(url : NSURL(string: "http://120.126.145.118/PM/onhalation_record.php")! as URL)
        request.httpMethod = "POST"
        
        //let postString = "IOS_user=\(Email!)&IOS_userpw=\(Password!)"
        let postString = "Email=\(userEmail)&text\(text)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data , response , error in
            
            if error != nil{
                print("error=\(String(describing: error))")
            }
            print("response =\(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            
            DispatchQueue.main.async(){
                let Alert: UIAlertController = UIAlertController(title: "紀錄", message: "紀錄成功" , preferredStyle: .alert)
                let action = UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {action in print("OK")})
                Alert.addAction(action)
                self.present(Alert , animated: true, completion: nil)
            }
            
            
        }
        task.resume()

    }
    
    @IBAction func personality(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }


}
