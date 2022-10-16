import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}


enum BaseUrl: String {
    case openweathermap = "https://api.openweathermap.org"
    case mockServer = "127.0.0.1:8080"
}

let apiKey = "6810dc9f50f54b90289eb8e83ed6fd14"

class WeatherServiceImpl: WeatherService {
    let url = "\(BaseUrl.openweathermap.rawValue)/data/2.5/weather?q=corvallis&units=imperial&appid=\(apiKey)"
    //let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=6810dc9f50f54b90289eb8e83ed6fd14"
    //let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=<INSERT YOUR API KEY HERE>"
    
    func getTemperature() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                switch response.result {
                case let .success(weather):
                    let temperature = weather.main.temp
                    let temperatureAsInteger = Int(temperature)
                    continuation.resume(with: .success(temperatureAsInteger))

                case let .failure(error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
    
    
}

struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
