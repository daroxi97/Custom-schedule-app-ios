//
//  GetWeatherFromApiProtocol.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 9/10/24.
//

import Foundation
protocol GetWeatherFromApiUseCaseProtocol {
    associatedtype WrapperType

    func getWeatherFromApi() async throws -> [WeatherModel]
    func convertWrapperIntoWeatherModelsList(wrapper: WrapperType) -> [WeatherModel]
}
