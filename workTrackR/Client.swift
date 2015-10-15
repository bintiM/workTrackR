//
//  Client.swift
//  workTrackR
//
//  Created by Marc Bintinger on 29.08.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import Foundation
import CoreData

@objc(Client)
class Client: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var order: NSNumber
    @NSManaged var color: NSData
    @NSManaged var assignments: NSSet
    
}
