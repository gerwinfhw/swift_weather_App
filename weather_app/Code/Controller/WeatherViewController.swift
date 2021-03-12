//
//  WeatherViewController.swift
//  weather_app
//
//  Created by Gerwin on 06.03.21.
//  Copyright © 2021 Gerwin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import TimeZoneLocate
import MapKit

class WeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    // initialize default cities
    var weatherList = [
        Weather(city: "Hamburg"),
        Weather(city: "Oakland"),
        Weather(city: "München"),
        Weather(city: "Lissabon"),
        Weather(city: "Texas")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wetterübersicht"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.separatorStyle = .none
        weatherTableView.showsVerticalScrollIndicator = false
        /// Create a footer view for the table view and adds an button to add more cities
        weatherTableView.tableFooterView = createTableViewFooterView()
    }
    
    /// if button is clickt activate or deactivate the editing mode for the table view
    @IBAction func handleEditButton() {
        if weatherTableView.isEditing {
            weatherTableView.isEditing = false
        } else {
            weatherTableView.isEditing = true
        }
    }
    
    func createTableViewFooterView() -> UIView {
        let tableViewFooterView = UIView()
        tableViewFooterView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        let addButton = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        addButton.setTitle("+", for: .normal)
        addButton.backgroundColor = .black
        addButton.layer.cornerRadius = 15.0
        addButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        addButton.titleLabel?.textAlignment = .center
        
        tableViewFooterView.addSubview(addButton)
        
        return tableViewFooterView
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.ask(title: "Neue Stadt hinzufügen", question: "", placeholder: "Hier hinzufügen") { (input) in
            if let city = input {
                /// tries to request the city and if successful adds it
                self.addCityWeatherForcastValid(of: city)
            }
        }
    }
    
    func addCityWeatherForcastValid(of city:String) {
        let url = Helper.buildURL(for: city)
        Alamofire.request(url).responseJSON {
            response in
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let cod = jsonResponse["cod"].intValue
                
                if cod == 200 { /// successful request
                    for element in self.weatherList { /// check sif city already exists
                        if element.city == city {
                            let alert = UIAlertController(title: "Ungültige Eingabe", message: "\(city) existiert bereits", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                    let weather: Weather = Weather(city: city)
                    self.weatherList.append(weather)
                    
                    self.weatherTableView.beginUpdates()
                    let indexPath = IndexPath(row: self.weatherList.count-1, section: 0)
                    self.weatherTableView.insertRows(at: [indexPath], with: .automatic)
                    self.weatherTableView.endUpdates()
                } else {
                    let alert = UIAlertController(title: "Ungültige Eingabe", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        /// updates gradients when orientation changed
        for cell in weatherTableView.visibleCells {
            for sublayer in cell.layer.sublayers ?? [] where sublayer.name == "gradient"  {
                sublayer.bounds = cell.bounds
            }
        }
        
        weatherTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
        let city = weatherList[indexPath.row].city!
        let url = Helper.buildURL(for: city)
        /// sends a request with an url
        Alamofire.request(url).responseJSON {
            response in
            
            if let responseStr = response.result.value {
                /// convert the response to an JSON object
                let jsonResponse = JSON(responseStr)
                
                /// update data with json info
                self.weatherList[indexPath.row].updateWith(json: jsonResponse)
                
                let weatherWrapper = WeatherWrapper(weather: self.weatherList[indexPath.row])
                
                if weatherWrapper.lat != nil && weatherWrapper.lon != nil {
                    let location = CLLocation(latitude: weatherWrapper.lat!, longitude: weatherWrapper.lon!)
                    
                    /// get the time zone of a city and calculate the current time
                    location.timeZone { (tz) -> (Void) in
                        guard let tz = tz else { return }
                        
                        let timezone = TimeZone.init(identifier: tz.identifier)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        dateFormatter.timeZone = timezone
                        let currentTimeAtLocation = Helper.convertTimeToArray(time: dateFormatter.string(from: Date()))
                        
                        /// checks is day or night at the location
                        let isDay = Helper.isDay(localTime: currentTimeAtLocation, sunrise: weatherWrapper.sunriseArray, sunset: weatherWrapper.sunsetArray)
                        
                        /// set gradient background based on the current time at the location
                        let gradientLayer = Helper.buildGradientLayer(isDay: isDay, frame: cell.weatherCell.bounds)
                        gradientLayer.name = "gradient"
                        
                        cell.layer.insertSublayer(gradientLayer, at:1)
                    }
                }
                
                cell.cityLabel.text = weatherWrapper.city
                cell.tempLabel.text = weatherWrapper.temp
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// opens new view with detailed information about the weather
        performSegue(withIdentifier: "segue", sender: self)
        
        weatherTableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// if segue is triggered, transfrom the nessesary information to the new view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = weatherTableView.indexPathForSelectedRow else { return }
        if let target = segue.destination as? WeatherDetailViewController {
            target.weatherWrapper = WeatherWrapper(weather: weatherList[selectedPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherList.remove(at: indexPath.row)
            weatherTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        weatherList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    /// custom pop up window with text field
    func ask(title: String?, question: String?, placeholder: String?, keyboardType: UIKeyboardType = .default, delegate: @escaping (_ answer: String?) -> Void) {
        let alert = UIAlertController(title: title, message: question, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.keyboardType = keyboardType
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            let answer = alert.textFields?.first?.text
            delegate(answer)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            delegate(nil)
        })
        present(alert, animated: true, completion: nil)
    }
}

