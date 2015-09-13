//
//  Assignment+Extension.swift
//  workTrackR
//
//  Created by Marc Bintinger on 03.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import Foundation
import CoreData

extension Assignment {

    /*
    static func createAssignmentForClient (client:Client, withDescription description:String) -> Assignment {
        let assignment = NSEntityDescription.insertNewObjectForEntityForName(kAssignmentEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Assignment
        assignment.client = client
        assignment.desc = description
        CoreData.sharedInstance.saveContext()
        return assignment
    }*/

    static func createAssignmentForClientNow (client:Client, withDescription description:String) -> Assignment {
        
        endPreviousAssignmentForClient(client)
        
        let assignment = NSEntityDescription.insertNewObjectForEntityForName(kAssignmentEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Assignment
        assignment.client = client
        assignment.desc = description
        assignment.begin = NSDate()
        
        CoreData.sharedInstance.saveContext()
        
        return assignment
    }

    static func createAssignmentForClientWithDate (client:Client, withDescription description:String, begins beginDate:NSDate, ends endDate:NSDate) -> Assignment {
        let assignment = NSEntityDescription.insertNewObjectForEntityForName(kAssignmentEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Assignment
        assignment.client = client
        assignment.desc = description
        assignment.begin = beginDate
        assignment.end = endDate
        CoreData.sharedInstance.saveContext()
        return assignment
    }
    
    static func deleteAllForClient(client:Client) {
        let request = NSFetchRequest(entityName: kAssignmentEntity)
        request.predicate = NSPredicate(format: "client == %@", client)
        if let allAssignments = CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: nil) as? [Assignment] {
            for assignment in allAssignments {
                CoreData.sharedInstance.managedObjectContext?.deleteObject(assignment)
            }
            CoreData.sharedInstance.saveContext()
        }
    }

    static func endPreviousAssignmentForClient(client:Client) {
        let request = NSFetchRequest(entityName: kAssignmentEntity)
        request.predicate = NSPredicate(format: "client == %@ AND end == nil", client)
        request.sortDescriptors = [NSSortDescriptor(key: "begin", ascending: false)]
        request.fetchLimit = 1
        
        if let prevAssignment = CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: nil)?.first as? Assignment {
            prevAssignment.end = NSDate()
        }
        CoreData.sharedInstance.saveContext()
    }

    func delete() {
        CoreData.sharedInstance.managedObjectContext?.deleteObject(self)
        CoreData.sharedInstance.saveContext()
    }

    func switchState() {
        running = !running.boolValue
        CoreData.sharedInstance.saveContext()
    }
    
}