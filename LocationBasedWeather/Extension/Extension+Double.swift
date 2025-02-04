//
//  Extension+Double.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/4/25.
//

import Foundation

extension Double {
    func convertToCelsius() -> Double {
        let cel = self - 273.15
        return roundl(cel)
    }
}
