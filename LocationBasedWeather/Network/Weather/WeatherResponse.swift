//
//  WeatherResponse.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/4/25.
//

import Foundation

struct WeatherResponse: Decodable {
    let main: Main
    let wind: Wind
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
}

struct Wind: Decodable {
    let speed: Double
}
