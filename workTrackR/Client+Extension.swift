//
//  Client+Extension.swift
//  workTrackR
//
//  Created by Marc Bintinger on 30.08.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import Foundation
import CoreData


// private var clientsDidSaveArray = [Client]()

extension Client {
    
    static func createWithName (name:String) -> Client {
        let client = NSEntityDescription.insertNewObjectForEntityForName(kClient, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as! Client
        client.name = name
        client.order = CoreData.minIntegerValueForEntity(kClient, attributeName: kClientOrder) - 1
        CoreData.sharedInstance.saveContext()
        
        return client
    }
    
    static func deleteAll() {
        let request = NSFetchRequest(entityName: kClient)
        if let allClients = CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: nil) as? [Client] {
            for client in allClients {
                CoreData.sharedInstance.managedObjectContext?.deleteObject(client)
            }
            CoreData.sharedInstance.saveContext()
        }
    }
    
    func delete() {
        CoreData.sharedInstance.managedObjectContext?.deleteObject(self)
        CoreData.sharedInstance.saveContext()
    }
    /* vermeidet bei rekursivem Aufruf das mehrfache Herunterzählen der Order und somit eine Endlosschleife
    override func willSave() {
        super.willSave()
        
        if let index = find(clientsDidSaveArray, self) {
            clientsDidSaveArray.removeAtIndex(index)
        } else {
            clientsDidSaveArray.append(self)
            if inserted {
                let minValue = CoreData.minIntegerValueForEntity(kClient, attributeName: kClientOrder)
                order = minValue - 1
            }
       }
    }
    */
}