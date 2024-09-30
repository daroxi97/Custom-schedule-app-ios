//
//  GetWeatherFromApiUseCase.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 20/9/24.
//

import Foundation

class GetWeatherFromApiUseCase{
    var api : WeatherApiNetwork = WeatherApiNetwork()
    func GetWeatherFromApi () async throws{
        var wrapper = try await api.getWeather()
    }
}
