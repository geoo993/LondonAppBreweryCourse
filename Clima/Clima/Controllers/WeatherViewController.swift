//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "2f935ffd0c4dccdb0c303b592d3067ff"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let this = self else { return }
        
            if response.result.isSuccess {
                print("Success, Got the weather data")
                if let json = response.result.value {
                    let weatherJSON : JSON = JSON(json)
                    this.updateWeatherData(json: weatherJSON)
                    print("JSON: \(weatherJSON)") 
                }
                
            }else {
                if let error = response.result.error {
                    print("Error", error)
                    this.cityLabel.text = "Network request failed"
                }
            }
            
        }
        
    }

    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON) {
        if 
            let temperatureResult = json["main"]["temp"].double,
            let firstWeatherCondition = json["weather"].array?.first {
            
            let temperature = Int(temperatureResult - 273.15) // conerting from kelvins temperature in celsius
            let condition = firstWeatherCondition["id"].intValue 
            let city = json["name"].stringValue 
            let weatherDataModel = WeatherDataModel(temperature: temperature, 
                                                    condition: condition, 
                                                    city: city)
            updateUIWithWeatherData(weatherModel: weatherDataModel)
        }else {
            cityLabel.text = "Weather data unavailable"
        }
        
    }

    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData(weatherModel : WeatherDataModel) {
        cityLabel.text = weatherModel.city
        temperatureLabel.text = "\(weatherModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherModel.weatherIconName)
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
       
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let locAltitude = String(location.coordinate.latitude)
            let locLongitute = String(location.coordinate.longitude)
            let params : [String : String] = ["lat":locAltitude.description, 
                                              "lon": locLongitute.description, 
                                              "appid": APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location unavailable"
    }
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(cityName: String) {
        print(cityName)
        let params : [String : String] = ["q":cityName,  
                                          "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            guard let destinationVC = segue.destination as? ChangeCityViewController else { return }
            destinationVC.delegate = self
        }
    }
    
}


