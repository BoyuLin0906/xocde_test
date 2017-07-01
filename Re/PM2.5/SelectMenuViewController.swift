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
    var seconds = 0
    var minutes = 0
    var hours = 0
    var all_seconds = 0.0
    var countPosition = 0
    var distance = 0.0
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
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
            print("do it!!!")
        }

        
        // Do any additional setup after loading the view.
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
            distance = distance + d
            let dis = String(format: "%.4f",distance)
            distanceLabel.text = "\(dis) 公里"
            print(distance)
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
        seconds += 1
        all_seconds += 1
        if(seconds==60){
            seconds -= 60
            minutes += 1
        }
        if (minutes==60){
            seconds -= 60
            hours += 1
        }
        let avgspeed =  String(format: "%.4f",distance / (all_seconds / 3600))
        let userWeight = UserDefaults.standard.value(forKey: "UserWeight")!
        let weight = Double(String(describing: userWeight))
        let cal =  String(format: "%.4f", (weight! * distance * 1.036))
        timeLabel.text = "\(hours) 時 \(minutes) 分 \(seconds) 秒"
        avgSpeedLabel.text = "\(avgspeed) 公里/時"
        KcalLabel.text = "\(cal) 卡路里"
    }

    @IBAction func StopButton(_ sender: Any) {
        timer.invalidate()
        GPStimer.invalidate()
        timerIsOn = false

    }

    @IBAction func Persionality(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
