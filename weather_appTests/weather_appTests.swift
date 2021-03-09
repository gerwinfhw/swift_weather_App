//
//  weather_appTests.swift
//  weather_appTests
//
//  Created by Gerwin on 09.02.21.
//  Copyright © 2021 Gerwin. All rights reserved.
//

import XCTest
@testable import weather_app

class weather_appTests: XCTestCase {

    func testHelper_IsDay_day() {
        XCTAssertTrue(Helper.isDay(localTime: [12,00], sunrise: [11,00], sunset: [18,00]))
    }
    
    func testHelper_IsDay_night() {
        XCTAssertFalse(Helper.isDay(localTime: [23,00], sunrise: [11,00], sunset: [18,00]))
    }
    
    func testHelper_IsDay_morning() {
        XCTAssertFalse(Helper.isDay(localTime: [10,00], sunrise: [11,00], sunset: [18,00]))
    }
    
    func testHelper_IsDay_lowest() {
        XCTAssertTrue(Helper.isDay(localTime: [18,00], sunrise: [11,00], sunset: [18,00]))
    }
    
    func testHelper_IsDay_highes() {
        XCTAssertTrue(Helper.isDay(localTime: [11,00], sunrise: [11,00], sunset: [18,00]))
    }
    
    func testHelper_IsDay_lowerSunsetEdge() {
        XCTAssertTrue(Helper.isDay(localTime: [18,01], sunrise: [11,00], sunset: [18,02]))
    }
    
    func testHelper_IsDay_higherSunsetEdge() {
        XCTAssertFalse(Helper.isDay(localTime: [18,03], sunrise: [11,00], sunset: [18,02]))
    }
    
    func testHelper_IsDay_lowerSunriseEdge() {
        XCTAssertFalse(Helper.isDay(localTime: [11,01], sunrise: [11,02], sunset: [18,00]))
    }
    
    func testHelper_IsDay_higherSunriseEdge() {
        XCTAssertTrue(Helper.isDay(localTime: [11,03], sunrise: [11,02], sunset: [18,00]))
    }
    
    func testHelper_IsDay_sunsetIsPastMidnight_1() {
        XCTAssertTrue(Helper.isDay(localTime: [12,00], sunrise: [11,00], sunset: [03,00]))
    }
    
    func testHelper_IsDay_sunsetIsPastMidnight_2() {
        XCTAssertTrue(Helper.isDay(localTime: [02,00], sunrise: [11,00], sunset: [03,00]))
    }
    
    func testHelper_IsDay_sunriseMidnight() {
        XCTAssertTrue(Helper.isDay(localTime: [02,00], sunrise: [00,00], sunset: [03,00]))
    }
    
    func testHelper_IsDay_sunsetMidnight() {
        XCTAssertTrue(Helper.isDay(localTime: [02,00], sunrise: [01,00], sunset: [00,00]))
    }
    
    func testHelper_isDay_alltheSameTime() {
        XCTAssertTrue(Helper.isDay(localTime: [03,01], sunrise: [03,01], sunset: [03,01]))
    }
    
    func test_buildURL_normal() {
        let result = Helper.buildURL(for: "Berlin")
        let expected = "https://api.openweathermap.org/data/2.5/weather?q=Berlin&units=metric&lang=de&appid=\(Helper.weather_api_key)"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_buildURL_withMutatedVowel_1() {
        let result = Helper.buildURL(for: "Köln")
        let expected = "https://api.openweathermap.org/data/2.5/weather?q=Koeln&units=metric&lang=de&appid=\(Helper.weather_api_key)"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_buildURL_withMutatedVowel_2() {
        let result = Helper.buildURL(for: "Jyväskylä")
        let expected = "https://api.openweathermap.org/data/2.5/weather?q=Jyvaeskylae&units=metric&lang=de&appid=\(Helper.weather_api_key)"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_buildURL_withMutatedVowel_3() {
        let result = Helper.buildURL(for: "München")
        let expected = "https://api.openweathermap.org/data/2.5/weather?q=Muenchen&units=metric&lang=de&appid=\(Helper.weather_api_key)"
        
        XCTAssertEqual(result, expected)
    }
    
    func test_convertToNormalTimeToString() {
        let result = Helper.convertToNormalTimeToString(from: 1615268082.0)
        let expected = "05:34"
        
         XCTAssertEqual(result, expected)
    }
    
    

}
