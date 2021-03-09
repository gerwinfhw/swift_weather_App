//
//  WeatherTableTableViewController.swift
//  weather_app
//
//  Created by Gerwin on 05.03.21.
//  Copyright © 2021 Gerwin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class WeatherTableViewController: UITableViewController {
    
    struct Weather {
        var city: String
        var temperature: String?
        var coordinate: (Double, Double)?
    }
    
    var data = [Weather]()
    let weather_api_key = "4f3dbea5a7866dfe39ee7d6a158d49fb"
    var index = -1
    var jsonData: [String:JSON] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        data = [
            Weather(city: "Hamburg"),
            Weather(city: "Berlin"),
            Weather(city: "Bremen"),
            Weather(city: "Medan"),
            Weather(city: "Budapest"),
            Weather(city: "Texas")
        ]
        
//        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "customCell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?q=\(data[indexPath.row].city)&units=metric&lang=de&appid=\(self.weather_api_key)").responseJSON {
            response in
            
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                
                self.jsonData[self.data[indexPath.row].city] = jsonResponse
                
                let jsonMain = jsonResponse["main"]
                let jsonCoord = jsonResponse["coord"]
                
                let temperature  = "\(Int(round(jsonMain["temp"].doubleValue)))"
                let lon = jsonCoord["lon"].doubleValue
                let lat = jsonCoord["lat"].doubleValue
                
                
                self.data[indexPath.row].temperature = temperature
                self.data[indexPath.row].coordinate = (lon, lat)
                
                //                cell.cityLabel.text = self.data[indexPath.row].city
                //                cell.tempLabel.text = self.data[indexPath.row].temperature!
                
                cell.textLabel?.text = "Stadt: \(self.data[indexPath.row].city) Temperatur: \(self.data[indexPath.row].temperature!)"
                
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        if let target = segue.destination as? DetailViewController {
            let city = data[selectedPath.row].city
            target.location = city
            target.jsonData = jsonData["\(city)"]
        }
    }
    
    
}
