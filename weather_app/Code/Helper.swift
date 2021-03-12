//
//  Helper.swift
//  weather_app
//
//  Created by Gerwin on 08.03.21.
//  Copyright © 2021 Gerwin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Helper {
    /// api key for the open weather weather forecast
    static let weather_api_key = "4f3dbea5a7866dfe39ee7d6a158d49fb"
    
    static func isDay(localTime:[Int], sunrise:[Int], sunset:[Int]) -> Bool {
        
        // normal case: local time is higher than sunrise and lower than sunset
        if ((localTime[0] > sunrise[0] || localTime[0] == sunrise[0] && localTime[1] >= sunrise[1])
                && localTime[0] < sunset[0] || localTime[0] == sunset[0] && localTime[1] <= sunset[1]) {
            return true
        }
        
        if (sunset[0] < sunrise[0]) {
            if (localTime[0] < 23 || localTime[0] < sunset[0] || localTime[0] == sunset[0] && localTime[1] <= sunset[1]) {
                return true
            }
        }
        return false
    }
    
    static func buildGradientLayer(isDay:Bool, frame:CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        if isDay {
            gradientLayer.colors = getGradientLayerColorsDay()
        } else {
            gradientLayer.colors = getGradientLayerColorsNight()
        }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = frame
        
        return gradientLayer
    }
    
    static func getGradientLayerColorsDay() -> [CGColor] {
        let colorTop =  UIColor(red: 148.0/255.0, green: 187.0/255.0, blue: 233.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 161.0/255.0, green: 238.0/255.0, blue: 252.0/255.0, alpha: 1.0).cgColor
        
        return [colorTop, colorBottom]
    }
    
    static func getGradientLayerColorsNight() -> [CGColor] {
        let colorTop =  UIColor(red: 90.0/255.0, green: 88.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 43.0/255.0, green: 60.0/255.0, blue: 79.0/255.0, alpha: 1.0).cgColor
        
        return [colorTop, colorBottom]
    }
    
    static func buildURL(for city:String, units:String = "metric", lang:String = "de") -> String {
        var formatString = city.replacingOccurrences(of: "ä", with: "ae")
        formatString = formatString.replacingOccurrences(of: "ö", with: "oe")
        formatString = formatString.replacingOccurrences(of: "ü", with: "ue")
        formatString = formatString.replacingOccurrences(of: " ", with: "%20")
        
        let api = "https://api.openweathermap.org"
        let endpoint = "/data/2.5/weather?q=\(formatString)&units=\(units)&lang=\(lang)&appid=\(Helper.weather_api_key)"
        
        return api + endpoint
    }
    
    static func convertToNormalTimeToString(from unixTimeStamp: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    static func convertToNormalTimeAsArray(from unixTimeStamp: Double) -> [Int] {
        let strDate = convertToNormalTimeToString(from: unixTimeStamp)
        return convertTimeToArray(time: strDate)
    }
    
    /// seperates hour and minute from a specific time format "MM:mm" to an array
    static func convertTimeToArray(time:String) -> [Int] {
        time.split { $0 == ":" } .map { (x) -> Int in return Int(String(x))! }
    }
    
}

