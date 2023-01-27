//
//  LocationWeatherService.swift
//  Wardrobe
//
//  Created by Арсений on 27.01.23.
//

import Foundation
import CoreLocation

protocol LocationWeatherServiceDelegate: AnyObject {
    func didFetchWeather(hoursWeather: [HourWeather])
    func didFailToFetchWeather(with error: Error)
}

class LocationWeatherService: NSObject,  CLLocationManagerDelegate  {
    weak var delegate: LocationWeatherServiceDelegate?
    var weather: Weather?
    var location = CLLocationCoordinate2D(latitude: 53.9, longitude: 27.5)
    let locationManager = CLLocationManager()
    var weatherCache: Weather?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getLocation(){
        
        DispatchQueue.global().async {
            [weak self] in
            
            if CLLocationManager.locationServicesEnabled(){
                if self?.locationManager.authorizationStatus == .authorizedAlways {
                    self?.locationManager.startUpdatingLocation()
                } else {
                    self?.locationManager.requestWhenInUseAuthorization()
                    self?.locationManager.requestAlwaysAuthorization()
                }
            }
        }
    }
    
    func loadWeather() {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude="+String(location.latitude)+"&longitude="+String(location.longitude)+"&hourly=temperature_2m,windspeed_10m,rain,snowfall,cloudcover,precipitation"
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data = data else {
                if let error = error {
                    self?.delegate?.didFailToFetchWeather(with: error)
                }
                return
            }
            let  localWeather: Weather?
            let decodingError: Error?
            do {
                localWeather = try JSONDecoder().decode(Weather.self, from: data)
                decodingError = nil
            } catch {
                localWeather = nil
                decodingError = error
            }
            
            DispatchQueue.main.async {
                
                if let weather = localWeather {
                    if self?.weatherCache == nil{
                        self?.weatherCache = weather
                        let hoursWeather = self?.divideWeatherByHours(weather: weather)
                        if let hoursWeather = hoursWeather{
                            self?.delegate?.didFetchWeather(hoursWeather: hoursWeather)
                        }
                    }
                } else if let decodingError = decodingError {
                    self?.delegate?.didFailToFetchWeather(with: decodingError)
                }
            }
            
        }
        .resume()
    }
    
    func divideWeatherByHours(weather: Weather) -> [HourWeather]{
        var hoursWeather: [HourWeather] = []
        for index in 0...weather.hourly.time.count-1{
            let hourWeather = HourWeather(time: weather.hourly.time[index],
                                          temperature2M: weather.hourly.temperature2M[index],
                                          snowfall: weather.hourly.snowfall[index],
                                          cloudcover: weather.hourly.cloudcover[index],
                                          precipitation: weather.hourly.precipitation[index],
                                          windspeed10M: weather.hourly.windspeed10M[index],
                                          rain: weather.hourly.rain[index])
            hoursWeather.append(hourWeather)
        }
        return hoursWeather
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationManager.stopUpdatingLocation()
        self.location = locValue
        loadWeather()
    }
    
}
