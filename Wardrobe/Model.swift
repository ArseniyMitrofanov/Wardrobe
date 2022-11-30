//
//  Model.swift
//  Wardrobe
//
//  Created by Арсений on 26.11.22.
//

import Foundation
import CoreLocation


class Model: NSObject,  CLLocationManagerDelegate  {
    weak var viewController: ViewController?
    var weather: Weather?
    let locationManager = CLLocationManager()
    var location = CLLocationCoordinate2D(latitude: 53.9, longitude: 27.5)
    func getLocation() {
        
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled(){
            if locationManager.authorizationStatus == .authorizedAlways {
                locationManager.startUpdatingLocation()
            } else {
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
            }
        }
    }
    
    func loadWeather() {
        
        print(location)
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude="+String(location.latitude)+"&longitude="+String(location.longitude)+"&hourly=temperature_2m,windspeed_10m,rain,snowfall"
        print(urlString)
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data = data else { return }
            let  localWeather: Weather?
            
            do {
                 localWeather = try JSONDecoder().decode(Weather.self, from: data)
               
            } catch {
                localWeather = nil
                print(error)
            }
            
            DispatchQueue.main.async {
                self?.weather = localWeather
                
            }
     
        }
        .resume()
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
        self.location = locValue
        locationManager.stopUpdatingLocation()
        loadWeather()
    }
    
    
}
