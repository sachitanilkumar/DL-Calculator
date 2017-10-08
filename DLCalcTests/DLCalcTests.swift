//
//  DLCalcTests.swift
//  DLCalcTests
//
//  Created by Sachit Anil Kumar on 07/10/17.
//  Copyright © 2017 Sachit Anil Kumar. All rights reserved.
//

import XCTest
@testable import DLCalc

class DLCalcTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testInningInitializationSuceeds() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 50)
        XCTAssertNotNil(newInning)
    }
    
    func testInningInitializationFails1() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 70)
        XCTAssertNil(newInning)
    }
    
    func testInningInitializationFails2() {
        let newInning = Inning (inningPosition: 3, oversAtBeginning: 20)
        XCTAssertNil(newInning)
    }
    
    func testSetResourcesLostTotalSuceeds() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 50)
        newInning?.resourcesLost = [10.0, 2.5, 5.0]
        newInning?.setResourcesLostTotal()
        XCTAssertEqual(newInning?.resourcesLostTotal, 17.5)
    }
    
    func testSetResourcesLostTotalFails() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 50)
        newInning?.resourcesLost = [10.0, 4.5, 5.0]
        newInning?.setResourcesLostTotal()
        XCTAssertNotEqual(newInning?.resourcesLostTotal, 20.0)
    }
    
    func testSetResourcesAvailSuceeds() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 50)
        newInning?.resourcesLost = [10.0, 2.5, 5.0]
        newInning?.setResourcesAvail()
        XCTAssertEqual(newInning?.resourcesAvail, 82.5)
    }
    
    func testSetResourcesAvailFails1() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 50)
        newInning?.resourcesLost = [10.0, 2.5, 5.0]
        newInning?.setResourcesAvail()
        XCTAssertNotEqual(newInning?.resourcesAvail, 72.5)
    }
    
    func testSetResourcesAvailFails2() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 20)
        newInning?.resourcesLost = [10.0, 2.5, 5.0]
        newInning?.setResourcesAvail()
        XCTAssertNotEqual(newInning?.resourcesAvail, 82.5)
    }
    
    func testSubtractOversSuceeds1() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 20)
        let oversRemaining = newInning?.subtractOvers(first: 50.0, second: 20.0)
        XCTAssertEqual(oversRemaining, 30.0)
    }
    
    func testSubtractOversSuceeds2() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 20)
        let oversRemaining = newInning?.subtractOvers(first: 50.0, second: 20.5)
        XCTAssertEqual(oversRemaining, 29.1)
    }
    
    func testSubtractOversFails() {
        let newInning = Inning (inningPosition: 1, oversAtBeginning: 20)
        let oversRemaining = newInning?.subtractOvers(first: 50.0, second: 20.5)
        XCTAssertNotEqual(oversRemaining, 29.0)
    }
    
    func testAddPrematureTermination1(){
        let newInning = Inning (inningPosition: 2, oversAtBeginning: 50)
        let idx = newInning?.resourcesLost?.count
        newInning?.addPrematureTermination(oversAtStop: 30.0, wickets: 2)
        XCTAssertEqual(newInning?.resourcesLost![idx!], 52.4)
    }
    
    func testAddPrematureTermination2(){
        let newInning = Inning (inningPosition: 2, oversAtBeginning: 50)
        let idx = newInning?.resourcesLost?.count
        newInning?.addPrematureTermination(oversAtStop: 50.0, wickets: 2)
        XCTAssertEqual(newInning?.resourcesLost![idx!], 0)
    }
    
    func testSetParScore1(){
        let firstInning = Inning (inningPosition: 1, oversAtBeginning: 50)
        let secondInning = Inning (inningPosition: 2, oversAtBeginning: 50)
        
        firstInning?.finalScore = 300
        firstInning?.setResourcesAvail()
        
        secondInning?.addPrematureTermination(oversAtStop: 30.0, wickets: 2)
        secondInning?.setResourcesAvail()
        secondInning?.setParScore(firstInning: firstInning!)
        
        XCTAssertEqual(secondInning?.parScore, 142)
    }
    
    func testSetParScore2(){
        let firstInning = Inning (inningPosition: 1, oversAtBeginning: 20)
        let secondInning = Inning (inningPosition: 2, oversAtBeginning: 20)
        
        firstInning?.finalScore = 180
        firstInning?.setResourcesAvail()
        
        secondInning?.addPrematureTermination(oversAtStop: 12.0, wickets: 2)
        secondInning?.setResourcesAvail()
        secondInning?.setParScore(firstInning: firstInning!)
        
        XCTAssertEqual(secondInning?.parScore, 98)
    }
    
    func testGetFormattedParScore(){
        let newInning = Inning (inningPosition: 2, oversAtBeginning: 50)
        newInning?.parScore = 145
        let parScoreText = newInning?.getFormattedParScore()
        XCTAssertEqual(parScoreText, "145")
    }
}
