import XCTest
@testable import MyLibrary

final class MyLibraryTests: XCTestCase {
    func testIsLuckyBecauseWeAlreadyHaveLuckyNumber() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(8)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsLuckyBecauseWeatherHasAnEight() async throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: true
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(0)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsNotLucky() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == false)
    }

    func testIsNotLuckyBecauseServiceCallFails() async {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: false,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)

        // When
        let isLuckyNumber = await myLibrary.isLucky(7)

        // Then
        XCTAssertNil(isLuckyNumber)
    }

    // Q5. Unit Test
    func testWeather() async {
        //let realWeatherService = WeatherServiceImpl()
        //let myLibrary = MyLibrary(weatherService: realWeatherService)
        
        // Given
        let jsonString = """
        {
            "coord": {
                "lon": -123.262,
                "lat": 44.5646
            },
        
            "weather": {
                "id": 801,
                "main": "Cloud",
                "description": "few clouds",
                "icon": "02d"
            },
        
            "base": "stations",
        
            "main" : {
                "temp": 17.24,
                "feels_like": 16.9,
                "temp_min": 16.95,
                "temp_max": 22.83,
                "pressure": 1019,
                "humidity": 72
            },
        
            "visibility": 10000,
        
            "wind": {
                "speed": 5.66,
                "deg": 40,
                "gust": 8.23
            },
        
            "clouds": {
                "all": 20
            },
        
            "dt": 1664573310,
        
            "sys": {
                "type": 1,
                "id": 3727,
                "country": "US",
                "sunrise": 1664546983,
                "sunset": 1664589366
            },
        
            "timezone": -25200,
            "id": 5720727,
            "name": "Corvallis",
            "cod": 200
        }
        """
        
        // When
        // Create json data from your json string
        let jsonData = Data(jsonString.utf8)
        
        // Create a JSON decoder
        let jsonDecoder = JSONDecoder()
        
        // Deserialize the data into a model
        let weather = try! jsonDecoder.decode(Weather.self, from: jsonData)
        
        // Then
        XCTAssert(weather.main.temp == 17.24)
    }
    
    
    // Q6. Integration Test
    func testWeatherInegration() async {
        // Given
        let weatherService = WeatherServiceImpl()
        var temp = 0
        
        // When
        do {
            try temp = await weatherService.getTemperature()
            print(temp)
        } catch {
            print("Integration error")
        }
        
        // Then
        XCTAssertNotNil(temp)
    }

}
