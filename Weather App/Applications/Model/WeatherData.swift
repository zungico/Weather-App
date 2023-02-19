//
//  WeatherData.swift
//  Weather App
//
//  Created by Вова on 17.02.2023.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}


struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id : Int
}
