//
//  GetWeatherFromApiUseCase.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 20/9/24.
//

import Foundation

class GetWeatherFromApiUseCase{
    var api : WeatherApiNetwork = WeatherApiNetwork()
    
    func getWeatherFromApi () async throws ->[WeatherModel]{
        let wrapper = try await WeatherApiNetwork().getWeather()
        return convertWrapperIntoWeatherModelsList(wrapper: wrapper)
        
    }
    
    
    private func convertUnixTimeToDictionary(unixTime: Int) -> TimeModel {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let calendar = Calendar.current
        
        // Extract components of the date
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        return TimeModel(hour: hour, day: day, month: month)
    }
    
    func convertWrapperIntoWeatherModelsList (wrapper : WeatherApiNetwork.Wrapper) -> [WeatherModel]{
        var weathers : [WeatherModel] = []
        wrapper.weatherEntries.forEach { weatherEntry in
            let date = convertUnixTimeToDictionary(unixTime: weatherEntry.dt)
            let weatherText = weatherEntry.weather.first!.main
            let weather = WeatherModel (date: date, weather: weatherText)
            weathers.append(weather)
            
        }
        print (weathers.last?.date.day)
        return weathers
        
    }
}
