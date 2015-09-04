//
//  Assignment.swift
//  workTrackR
//
//  Created by Marc Bintinger on 29.08.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import Foundation
import CoreData

@objc(Assignment)
class Assignment: NSManagedObject {

    @NSManaged var done: NSNumber
    @NSManaged var desc: String
    @NSManaged var begin: NSDate
    @NSManaged var end: NSDate
    @NSManaged var client: Client

}
