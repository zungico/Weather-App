//
//  WeatherManager.swift
//  Weather App
//
//  Created by Вова on 17.02.2023.
//

import UIKit
import CoreLocation

struct WeatherManager {
    
    var delegate : WeatherManagerDelegate?
    
    let urlBlank = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=41cb748ffd77759d1262dc0fadd90a48"
    
    func fetchURL (city: String) {
        let urlString = urlBlank + "&q=\(city)"
        performRequest(with: urlString)
    }
    
    func fetchURL (lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = urlBlank + "&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString: String) {
        //1. Create a URL
        if  let url = URL(string: urlString) {
            //2. Create a URLSession from url
            let session = URLSession(configuration: .default)
            //3. Create task for session
            let task = session.dataTask(with: url) { data, responce, error in
                if error != nil {
                    self.delegate?.didFailWithError (error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Start task
            task.resume()
        }
    }
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            
            return WeatherModel(conditionID: id, cityName: city, temperature: temp)
        } catch {
            delegate?.didFailWithError (error)
            return nil
        }
    }
}

//MARK: - WeatherManagerDelegate

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(_ error: Error)
}
