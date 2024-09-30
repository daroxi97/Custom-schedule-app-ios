//
//  WeatherApiNetwork.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 20/9/24.
//

import Foundation


class WeatherApiNetwork{
    var apiId = "549c988c76510172f7adb16ff1fb865c"
    
    struct Wrapper:Codable{
        let weatherEntries:[WeatherEntry]
        
        enum CodingKeys:String, CodingKey{
            case weatherEntries = "list"
        }
    }
    
    struct WeatherEntry: Codable {
        let dt: Int
        let weather: [WeatherCondition]
    }
    
    struct WeatherCondition: Codable {
        let main: String
        let description: String
    }
    
    func getWeather() async throws -> Wrapper{
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=barcelona&appid=\(apiId)&units=metric")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
        return wrapper
    }
}
