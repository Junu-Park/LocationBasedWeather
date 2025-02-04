//
//  NetworkManager.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/3/25.
//

import Foundation

import Alamofire

final class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()
    
    static let baseURLString: String = "https://api.openweathermap.org/data/2.5/weather"
    
    private init() { }
    
    func requestWeatherData<T:Decodable>(params: WeatherRequest? ,completionHandler: @escaping (Result<T, AFError>) -> ()) {
        AF.request(NetworkManager.baseURLString, method: .get, parameters: params?.convertToDictionary, encoding: URLEncoding(destination: .queryString)).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
