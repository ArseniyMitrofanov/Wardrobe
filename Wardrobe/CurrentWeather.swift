//
//  CurrentWeather.swift
//  Wardrobe
//
//  Created by Арсений on 26.11.22.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let latitude, longitude: Double
    let generationtimeMS: Double
    let utcOffsetSeconds: Double
    let timezone, timezoneAbbreviation: String
    let elevation: Double
    let hourlyUnits: HourlyUnits
    let hourly: Hourly

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case hourlyUnits = "hourly_units"
        case hourly
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let time: [String]
    let temperature2M, windspeed10M: [Double]
    let rain: [Double]
    let snowfall: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case windspeed10M = "windspeed_10m"
        case rain, snowfall
    }
}

// MARK: - HourlyUnits
struct HourlyUnits: Codable {
    let time, temperature2M, windspeed10M, rain: String
    let snowfall: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case windspeed10M = "windspeed_10m"
        case rain, snowfall
    }
}
