//
//  CurrentWeather.swift
//  Wardrobe
//
//  Created by Арсений on 26.11.22.
//

import Foundation

struct Weather: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
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
    let temperature2M, windspeed10M, rain: [Double]
    let snowfall, cloudcover: [Double]
    let precipitation: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case windspeed10M = "windspeed_10m"
        case rain, snowfall, cloudcover, precipitation
    }
}

// MARK: - HourlyUnits
struct HourlyUnits: Codable {
    let time, temperature2M, windspeed10M, rain: String
    let snowfall, cloudcover, precipitation: String
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case windspeed10M = "windspeed_10m"
        case rain, snowfall, cloudcover, precipitation
    }
}

struct HourWeather: Hashable {
    let time: String
    let temperature2M,
        snowfall,
        cloudcover,
        precipitation,
        windspeed10M,
        rain: Double
}
