//
//  AppDelegate.swift
//  TabApp
//
//  Created by Garrett Head on 2/10/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit
//import CoreData
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Set the color of the TabBar Items
        UITabBar.appearance().tintColor = .black
        
        // configure firebase
        FirebaseApp.configure()

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

    // MARK: - Core Data stack
    
//    lazy var applicationDocumentsDirectory: URL = {
//        // The directory the application uses to store the Core Data store file. This code uses a directory named "iosDev.RepHub" in the application's documents Application Support directory.
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return urls[urls.count-1]
//    }()
//
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//        let modelURL = Bundle.main.url(forResource: "RepHub", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOf: modelURL)!
//    }()
//
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
//        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//        // Create the coordinator and store
//        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.appendingPathComponent("RepHub.sqlite")
//        var failureReason = "There was an error creating or loading the application's saved data."
//        do {
//            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption:true])
//        } catch {
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
//
//            dict[NSUnderlyingErrorKey] = error as NSError
//            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
//            abort()
//        }
//
//        return coordinator
//    }()
//
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//    }()
//
//    // MARK: - Core Data Saving support
//    
//    func saveContext () {
//        if managedObjectContext.hasChanges {
//            do {
//                try managedObjectContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//                abort()
//            }
//        }
//    }
//    
//    /**
//     The method takes in three parameters: the file’s URL, encoding and an error pointer.
//     It first loads the file content into memory, reads the lines into an array and then performs the parsing line by line.
//     At the end of the method, it returns an array of food menu items in the form of tuples.
//     **/
//    func parseCSV (contentsOfURL: NSURL, encoding: String.Encoding, error: NSErrorPointer) -> [(name:String, muscleGroup:String, focusArea: String, region: String, force: String, modality: String, joint: String)]? {
//        // Load the CSV file and parse it
//        let delimiter = ","
//        var items:[(name:String, muscleGroup:String, focusArea: String, region: String, force: String, modality: String, joint: String)]?
//        
//        do {
//            let content = try String(contentsOf: contentsOfURL as URL, encoding: encoding)
//            items = []
//            let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
//            
//            for line in lines {
//                var values:[String] = []
//                if line != "" {
//                    // For a line with double quotes
//                    // we use NSScanner to perform the parsing
//                    if line.range(of: "\"") != nil {
//                        var textToScan:String = line
//                        var value:NSString?
//                        var textScanner:Scanner = Scanner(string: textToScan)
//                        while textScanner.string != "" {
//                            
//                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
//                                textScanner.scanLocation += 1
//                                textScanner.scanUpTo("\"", into: &value)
//                                textScanner.scanLocation += 1
//                            } else {
//                                textScanner.scanUpTo(delimiter, into: &value)
//                            }
//                            
//                            // Store the value into the values array
//                            values.append(value! as String)
//                            
//                            // Retrieve the unscanned remainder of the string
//                            if textScanner.scanLocation < textScanner.string.count {
//                                textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
//                            } else {
//                                textToScan = ""
//                            }
//                            textScanner = Scanner(string: textToScan)
//                        }
//                        
//                        // For a line without double quotes, we can simply separate the string
//                        // by using the delimiter (e.g. comma)
//                    } else  {
//                        values = line.components(separatedBy:delimiter)
//                    }
//
//                    let item = (name: values[0], muscleGroup:values[1], focusArea: values[2], region: values[3], force: values[4], modality: values[5], joint: values[6])
//                    items?.append(item)
//                }
//            }
//        }
//        catch _ {
//            // Error handling
//        }
//
//        return items
//    }
//    
//    
//    func preloadData () {
//        // Retrieve data from the source file
//        if let contentsOfURL = Bundle.main.url(forResource: "exercises", withExtension: "csv") {
//            // Remove all the exercise items before preloading
//            //removeData()
//            var error:NSError?
//            if let items = parseCSV(contentsOfURL: contentsOfURL as NSURL, encoding: String.Encoding.utf8, error: &error) {
//                // Preload the menu items
//                if let managedObjectContext = self.managedObjectContext as? NSManagedObjectContext {
//                    for item in items {
//                        let exerciseItem = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: managedObjectContext) as! Exercise
//                        exerciseItem.name = item.name
//                        exerciseItem.muscleGroup = item.muscleGroup
//                        exerciseItem.region = item.region
//                        exerciseItem.focusArea = item.focusArea
//                        exerciseItem.force = item.force
//                        exerciseItem.modality = item.modality
//                        exerciseItem.joint = item.joint
//
//                    }
//                }
//            }
//        }
//    }
//    
//    func removeData () {
//        // Remove the existing items
//        if let managedObjectContext = self.managedObjectContext as? NSManagedObjectContext {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
//            //var e: NSError?
//            do {
//                let exerciseItems = try managedObjectContext.fetch(fetchRequest) as! [Exercise]
//                for exerciseItem in exerciseItems {
//                    managedObjectContext.delete(exerciseItem)
//                }
//            }
//            catch _ {
//                // Error handling
//            }
//        }
//    }
//    

}

