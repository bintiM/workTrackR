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
    
    func delete() {
        CoreData.sharedInstance.managedObjectContext?.deleteObject(self)
        CoreData.sharedInstance.saveContext()
    }

}