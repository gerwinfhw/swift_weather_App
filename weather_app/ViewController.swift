//
//  ViewController.swift
//  weather_app
//
//  Created by Gerwin on 09.02.21.
//  Copyright © 2021 Gerwin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var location_label: UILabel!
    @IBOutlet weak var weekday_label: UILabel!
    @IBOutlet weak var temperatur_label: UILabel!
    @IBOutlet weak var background_color_view: UIView!
    
    let gradientLayer = CAGradientLayer()
    
    var lat: Double?
    var long: Double?
    
    var location: String?
    let weather_api_key = "4f3dbea5a7866dfe39ee7d6a158d49fb"
    
    var activityIndicator: NVActivityIndicatorView! //Loading dialog view
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        change the background to a gradient background
        background_color_view.layer.insertSublayer(gradientLayer, at: 0)
        
//        Setup the loading indicator
        let indicatorSize: CGFloat = 140
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .ballPulse, color: UIColor.white, padding: 20)
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        activityIndicator.startAnimating()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self 
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGreyBackground()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        
//    "http://api.openweathermap.org/data/2.5/weather?q=hamburg&units=metric&appid=4f3dbea5a7866dfe39ee7d6a158d49fb"
//        "api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(self.weather_api_key)"
//        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=metric&appid=\(self.weather_api_key)").responseJSON {
//            response in
//
//            if let responseStr = response.result.value {
//                self.activityIndicator.stopAnimating()
//                let jsonResponse = JSON(responseStr)
//                //let jsonWeather = jsonResponse["Weather"].array![0]
//                let jsonTemp = jsonResponse["main"]
//
//                // self.location_label.text = jsonResponse["name"].stringValue
//                self.location_label.text = self.location
//                self.temperatur_label.text  = "\(Int(round(jsonTemp["temp"].doubleValue)))"
//                self.weekday_label.text = self.getWeekdayFromDate()
//            }
//        }
        manager.stopUpdatingLocation()
        
        self.location_label.text = self.location
    }
    
    //TODO gradient color does not function
    func setGreyBackground() {
        let colorTop = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 1.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 72.0 / 255.0, green: 72.0 / 255.0, blue: 72 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
    }
    
    func setBlueBackground(){
        let colorTop = UIColor(red: 95.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
    }
    
    func getWeekdayFromDate()->String? {
        let weekDay = Calendar.current.component(.weekday, from: Date())
        switch weekDay {
        case 1:
            return "Sonntag"
        case 2:
            return "Montag"
        case 3:
            return "Dienstag"
        case 4:
            return "Mittwoch"
        case 5:
            return "Donnerstag"
        case 6:
            return "Freitag"
        case 7:
            return "Samstag"
        default:
            print("Error fetching days")
            return "Day"
        }
        
    }
    
    
}

