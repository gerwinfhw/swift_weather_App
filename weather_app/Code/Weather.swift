//
//  Weather.swift
//  weather_app
//
//  Created by Gerwin on 08.03.21.
//  Copyright © 2021 Gerwin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Weather {
    var city: String?
    
    var temp:Double?
    var feels_like:Double?
    var temp_max:Double?
    var temp_min:Double?
    var pressure:Int?
    var humidity:Int?
    var description:String?
    var sunrise:Double?
    var sunset:Double?
    
    var lon:Double?
    var lat:Double?
    
    init() {}
    
    init(city:String) {
        self.city = city
    }
    
    func updateWith(json:JSON) {
        let jsonMain = json["main"]
        let jsonWeather = json["weather"][0]
        let jsonSys = json["sys"]
        let jsonCoord = json["coord"]
        
        self.temp = jsonMain["temp"].doubleValue
        self.feels_like = jsonMain["feels_like"].doubleValue
        self.temp_max = jsonMain["temp_max"].doubleValue
        self.temp_min = jsonMain["temp_min"].doubleValue
        self.pressure = jsonMain["pressure"].intValue
        self.humidity = jsonMain["humidity"].intValue
        self.description = jsonWeather["description"].stringValue
        self.sunrise = jsonSys["sunrise"].doubleValue
        self.sunset = jsonSys["sunset"].doubleValue
        
        self.lon = jsonCoord["lon"].doubleValue
        self.lat = jsonCoord["lat"].doubleValue
    }
    
}
