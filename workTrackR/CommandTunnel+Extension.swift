//
//  CommandTunnel+Extension.swift
//  workTrackR
//
//  Created by Marc Bintinger on 04.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import Foundation
import CoreData

extension CommandTunnel {
    
    static func deleteAllCommands() {
        let request = NSFetchRequest(entityName: kCommandTunnelEntity)
        if let allCommands = (try? CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as? [CommandTunnel] {
            for command in allCommands {
                CoreData.sharedInstance.managedObjectContext?.deleteObject(command)
            }
            CoreData.sharedInstance.saveContext()
        }
    }
    
    static func addCommand(command:String) {
        if let commandTunnel = NSEntityDescription.insertNewObjectForEntityForName(kCommandTunnelEntity, inManagedObjectContext: CoreData.sharedInstance.managedObjectContext!) as? CommandTunnel {
            commandTunnel.command = command
            CoreData.sharedInstance.saveContext()
        }
    }
    
    static func wasCommandAvailable(command:String) -> Bool {
        let request = NSFetchRequest(entityName: kCommandTunnelEntity)
        if let allCommands = (try? CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as? [CommandTunnel] {
            for actCommand in allCommands {
                if actCommand.command == command {
                    CoreData.sharedInstance.managedObjectContext?.deleteObject(actCommand)
                    CoreData.sharedInstance.saveContext()
                    return true
                }
            }
        }
        return false
    }
}