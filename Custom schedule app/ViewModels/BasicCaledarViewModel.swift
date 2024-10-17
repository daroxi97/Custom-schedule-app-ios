import Foundation

class BasicCalendarViewModel: ObservableObject {
    @Published var registeredDaysWithActivities: [String: ScheduledDayModel] = [:]
    
    private var weathersListFromApi: [WeatherModel] = []
    private var getWeatherUseCase: any GetWeatherFromApiUseCaseProtocol
    
    init() {
        self.getWeatherUseCase = GetWeatherFromApiOpenWeatherUseCase()
    }
    
    func fetchWeather() async -> [WeatherModel] {
        do {
            weathersListFromApi = try await getWeatherUseCase.getWeatherFromApi()
            print(weathersListFromApi.first?.weather ?? "No weather data available")
            return weathersListFromApi
        } catch {
            print("Error fetching weather: \(error)")
            weathersListFromApi.removeAll()
            return weathersListFromApi
        }
    }
    //Register a new activity on the database
    func registerActivity(id: String, activity: ActivityModel) {
        if registeredDaysWithActivities[id] == nil {
            registeredDaysWithActivities[id] = ScheduledDayModel(id: id, activities: [activity])
        } else {
            registeredDaysWithActivities[id]?.activities.append(activity)
        }
        updateActivitiesWeather()
    }
    //Check all the rainy hours and check if exterior activities will be affected
    private func updateActivitiesWeather() {
        for weather in weathersListFromApi {
            if weather.weather.contains("Rain") {
                markRainyActivities(for: weather)
            }
        }
    }
    
    //Check if there ara activities on the rainy days
    private func markRainyActivities(for weather: WeatherModel) {
        for (dayId, scheduledDay) in registeredDaysWithActivities {
            for activity in scheduledDay.activities {
                if activity.time == weather.date &&
                   abs(activity.time.hour - weather.date.hour) <= 3 {
                    activity.weather = "Rain"
                }
            }
        }
    }
}
