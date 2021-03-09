//
//  WeatherWrapper.swift
//  weather_app
//
//  Created by Gerwin on 08.03.21.
//  Copyright © 2021 Gerwin. All rights reserved.
//

import Foundation

/**
 Handles the optional values of the Weather class
 */
class WeatherWrapper {
    
    private var weather: Weather?
    
    init(weather:Weather) {
        self.weather = weather
    }
    
    var city: String {
        let city = weather?.city ?? "-"
        return city
    }
    var temp: String {
        if let temperature = weather?.temp {
            return "\(Int(round(temperature)))℃"
        }
        return "-"
    }
    
    var feels_like:String {
        if let feels_like = weather?.feels_like {
            return " Gefühlt wie \(Int(round(feels_like)))℃"
        }
        return "-"
    }
    
    var temp_max:String {
        if let temp_max = weather?.temp_max {
            return "\(Int(round(temp_max)))℃"
        }
        return "-"
        
    }
    var temp_min:String {
        if let temp_min = weather?.temp_min {
            return "\(Int(round(temp_min)))℃"
        }
        return "-"
    }
    var pressure:String {
        if let pressure = weather?.pressure {
            return "\(pressure) hPa"
        }
        return "-"
    }
    var humidity:String {
        if let humidity = weather?.humidity {
            return "\(humidity) %"
        }
        return "-"
    }
    var description:String {
        let description = weather?.description ?? "-"
        return description
    }
    
    var sunriseArray:[Int] {
          if let sunrise = weather?.sunrise {
              return Helper.convertToNormalTimeAsArray(from: sunrise)
          }
          return []
      }
    
      var sunsetArray:[Int] {
          if let sunset = weather?.sunset {
              return Helper.convertToNormalTimeAsArray(from: sunset)
          }
          return []
      }
    
    var sunriseFormatted:String {
        if let sunrise = weather?.sunrise {
            let sunriseFormatted = Helper.convertToNormalTimeToString(from: sunrise)
            return "\(sunriseFormatted) Uhr"
        }
        return "-"
    }
    var sunsetFormatted:String {
        if let sunset = weather?.sunset {
            let sunsetFormatted = Helper.convertToNormalTimeToString(from: sunset)
            return "\(sunsetFormatted) Uhr"
        }
        return "-"
    }
    
    var lat:Double? {
        if let lat = weather?.lat {
            return lat
        }
        return nil
    }
    
    var lon:Double? {
           if let lon = weather?.lon {
               return lon
           }
           return nil
       }
    
}
