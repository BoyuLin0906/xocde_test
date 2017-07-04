//
//  SelectMenuViewController.swift
//  PM2.5
//
//  Created by DMCL on 2017/5/11.
//  Copyright © 2017年 DMCL. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class SelectMenuViewController: UIViewController , CLLocationManagerDelegate {

    var locationManager : CLLocationManager! = CLLocationManager()
    // 經緯度
    var lat : Float = 0.0
    var long : Float = 0.0
    
    //時間
    var seconds : Int?
    var minutes : Int?
    var hours : Int?
    var all_seconds : Double?
    var countPosition = 0
    var distance : Double?
    var pastLocation = CLLocationCoordinate2DMake(CLLocationDegrees(0.0), CLLocationDegrees(0.0))
    
    var timer = Timer()
    var GPStimer = Timer()
    var GPSLocationTimer = Timer()
    var timerIsOn = false

    //Label
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
        @IBOutlet weak var KcalLabel: UILabel!
    
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // menu
        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        // location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
           
        }
        // timer start to stop
      
        
        // before value
        //if(isKeyPresentInUserDefaults(key: "seconds")&&isKeyPresentInUserDefaults(key: "all_seconds")&&isKeyPresentInUserDefaults(key: "minutes")&&isKeyPresentInUserDefaults(key: "hours")&&isKeyPresentInUserDefaults(key: "distance")){
            let _all_seconds = UserDefaults.standard.value(forKey: "all_seconds")! as? Double
            let _hours = UserDefaults.standard.value(forKey: "hours")! as? Int
            let _minutes = UserDefaults.standard.value(forKey: "minutes")! as? Int
            let _seconds = UserDefaults.standard.value(forKey: "seconds")! as? Int
            let _distance = UserDefaults.standard.value(forKey: "distance")! as? Double
        
        if (_all_seconds == 0.0){
            seconds = 0
            minutes = 0
            hours = 0
            all_seconds = 0.0
            distance = 0.0
        }else{
            let avgspeed =  String(format: "%.4f", _distance! / ( _all_seconds! / 3600))
            let userWeight = UserDefaults.standard.value(forKey: "UserWeight")!
            let weight = Double(String(describing: userWeight))
            let cal =  String(format: "%.4f", (weight! * _distance! * 1.036))
            // label
            timeLabel.text = "\(_hours!) 時 \(_minutes!) 分 \(_seconds!) 秒"
            avgSpeedLabel.text = "\(avgspeed) 公里/時"
            KcalLabel.text = "\(cal) 卡路里"
            let dis = String(format: "%.4f",_distance!)
            distanceLabel.text = "\(dis) 公里"
            
            seconds = _seconds
            minutes = _minutes
            hours = _hours
            all_seconds = _all_seconds
            distance = _distance
        }
        
        
       
        //}
        
        // Do any additional setup after loading the view.
    }
    
    
   

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let curr:CLLocation = locations.last!
        print("latitude : \(curr.coordinate.latitude)")
        lat = Float(curr.coordinate.latitude)
        print("longitude : \(curr.coordinate.longitude)")
        long = Float(curr.coordinate.longitude)
       
    }

    
    @IBAction func startButton(_ sender: Any) {
        if timerIsOn == false {
            
            // first
           // let currentLocation = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
            GPSLocationTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: (#selector(SelectMenuViewController.Location_update)), userInfo: nil, repeats: true)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(SelectMenuViewController.updateTimer)), userInfo: nil, repeats: true)
            GPStimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: (#selector(SelectMenuViewController.GMSpostion)), userInfo: nil, repeats: true)
            timerIsOn = true
        }

    }
    func Location_update(){
        locationManager.startUpdatingLocation()
    }
    func GMSpostion(){
        print("\(CLLocationDegrees(lat)) + \(CLLocationDegrees(long))")
        countPosition += 1
        if(countPosition != 1){
            let nowLocation = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
            let d = GMS_Distance(pointA: nowLocation,pointB: self.pastLocation)
            distance = distance! + d
            let dis = String(format: "%.4f",distance!)
            distanceLabel.text = "\(dis) 公里"
            print(distance!)
            UserDefaults.standard.set( distance , forKey: "distance")
        }
        self.pastLocation = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
        
        
    }
    
    public func GMS_Distance(pointA : CLLocationCoordinate2D , pointB : CLLocationCoordinate2D) -> Double{
        let EARTH_RADIUS : Double = 6378.137
        
        let radlng1 : Double = (pointA.longitude * Double.pi) / 180.0
        let radlng2 : Double = (pointB.longitude * Double.pi) / 180.0
        
        let a:Double = radlng1 - radlng2
        let b:Double = (pointA.latitude - pointB.latitude) * Double.pi / 180.0
        var s:Double = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radlng1)*cos(radlng2)*pow(sin(b/2), 2)))
        
        s = s * EARTH_RADIUS
        s = (round(s * 10000) / 10000)
        print("\(s)")
        return s
    }
    
    func updateTimer(){
        seconds! += 1
        all_seconds! += 1
        if(seconds!==60){
            seconds! -= 60
            minutes! += 1
        }
        if (minutes!==60){
            seconds! -= 60
            hours! += 1
        }
        let avgspeed =  String(format: "%.4f",distance! / (all_seconds! / 3600))
        let userWeight = UserDefaults.standard.value(forKey: "UserWeight")!
        let weight = Double(String(describing: userWeight))
        let cal =  String(format: "%.4f", (weight! * distance! * 1.036))
        // label
        timeLabel.text = "\(hours!) 時 \(minutes!) 分 \(seconds!) 秒"
        avgSpeedLabel.text = "\(avgspeed) 公里/時"
        KcalLabel.text = "\(cal) 卡路里"
        // save
        UserDefaults.standard.set( all_seconds , forKey: "all_seconds")
        UserDefaults.standard.set( minutes , forKey: "minutes")
        UserDefaults.standard.set( seconds , forKey: "seconds")
        UserDefaults.standard.set( hours , forKey: "hours")

          }
    // stop the timer
    @IBAction func StopButton(_ sender: Any) {
         if(timerIsOn){
            stopTimer()
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        GPStimer.invalidate()
        GPSLocationTimer.invalidate()
        timerIsOn = false
    }
    // init the all things
    @IBAction func clearButton(_ sender: Any) {
        // time
        
        if (!timerIsOn){
        seconds = 0
        all_seconds = 0
        minutes = 0
        hours = 0
        // distance
        distance = 0
        countPosition = 0
        //Label
        timeLabel.text = "0 時 0 分 0 秒"
        avgSpeedLabel.text = "0 公里/時"
        KcalLabel.text = "0 卡路里"
        distanceLabel.text = "0 公里"
            
        }
        
    }
    
    
    @IBAction func recodingButton(_ sender: Any) {
        
        if(!timerIsOn){
            
            let userEmail = UserDefaults.standard.value(forKey: "UserEmail")!
            let avgspeed =  distance! / (all_seconds! / 3600)
            let userWeight = UserDefaults.standard.value(forKey: "UserWeight")!
            let weight = Double(String(describing: userWeight))
            let cal =  (weight! * distance! * 1.036)

            
            
            let request = NSMutableURLRequest(url : NSURL(string: "http://120.126.145.118/PM/sport_record.php")! as URL)
            request.httpMethod = "POST"
            
            //let postString = "IOS_user=\(Email!)&IOS_userpw=\(Password!)"
            let postString = "Email=\(userEmail)&Time=\(all_seconds!)&distance=\(distance!)&speed=\(avgspeed)&cal=\(cal)"
            
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
        
 

        
        
    }
    
    @IBAction func Persionality(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
       
}
