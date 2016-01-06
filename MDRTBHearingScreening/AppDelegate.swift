//
//  AppDelegate.swift
//  MDRTBHearingScreening
//
//  Created by Laura Greisman on 3/28/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData
import QuickLook

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIDocumentInteractionControllerDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization just before application launch.
        
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        let rootController = self.window?.rootViewController
        if let navController = self.window?.rootViewController as? UINavigationController {
            print("documentInteractionControllerViewControllerForPreview")
            // TODO: - add a button for importing file to DB
            return navController
        }
        return rootController!
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        print("application openURL")
        // TODO: - add dialog to confim or cancel import. Confirm will import file data into main store, then delete the imported file, cancel will just delete the imported file
        
        let alertController = UIAlertController(title: "Importing file", message: "Click Import to add all the tests in the file. Click Cancel if you do not want to import tests.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction) -> Void in
            print("cancel")
            
            // delete file from inbox
            print("deleting \(url)")
            do {
                try NSFileManager.defaultManager().removeItemAtURL(url)
            } catch _ {
            }
        }))
        /*
        alertController.addAction(UIAlertAction(title: "Open", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            println("open")
            
            
            // open file from inbox
            let documentInteractionController = UIDocumentInteractionController(URL: url)
            documentInteractionController.delegate = self
            
            let previewResult = documentInteractionController.presentPreviewAnimated(true)
            
            println("previewResult :: \(previewResult)")
            println("\(documentInteractionController.name)")
            println("\(documentInteractionController.UTI)")
            println("\(documentInteractionController.icons)")
            
        }))
        */
        alertController.addAction(UIAlertAction(title: "Import", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
            print("import")
            
            if let navController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ImportExportNavController") as? UINavigationController {
                if let controller = navController.topViewController as? ImportExportViewController {
                    controller.currentMode = .ImportFromCSV
                    controller.importFileURL = url
                    self.window?.rootViewController?.presentViewController(navController, animated: true, completion: nil)
                }
            }
            
        }))
        
        self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        
        return true
    }
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
        print("preview closed")
        
        // delete file from inbox
        print("deleting \(controller.URL)")
        do {
            try NSFileManager.defaultManager().removeItemAtURL(controller.URL!)
        } catch {
            print("Error in documentInteractionControllerDidEndPreview")
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    lazy var deviceAppId: String? = {
        let uuid = UIDevice.currentDevice().identifierForVendor
        return uuid?.UUIDString
    }()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.incapari.MDRTBHearingScreening" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("MDRTBHearingScreening", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // Setup main store - local read/write store
        let mainStoreUrl = self.applicationDocumentsDirectory.URLByAppendingPathComponent("MDRTBHearingScreening.mainstore")
        print(mainStoreUrl)
        var err: NSError? = nil
        let mainStoreOptions: [NSObject : AnyObject]? = [
            NSIgnorePersistentStoreVersioningOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true,
            NSPersistentStoreFileProtectionKey: NSFileProtectionComplete]
        do {
            try coordinator!.addPersistentStoreWithType(NSBinaryStoreType, configuration: nil, URL: mainStoreUrl, options: mainStoreOptions)
        } catch var error as NSError {
            err = error
            coordinator = nil
            print("Error setting up main store: \(err), \(err!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        // Setup imported stores - assume these are files with extension .readonlystore
        
        do {
            let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(self.applicationDocumentsDirectory,
                includingPropertiesForKeys: nil,
                options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
            
            let filteredArray = contents.filter { $0.pathExtension == "readonlystore" }
            for readonOnlyStoreUrl: NSURL in filteredArray {
                print(readonOnlyStoreUrl)
                let readOnlyOptions: [NSObject : AnyObject]? = [
                    NSReadOnlyPersistentStoreOption: true,
                    NSIgnorePersistentStoreVersioningOption: true,
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true,
                    NSPersistentStoreFileProtectionKey: NSFileProtectionComplete]
                
                do {
                    try coordinator!.addPersistentStoreWithType(NSBinaryStoreType, configuration: nil, URL: readonOnlyStoreUrl, options: readOnlyOptions)
                } catch var err as NSError {
                    print("Unresolved error \(err), \(err.userInfo)")
                }
            }
        } catch var err as NSError {
            print("Unresolved error \(err), \(err.userInfo)")
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            let start = NSDate()
            if moc.hasChanges {
                print("saving context with \(moc.registeredObjects.count) objects")
                do {
                    try moc.save()
                } catch let error as NSError {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
            }
            let timeInterval = -start.timeIntervalSinceNow
            print("saving context took :: \(timeInterval)")
        }
    }

}

