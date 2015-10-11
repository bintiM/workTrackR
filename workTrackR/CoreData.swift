//
//  CoreData.swift
//  workTrackR
//
//  Created by Marc Bintinger on 27.08.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import Foundation
import CoreData

private var coreDataSharedInstance = CoreData()

class CoreData {
    
    // MARK: - Helper
    
    static func managedObjectByURI(uri:NSURL) -> NSManagedObject? {
        CoreData.sharedInstance.managedObjectContext?.reset()
        if let objectId = CoreData.sharedInstance.persistentStoreCoordinator?.managedObjectIDForURIRepresentation(uri) {
            if let managedObject = CoreData.sharedInstance.managedObjectContext?.objectWithID(objectId) {
                if !managedObject.fault {
                    return managedObject
                }
                if let entityName = managedObject.entity.name {
                    let request = NSFetchRequest(entityName: entityName)
                    request.predicate = NSPredicate(format: "SELF == %@", objectId)
                    
                    return (try? CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request))!!.first as? NSManagedObject
                }
            }
        }
        return nil
    }
    
    static func move(entityName:String, orderAttributeName:String, source:NSManagedObject, toDestination destination:NSManagedObject, predicate:NSPredicate = NSPredicate(value: true)) {
        
        if let sourceOrder = source.valueForKey(orderAttributeName)?.integerValue,
            destinationOrder = destination.valueForKey(orderAttributeName)?.integerValue {
                let request = NSFetchRequest(entityName: entityName)
                
                // nach unten verschieben
                if (sourceOrder < destinationOrder){
                    request.sortDescriptors = [NSSortDescriptor(key: orderAttributeName, ascending: false)]
                    let condition = NSPredicate(format: "\(orderAttributeName) > \(sourceOrder) AND \(orderAttributeName) <= \(destinationOrder)")
                    request.predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [condition, predicate])
                    if let resultArray = (try? CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as? [NSManagedObject] {
                        resultArray.map { (object) -> NSManagedObject in
                            object.setValue(object.valueForKey(orderAttributeName)!.integerValue - 1, forKey: orderAttributeName)
                            return object
                        }
                    }
                } else if (sourceOrder > destinationOrder) { // nach oben verschieben
                    request.sortDescriptors = [NSSortDescriptor(key: orderAttributeName, ascending: true)]
                    let condition = NSPredicate(format: "\(orderAttributeName) >= \(destinationOrder) AND \(orderAttributeName) < \(sourceOrder)")
                    request.predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [condition, predicate])
                    if let resultArray = (try? CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as? [NSManagedObject] {
                        resultArray.map { (object) -> NSManagedObject in
                            object.setValue(object.valueForKey(orderAttributeName)!.integerValue + 1, forKey: orderAttributeName)
                            return object
                        }
                    }
                }
                source.setValue(destinationOrder, forKey: orderAttributeName)
                CoreData.sharedInstance.saveContext()
        }
    }
    
    static func minMaxIntegerValueForEntity(entityName:String, attributeName:String, minimum:Bool, predicate:NSPredicate = NSPredicate(value: true)) -> Int {
        let request = NSFetchRequest(entityName: entityName)
        // if minimum is true -> ASC is true and gives smallest value
        request.sortDescriptors = [NSSortDescriptor(key: attributeName, ascending: minimum)]
        request.fetchLimit = 1
        request.predicate = predicate
        if let object = (try? CoreData.sharedInstance.managedObjectContext!.executeFetchRequest(request))?.first as? NSManagedObject {
            return object.valueForKey(attributeName)?.integerValue ?? 0
        }
        return 0
    }
    
    static func minIntegerValueForEntity(entityName:String, attributeName:String, predicate:NSPredicate = NSPredicate(value: true)) -> Int {
        return minMaxIntegerValueForEntity(entityName, attributeName: attributeName, minimum: true, predicate: predicate)
    }

    static func maxIntegerValueForEntity(entityName:String, attributeName:String, predicate:NSPredicate = NSPredicate(value: true)) -> Int {
        return minMaxIntegerValueForEntity(entityName, attributeName: attributeName, minimum: false, predicate: predicate)
    }

    // MARK: - Singleton
    class var sharedInstance:CoreData {
        return coreDataSharedInstance
    }

    // MARK: - Core Data stack

    private init () {}
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "at.bintinger.workTrackR" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("workTrackR", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        if let containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(kAppGroup) {

            let url = containerURL.URLByAppendingPathComponent("workTrackR.sqlite")
            var error: NSError? = nil
            var failureReason = "There was an error creating or loading the application's saved data."
            do {
                try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
            } catch var error1 as NSError {
                error = error1
                coordinator = nil
                // Report any error we got.
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error
                error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            } catch {
                fatalError()
            }
            return coordinator
            
        } else {
            NSLog("Can't create persistantStoreCoordinator")
            abort()
        }
        
        return nil
        
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }

        var managedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}