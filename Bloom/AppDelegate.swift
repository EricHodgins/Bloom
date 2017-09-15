//
//  AppDelegate.swift
//  Bloom
//
//  Created by Eric Hodgins on 2016-12-12.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData
import HealthKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    
    lazy var coreDataStack = CoreDataStack(modelName: "Bloom")
    lazy var phoneConnectivityManager: PhoneConnectivityManager = {
        return PhoneConnectivityManager(managedContext: self.coreDataStack.managedContext)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard let navController = window?.rootViewController as? UINavigationController,
            let mainController = navController.topViewController as? MainViewController else { return true }
        
        navController.navigationBar.barTintColor = UIColor.white
        mainController.managedContext = coreDataStack.managedContext
        
        // Keyboard Manager to adjust views for textfield input
        BloomTextfieldManager.shared.enabled = true
        
        // Test:  - Load test data if needed
        //importJSONTestData()
        
        // Test:  - Check what has been saved.
        dataInCoreDataStore()
        
        
        // Activate Watch Connectivity
        setupWatchConnectivity()
        coreDataStack.performCleanUp()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - HealthKitStore Authorization
    let healthStore = HKHealthStore()
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        healthStore.handleAuthorizationForExtension { (success, error) in
        }
    }

    //MARK: Helpers
    func dataInCoreDataStore() {
        let coreDataTest = CoreDataTest(context: coreDataStack.managedContext)
        
        coreDataTest.printAllWorkouts()
        coreDataTest.printAllWorkoutsAndExcercises()
    }
    
    func importJSONWorkoutTemplates(jsonDict: [String : AnyObject]) {
        let workoutTemplates = jsonDict["templates"] as! [[String : AnyObject]]
        let workoutEntity = NSEntityDescription.entity(forEntityName: "WorkoutTemplate", in: coreDataStack.managedContext)!
        let excerciseEntity = NSEntityDescription.entity(forEntityName: "ExcerciseTemplate", in: coreDataStack.managedContext)!
        
        for workout in workoutTemplates {
            print(workout["name"] ?? "")
            let wkout = WorkoutTemplate(entity: workoutEntity, insertInto: coreDataStack.managedContext)
            wkout.name = workout["name"]! as? String
            if let excercises = workout["excercises"] as? [[String : AnyObject]] {
                for excercise in excercises {
                    let exc = ExcerciseTemplate(entity: excerciseEntity, insertInto: coreDataStack.managedContext)
                    exc.name = excercise["name"]! as? String
                    exc.orderNumber = excercise["order-number"]! as! Int16
                    wkout.addToExcercises(exc)
                }
            }
        }
        coreDataStack.saveContext()
    }
    
    func importJSONTestData() {
        let fileURL = Bundle.main.url(forResource: "workoutJsonData", withExtension: "json")!
        
        let jsonData = NSData(contentsOf: fileURL)! as Data
        
        let jsonDict = try! JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [String : AnyObject]
        
        // Import Templates
        importJSONWorkoutTemplates(jsonDict: jsonDict)
        
        let workoutsDict = jsonDict["workouts"] as! [[String : AnyObject]]
        //print(workoutsDict)
        let workoutEntity = NSEntityDescription.entity(forEntityName: "Workout", in: coreDataStack.managedContext)!
        let excerciseEntity = NSEntityDescription.entity(forEntityName: "Excercise", in: coreDataStack.managedContext)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        for workout in workoutsDict {
            if let chestWorkouts = workout["chest"] as? [[String : AnyObject]] {
                for chestWorkout in chestWorkouts {
                    let wkout = Workout(entity: workoutEntity, insertInto: coreDataStack.managedContext)
                    wkout.name = "chest"
                    let startString = chestWorkout["startTime"]! as! String
                    let startDate = formatter.date(from: startString)!
                    wkout.startTime = startDate as NSDate
                    if let excercises = chestWorkout["Excercises"] as? [String : AnyObject] {
                        for excercise in excercises {
                            let exc = Excercise(entity: excerciseEntity, insertInto: coreDataStack.managedContext)
                            exc.name = excercise.0
                            exc.reps = Double(excercise.1["Reps"]!! as! NSNumber)
                            exc.weight = Double(excercise.1["Weight"]!! as! NSNumber)
                            wkout.addToExcercises(exc)
                        }
                    }
                    let endString = chestWorkout["endTime"]! as! String
                    let endDate = formatter.date(from: endString)!
                    wkout.endTime = endDate as NSDate
                }
            }
        }
        
        coreDataStack.saveContext()

    }

}


// MARK: - Watch Connectivity
extension AppDelegate {
    
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = phoneConnectivityManager
            session.activate()
        }
    }
}










































