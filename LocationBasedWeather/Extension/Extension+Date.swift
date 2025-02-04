//
//  Extension+Date.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/4/25.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 a HH시mm분"
        return formatter.string(from: self)
    }
}
