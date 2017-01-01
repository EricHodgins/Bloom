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
    
    private func delay(seconds: Int, completionHandler: @escaping (() -> Void)) {
        let delayInMilliSeconds = DispatchTime.now() + DispatchTimeInterval.seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: delayInMilliSeconds, execute: completionHandler)
    }
        
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
    
    func testCancelButtonForCreatingWorkoutRoutine() {
        let createWorkoutRoutineButton = app.buttons["Create Workout Routine"]
        createWorkoutRoutineButton.tap()
        
        let cancelButton = app.buttons["Cancel"]
        
        XCTAssertTrue(cancelButton.exists, "Cancel button does not exist in Creating Workout Routine")
        
        // Make sure it dismisses
        cancelButton.tap()
        
        XCTAssertTrue(createWorkoutRoutineButton.exists, "Cancel Button Failed to dismiss.")
        
    }
    
    func testSaveButtonForCreatingWorkoutRoutine() {
        let createWorkoutRoutineButton = app.buttons["Create Workout Routine"]
        createWorkoutRoutineButton.tap()
        
        let saveButton = app.buttons["Save"]
        
        XCTAssertTrue(saveButton.exists, "Cancel button does not exist in Creating Workout Routine")
        
        // Make sure it dismisses
        saveButton.tap()
        
        XCTAssertTrue(createWorkoutRoutineButton.exists, "Save Button Failed to dismiss.")
    }
    
    func testWorkoutsButton() {
        app.buttons["Workouts"].tap()
        
        let workoutsNavBar = app.navigationBars["Workouts"]
        
        XCTAssertTrue(workoutsNavBar.exists, "Workouts button did not work.")
    }
    
    func testViewStatusButton() {
        app.buttons["View Stats"].tap()
        
        let statsNavBar = app.navigationBars["Stats"]
        
        XCTAssertTrue(statsNavBar.exists, "View stats button not working.")
    }
    
    func testTransitionToStartWorkoutView() {
        app.buttons["Workouts"].tap()
        XCTAssertTrue(app.navigationBars["Workouts"].exists)
        
        let countDownLabel = app.staticTexts["0"]
        app.tables.staticTexts["chest and back"].tap()
        XCTAssertTrue(app.navigationBars["chest and back"].exists)
        XCTAssertFalse(countDownLabel.exists)
        
        app.buttons["Start"].tap()
        sleep(5) // assuming animtion takes 3 seconds to complete
        XCTAssertTrue(countDownLabel.exists, "Countdown label did not appear.")

    }
    
}




































