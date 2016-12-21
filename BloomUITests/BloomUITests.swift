//
//  BloomUITests.swift
//  BloomUITests
//
//  Created by Eric Hodgins on 2016-12-20.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import XCTest

class BloomUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShowCreateWorkoutView() {
        app.buttons["Create Workout Routine"].tap()
        
        let addExcerciseButton = app.buttons["+ Add Excercise"]
        
        XCTAssertTrue(addExcerciseButton.exists, "Create Workout Routine Button failed.")
        
        addExcerciseButton.tap()
        
        let enterExcerciseName = app.textFields["Excercise Name"]
        
        XCTAssertTrue(enterExcerciseName.exists, "Add Excercise View Failed.")
        
    }
    
}
