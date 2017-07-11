//
//  SecondSelectViewController.swift
//  PM2.5
//
//  Created by DMCL on 2017/5/12.
//  Copyright © 2017年 DMCL. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

class SecondSelectViewController: UIViewController , CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager! = CLLocationManager()
    var lat = 0.0
    var long = 0.0
    var pm = 0
    var inhalation = 0.0
    var IsTestOn = false
    
    let health = HKHealthStore()
    @IBOutlet weak var arrow1: UIImageView!
    @IBOutlet weak var arrow2: UIImageView!
    @IBOutlet weak var arrow3: UIImageView!
    @IBOutlet weak var arrow4: UIImageView!
    @IBOutlet weak var arrow5: UIImageView!
    @IBOutlet weak var arrow6: UIImageView!
    @IBOutlet weak var arrow7: UIImageView!
    @IBOutlet weak var arrow8: UIImageView!
    @IBOutlet weak var arrow9: UIImageView!
    @IBOutlet weak var arrow10: UIImageView!
    
    
    @IBOutlet weak var nomralLabel: UILabel!
    @IBOutlet weak var specailLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var singalLabel: UILabel!
    @IBOutlet weak var normalTitle: UILabel!
    @IBOutlet weak var specialTitle: UILabel!
    
    @IBOutlet weak var FaceImage: UIImageView!
    @IBOutlet weak var inhalationLabel: UILabel!
    
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        
        if HKHealthStore.isHealthDataAvailable(){
            
            let readTypes = self.dataTypesToRead()
            let shareTypes = self.dataTypesToShare()
            health.requestAuthorization(toShare: shareTypes, read: readTypes , completion : { (success,error) in
                if success {
                    self.getHeartRate(completion: { (results) in
                        if let results = results {
                            let unit = HKUnit.count().unitDivided(by: .minute())
                            var value: Double
                            
                            for p in results as! [HKQuantitySample] {
                                value = p.quantity.doubleValue(for: unit)
                                print ("心跳為: \(value)")
                                self.inhalationLabel.text = "心跳為: \(value)"
                            }
                        }
                    })
                }else{
                    print ("Error!!")
                }
            })
        }
 
        
    }
    
    
    func dataTypesToRead() -> Set< HKObjectType >? {
        var set = Set<HKObjectType>()
        set.insert(HKQuantityType.quantityType(forIdentifier: .heartRate)!)
        
        return set
    }
    
    func dataTypesToShare() -> Set< HKSampleType >? {
        var set = Set<HKSampleType>()
        set.insert(HKQuantityType.quantityType(forIdentifier: .heartRate)!)
        
        return set
    }
    
    func getHeartRate(completion: @escaping (_ result: [HKSample]?) -> Void){
        let type = HKQuantityType.quantityType(forIdentifier: .heartRate)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate , ascending: false)
        
        let query = HKSampleQuery(sampleType: type!,
                                  predicate: nil,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sort]){
                                    (query, results , error) in
                                    if error == nil{
                                        completion(results)
                                    }
                                    
        }
        health.execute(query)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let curr:CLLocation = locations.last!
        print("latitude : \(curr.coordinate.latitude)")
        lat = curr.coordinate.latitude
        print("longitude : \(curr.coordinate.longitude)")
        long = curr.coordinate.longitude
        
    }
    
    
    @IBAction func HeartRateBtn(_ sender: Any) {
        
    }
    
    
    
    @IBAction func runBtn(_ sender: Any) {
        
        IsTestOn = true
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
            print("get lat and long")
        }

        
        let Email = UserDefaults.standard.value(forKey: "UserEmail")!
        let request = NSMutableURLRequest(url : NSURL(string: "http://120.126.145.118/PM/get_pm_info.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "user=\(Email)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler :{
            (data , response , error) -> Void in
            
            if error != nil{
                print("error=\(String(describing: error))")
            }
            print("response =\(String(describing: response))")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("\(String(describing: responseString))")
            DispatchQueue.main.async(){
            var text = String(describing: responseString)
            text = text.replacingOccurrences(of: "Optional(", with: "")
            text = text.replacingOccurrences(of: ")", with: "")
            text.characters.removeLast()
            
            var min = 1000000000000.0
            var pm_value = 0
            let textArry = text.components(separatedBy: ":")
            textArry.forEach { word in
                // long
                let lat_ = word.components(separatedBy: "-")[0]
                // lat
                let long_ = word.components(separatedBy: "-")[1]
                // pm
                let pm_ = word.components(separatedBy: "-")[2]
                
                let myLocation = CLLocationCoordinate2DMake(CLLocationDegrees(self.lat), CLLocationDegrees(self.long))
                let posLocation = CLLocationCoordinate2DMake(CLLocationDegrees(Float(lat_)!), CLLocationDegrees(Float(long_)!))
                let d = self.MS_Distance(pointA: myLocation , pointB: posLocation)
                if(d < min){
                    pm_value = Int(pm_)!
                    min = d
                }
               
            }
            self.SetupAll(pm_value: pm_value)
            }
        })
        task.resume()
        
        let Alert: UIAlertController = UIAlertController(title: "檢測", message: "檢測完成" , preferredStyle: .alert)
        let action = UIAlertAction(title: "了解", style: UIAlertActionStyle.default,handler: nil)
        Alert.addAction(action)
        self.present(Alert , animated: true, completion: nil)
    }
    
    func MS_Distance(pointA : CLLocationCoordinate2D , pointB : CLLocationCoordinate2D) -> Double{
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

    
    func SetupAll(pm_value : Int){
        pm = pm_value
        var dir = 0
        if(pm_value <= 11){
            dir = 1
        }else if(pm_value <= 23){
            dir = 2
        }else if(pm_value <= 35){
            dir = 3
        }else if(pm_value <= 41){
            dir = 4
        }else if(pm_value <= 47){
            dir = 5
        }else if(pm_value <= 53){
            dir = 6
        }else if(pm_value <= 58){
            dir = 7
        }else if(pm_value <= 64){
            dir = 8
        }else if(pm_value <= 70){
            dir = 9
        }else{
            dir = 10
        }
        arrowState(select : dir)
        labelappear(select: dir)
        valueLabel.text = "\(pm_value)"
    }
    
    //Label
    func labelappear(select : Int){
        
        var normaltext = ""
        var specialtext = ""
        var singaltext = ""
        
        if(select == 1 || select == 2 || select == 3){
            normaltext = "正常戶外活動。"
            specialtext = "正常戶外活動。"
            singaltext = "低"
            FaceImage.image = #imageLiteral(resourceName: "Face_perfect")
        }else if(select == 4 || select == 5 || select == 6){
            normaltext = "正常戶外活動。"
            specialtext = "有心臟、呼吸道及心血管疾病的成人與孩童感受到癥狀時，應考慮減少體力消耗，特別是減少戶外活動。"
            singaltext = "中"
            FaceImage.image = #imageLiteral(resourceName: "Face_nice")
        }else if(select == 7 || select == 8 || select == 9){
            normaltext = "任何人如果有不適，如眼痛，咳嗽或喉嚨痛等，應該考慮減少戶外活動。"
            specialtext = "1. 有心臟、呼吸道及心血管疾病的成人與孩童，應減少體力消耗，特別是減少戶外活動。 2. 老年人應減少體力消耗。 3. 具有氣喘的人可能需增加使用吸入劑的頻率。"
            singaltext = "高"
            FaceImage.image = #imageLiteral(resourceName: "Face_bad")
        }else{
            normaltext = "任何人如果有不適，如眼痛，咳嗽或喉嚨痛等，應減少體力消耗，特別是減少戶外活動。"
            specialtext = "1. 有心臟、呼吸道及心血管疾病的成人與孩童，以及老年人應避免體力消耗，特別是避免戶外活動。2. 具有氣喘的人可能需增加使用吸入劑的頻率。"
            singaltext = "非常高"
            FaceImage.image = #imageLiteral(resourceName: "Face_Fatal")
        }
        normalTitle.alpha = 1
        specialTitle.alpha = 1
        nomralLabel.text = normaltext
        specailLabel.text = specialtext
        singalLabel.text = singaltext
        nomralLabel.sizeToFit()
        specailLabel.sizeToFit()
    }
    
    // appear arrow
    func arrowState(select : Int){
        // 1
        if(select == 1 && arrow1.alpha==0){
            iamgeAppear(arrow: arrow1)
        }else if(select != 1 && arrow1.alpha==1){
            iamgedisapper(arrow: arrow1)
        }
        //2
        if(select == 2 && arrow2.alpha==0){
            iamgeAppear(arrow: arrow2)
        }else if(select != 2 && arrow2.alpha==1){
            iamgedisapper(arrow: arrow2)
        }
        //3
        if(select == 3 && arrow3.alpha==0){
            iamgeAppear(arrow: arrow3)
        }else if(select != 3 && arrow3.alpha==1){
            iamgedisapper(arrow: arrow3)
        }
        //4
        if(select == 4 && arrow4.alpha==0){
            iamgeAppear(arrow: arrow4)
        }else if(select != 4 && arrow4.alpha==1){
            iamgedisapper(arrow: arrow4)
        }
        //5
        if(select == 5 && arrow5.alpha==0){
            iamgeAppear(arrow: arrow5)
        }else if(select != 5 && arrow5.alpha==1){
            iamgedisapper(arrow: arrow5)
        }
        //6
        if(select == 6 && arrow6.alpha==0){
            iamgeAppear(arrow: arrow6)
        }else if(select != 6 && arrow6.alpha==1){
            iamgedisapper(arrow: arrow6)
        }
        //7
        if(select == 7 && arrow7.alpha==0){
            iamgeAppear(arrow: arrow7)
        }else if(select != 7 && arrow7.alpha==1){
            iamgedisapper(arrow: arrow7)
        }
        //8
        if(select == 8 && arrow8.alpha==0){
            iamgeAppear(arrow: arrow8)
        }else if(select != 8 && arrow8.alpha==1){
            iamgedisapper(arrow: arrow8)
        }
        //9
        if(select == 9 && arrow9.alpha==0){
            iamgeAppear(arrow: arrow9)
        }else if(select != 9 && arrow9.alpha==1){
            iamgedisapper(arrow: arrow9)
        }
        //10
        if(select == 10 && arrow10.alpha==0){
            iamgeAppear(arrow: arrow10)
        }else if(select != 10 && arrow10.alpha==1){
            iamgedisapper(arrow: arrow10)
        }

    }
    
    func iamgeAppear(arrow : UIImageView){
        UIView.animate(withDuration: 0.5, animations: {arrow.alpha = 1},completion : nil)
    }
    
    func iamgedisapper(arrow : UIImageView){
        UIView.animate(withDuration: 0.5, animations: {arrow.alpha = 0},completion : nil)
    }
    
    @IBAction func recordBtn(_ sender: Any) {
        if (IsTestOn) {
            
            let userEmail = UserDefaults.standard.value(forKey: "UserEmail")!
            
            
            let request = NSMutableURLRequest(url : NSURL(string: "http://120.126.145.118/PM/onhalation_record.php")! as URL)
            request.httpMethod = "POST"
            
            //let postString = "IOS_user=\(Email!)&IOS_userpw=\(Password!)"
            let postString = "Email=\(userEmail)&lat=\(lat)&long=\(long)&pm=\(pm)&inhalation=\(inhalation)"
            
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
    
    
    @IBAction func personality(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
