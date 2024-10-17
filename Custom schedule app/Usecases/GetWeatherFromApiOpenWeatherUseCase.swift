//
//  GetWeatherFromApiUseCase.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 20/9/24.
//

import Foundation

class GetWeatherFromApiOpenWeatherUseCase : GetWeatherFromApiUseCaseProtocol{
    var api : WeatherOpenWeatherNetwork = WeatherOpenWeatherNetwork()
    
    func getWeatherFromApi () async throws ->[WeatherModel]{
        let wrapper = try await WeatherOpenWeatherNetwork().getWeather()
        return convertWrapperIntoWeatherModelsList(wrapper: wrapper)
        
    }
    
    
    func convertWrapperIntoWeatherModelsList (wrapper : WeatherOpenWeatherNetwork.Wrapper) -> [WeatherModel]{
        var weathers : [WeatherModel] = []
        wrapper.weatherEntries.forEach { weatherEntry in
            let date = TimeUtilities().convertUnixTimeToDictionary(unixTime: weatherEntry.dt)
            let weatherText = weatherEntry.weather.first!.main
            let weather = WeatherModel (date: date, weather: weatherText)
            weathers.append(weather)
            
        }
        print (weathers.last?.date.day)
        return weathers
        
    }
}
