//
//  DetailViewController.swift
//  weather_app
//
//  Created by Gerwin on 05.03.21.
//  Copyright © 2021 Gerwin. All rights reserved.
//

import UIKit
import SwiftyJSON
import TimeZoneLocate
import MapKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet var backgroundView: UIView!
    
    var weatherWrapper: WeatherWrapper = WeatherWrapper(weather: Weather())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = weatherWrapper.city
        temperatureLabel.text = weatherWrapper.temp
        feelsLikeLabel.text = weatherWrapper.feels_like
        descriptionLabel.text = weatherWrapper.description
        maxTempLabel.text = weatherWrapper.temp_max
        minTempLabel.text = weatherWrapper.temp_min
        pressureLabel.text = weatherWrapper.pressure
        humidityLabel.text = weatherWrapper.humidity
        sunriseLabel.text = weatherWrapper.sunriseFormatted
        sunsetLabel.text = weatherWrapper.sunsetFormatted
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeBackgroundToGradients()
        
        super.viewWillAppear(animated)
    }
    
    func changeBackgroundToGradients() {
        
        if weatherWrapper.lat != nil && weatherWrapper.lon != nil {
            let location = CLLocation(latitude: weatherWrapper.lat!, longitude: weatherWrapper.lon!)
            location.timeZone { (tz) -> (Void) in
                guard let tz = tz else { return }
                
                let timezone = TimeZone.init(identifier: tz.identifier)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.timeZone = timezone
                let currentTimeAtLocation = Helper.convertTimeToArray(time: dateFormatter.string(from: Date()))
                
                /// checks is day or night at the location
                let isDay = Helper.isDay(localTime: currentTimeAtLocation, sunrise: self.weatherWrapper.sunriseArray, sunset: self.weatherWrapper.sunsetArray)
                
                /// sets gradient background based on the current time at the location
                let gradientLayer = Helper.buildGradientLayer(isDay: isDay, frame: self.view.bounds)
                
                self.backgroundView.layer.insertSublayer(gradientLayer, at:0)
            }
        }
    }
}
