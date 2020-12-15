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
//    let lon: String
//    let lat: String
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

//{
//    "data":[{
//        "valid_date":"2020-12-09"
//        "weather":{
//            "icon":"c04d",
//            "code":804,
//            "description":"Overcast clouds"
//        },
//        "datetime":"2020-12-09",
//        "temp":3.7
//
//    },..],
//    "city_name":"Brussels",
//    "lon":"4.34878",
//    "lat":"50.85045"
//}
