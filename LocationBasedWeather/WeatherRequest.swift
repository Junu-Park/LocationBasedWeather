//
//  WeatherRequest.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/4/25.
//

import Foundation

struct WeatherRequest: Encodable {
    var lat: Double
    var lon: Double
    let appid: String = APIKey.openWeather
}
