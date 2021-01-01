//
//  ForecastDaily.swift
//  weather
//
//  Created by Ekaterina Abramova on 12.12.2020.
//

import Foundation

class ForecastDaily: Codable {
    let data: [Day]
    let city: String
    enum CodingKeys: String, CodingKey {
        case data
        case city = "city_name"
    }
}

class Day: Codable {
    let date: String
    let temperature: Double
    let weather: Weather
    enum CodingKeys: String, CodingKey {
        case date = "datetime"
        case temperature = "temp"
        case weather
    }
}

class Weather: Codable {
    let icon: String
    let description: String
}
