//
//  RegisterSecond.swift
//  PM2.5
//
//  Created by DMCL on 2017/5/9.
//  Copyright © 2017年 DMCL. All rights reserved.
//

import UIKit

class RegisterSecond: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    @IBOutlet weak var UserRealName: UITextField!
    @IBOutlet weak var UserHeight: UITextField!
    @IBOutlet weak var UserWeight: UITextField!
    @IBOutlet weak var dataPickerTxt: UITextField!
    @IBOutlet weak var sexTxt: UITextField!
    var sex = ["男性" , "女性"]
    
    
    let picker = UIPickerView()
    let dataPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        picker.delegate = self
        picker.dataSource = self
        sexTxt.inputView = picker
    }

    // birthday
    func createDatePicker(){
        
        //format for picker
        dataPicker.datePickerMode = .date
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done ,target: nil , action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        dataPickerTxt.inputAccessoryView = toolbar
        
        // assign date picker to text field
        dataPickerTxt.inputView = dataPicker
    }
    
    func donePressed(){
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        dataPickerTxt.text = dateFormatter.string(from: dataPicker.date)
        self.view.endEditing(true)
    }
    
    
    // sex
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int {
        return sex.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component:Int ) -> String? {
        return sex[row]
    }
    
    func pickerView(_ pickerView: UIPickerView , didSelectRow row: Int, inComponent component: Int){
        sexTxt.text = sex[row]
        self.view.endEditing(false)
    }
    
    
    @IBAction func CompletedButton(_ sender: Any) {
        let RealName = UserRealName.text
        let Height = UserHeight.text
        let Weight = UserWeight.text
        let Birth = dataPickerTxt.text
        let sex = sexTxt.text
        
        let Email = String(describing: UserDefaults.standard.value(forKey: "NewUserName")!)
        let Password = String( describing: UserDefaults.standard.value(forKey: "NewUserPassword")!)
        
        let request = NSMutableURLRequest(url : NSURL(string: "http://10.133.200.109/RegisterSubmit.php")! as URL)
        request.httpMethod = "POST"
        
        //let postString = "IOS_user=\(Email!)&IOS_userpw=\(Password!)"
        let postString = "Email=\(Email)&Password=\(Password)&realname=\(RealName!)&birthday=\(Birth!)&weight=\(Weight!)&height=\(Height!)&sex=\(sex!)"
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
                let Alert: UIAlertController = UIAlertController(title: "註冊", message: "註冊成功" , preferredStyle: .alert)
                let action = UIAlertAction(title: "確認", style: UIAlertActionStyle.default,handler: {action in self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)})
                Alert.addAction(action)
                self.present(Alert , animated: true, completion: nil)
            }
            
            
        }
        task.resume()
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
