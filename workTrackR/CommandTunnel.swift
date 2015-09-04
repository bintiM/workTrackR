//
//  ComandTunnel.swift
//  workTrackR
//
//  Created by Marc Bintinger on 29.08.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import Foundation
import CoreData

@objc(CommandTunnel)
class CommandTunnel: NSManagedObject {

    @NSManaged var command: String

}
