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

    
    
    static func createAssignmentForClient (client:Client, withDescription description:String) -> Assignment {
        let assignment = NSEntityDescription.insertNewObjectForEntityForName(kAssignmentEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Assignment
        assignment.client = client
        assignment.desc = description
        CoreData.sharedInstance.saveContext()
        return assignment
    }

    static func createAssignmentForClientNow (client:Client, withDescription description:String) -> Assignment {
        
        let existingClient = CoreData.managedObjectByURI(client.objectID.URIRepresentation()) as? Client
        
        endPreviousAssignmentForClient(existingClient!)
        
        let assignment = NSEntityDescription.insertNewObjectForEntityForName(kAssignmentEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Assignment
        
        assignment.client = existingClient!
        assignment.desc = description
        assignment.begin = NSDate()
        CoreData.sharedInstance.saveContext()
        
        
        return assignment
    }
    
    static func createAssignmentNow (withDescription description:String) -> Assignment {
        
        let assignment = NSEntityDescription.insertNewObjectForEntityForName(kAssignmentEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Assignment
        
        assignment.desc = description
        assignment.begin = NSDate()
        CoreData.sharedInstance.saveContext()
        
        return assignment
    }

    static func createAssignmentForClientWithDate (client:Client, withDescription description:String, begins beginDate:NSDate, ends endDate:NSDate) -> Assignment {
        
        let existingClient = CoreData.managedObjectByURI(client.objectID.URIRepresentation()) as? Client
        
        let assignment = NSEntityDescription.insertNewObjectForEntityForName(kAssignmentEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Assignment
        assignment.client = existingClient!
        assignment.desc = description
        assignment.begin = beginDate
        assignment.end = endDate
        CoreData.sharedInstance.saveContext()
        return assignment
    }
    
    static func deleteAllForClient(client:Client) {
        let request = NSFetchRequest(entityName: kAssignmentEntity)
        request.predicate = NSPredicate(format: "client == %@", client)
        if let allAssignments = (try? CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as? [Assignment] {
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
        
        if let prevAssignment = (try? CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request))!!.first as? Assignment {
            prevAssignment.end = NSDate()
        }
        CoreData.sharedInstance.saveContext()
    }

    static func endPreviousAssignment() {
        let request = NSFetchRequest(entityName: kAssignmentEntity)
        request.sortDescriptors = [NSSortDescriptor(key: "begin", ascending: false)]
        request.fetchLimit = 1
        
        if let prevAssignment = (try? CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request))!!.first as? Assignment {
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
    
    func getCSV() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle

        let cRunning = running
        let cDesc = desc
        let cBegin = dateFormatter.stringFromDate(begin)
        let cEnd =  dateFormatter.stringFromDate(end)
        let cClientName = client.name

        return "\(cDesc),\(cRunning),'\(cBegin)','\(cEnd)',\(cClientName)\n"

    }
    

    static func setClient (client:Client, For assignment:Assignment) -> Bool {
        
//        let existingClient = CoreData.managedObjectByURI(client.objectID.URIRepresentation()) as? Client
//        let existingAssignment = CoreData.managedObjectByURI(client.objectID.URIRepresentation()) as? Assignment
        
        assignment.client = client
        CoreData.sharedInstance.saveContext()
        return true
    }


    
}