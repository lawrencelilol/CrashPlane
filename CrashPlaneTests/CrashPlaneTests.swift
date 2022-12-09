//
//  CrashyPlaneTests.swift
//  CrashyPlaneTests
//
//  Created by 荀任之 on 2022/12/8.
//

import XCTest
@testable import CrashPlane

final class CrashyPlaneTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getCoins() {
      
      let SDK = CrashPlane.StartGameScene().user
      let oldCoins = SDK.getCoins()
      SDK.consumeCoin(coin: 5)
      let coins = SDK.getCoins()
      XCTAssertEqual(oldCoins - coins, 5)
    }
  
    func test_getSteps() {
      let SDK = CrashPlane.StartGameScene().user
      let steps = SDK.getSteps()
      XCTAssertEqual(steps, SDK.defaults.integer(forKey: "steps"))
    }
  
    func test_convertCoins() {
        let SDK = CrashPlane.StartGameScene().user
        
        let coins = SDK.convertCoins()
        let steps = Int(SDK.currentStep)
        XCTAssertTrue(steps >= coins * 100 && steps <= (coins + 1) * 100)
    }
    
    func test_consumeCoins() {
        let SDK = CrashPlane.StartGameScene().user
        let oldCoins = SDK.getCoins()
        SDK.consumeCoin(coin: 10)
        let coins = SDK.getCoins()
        XCTAssertEqual(oldCoins - coins, 10)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
