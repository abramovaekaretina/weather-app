//
//  APIManager.swift
//  weather
//
//  Created by Ekaterina Abramova on 01.01.2021.
//

import Foundation

class APIManager {

    func fetchForecast(url urlString: String, completion: @escaping (Result<ForecastDaily?, Error>) -> ()) {
        if let url = URL(string: urlString) {
            fetchData(url: url, completion: completion)
        }
    }

    func fetchData<T: Codable>(url: URL, completion: @escaping (Result<T?, Error>) -> ()) {
        let urlRequest = URLRequest(url: url)
        URLSession.shared.configuration.urlCache = nil
        let config = URLSessionConfiguration.default
        URLSession(configuration: config).dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                if let forecastResponse = try? JSONDecoder().decode(ForecastDaily.self, from: data) {
                    completion(.success(forecastResponse as? T))
                } else {
                    completion(.success(nil))
                }
            }
        }.resume()
    }
}
