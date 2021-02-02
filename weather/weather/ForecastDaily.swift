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
    let minTemperature: Double
    let maxTemperature: Double
    let sunrise: Double
    let sunset: Double
    let weather: Weather
    let precipitation: Double
    let pressure: Double
    enum CodingKeys: String, CodingKey {
        case date = "datetime"
        case temperature = "temp"
        case weather
        case minTemperature = "min_temp"
        case maxTemperature = "max_temp"
        case sunrise = "sunrise_ts"
        case sunset = "sunset_ts"
        case precipitation = "precip"
        case pressure = "pres"
    }
}

class Weather: Codable {
    let icon: String
    let description: String
}
