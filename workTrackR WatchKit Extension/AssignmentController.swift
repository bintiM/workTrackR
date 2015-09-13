//
//  AssignmentController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 07.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class AssignmentControllerContext {
    var client:Client!
}

class AssignmentController: WKInterfaceController {
    
    private var commandTunnelTimer:NSTimer!
    
    private var client:Client! {
        didSet {
            setTitle(client.name)
            reloadData()
        }
    }

    @IBOutlet weak var tableOutlet: WKInterfaceTable!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        if let context = context as? AssignmentControllerContext {
            client = context.client
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        reloadData()
        
        CommandTunnel.deleteAllCommands()
        
        commandTunnelTimer?.invalidate()
        commandTunnelTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "checkCommand", userInfo: nil, repeats: true)

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        commandTunnelTimer?.invalidate()
        super.didDeactivate()
    }

    func checkCommand() {
        if CommandTunnel.wasCommandAvailable(kChangedData) {
            CoreData.sharedInstance.managedObjectContext?.reset()
            
            if let existingClient = CoreData.managedObjectByURI(client.objectID.URIRepresentation()) as? Client {
                reloadData()
            } else { // if client deleted -> go back
                popController()
            }

        }
    }
    
    
    func reloadData() {

        let request = NSFetchRequest(entityName: kAssignmentEntity)
        request.predicate = NSPredicate(format: "client == %@", self.client)
        // request.sortDescriptors = [NSSortDescriptor(key: kClientOrder, ascending: true)]
        
        if let allAssignments = CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: nil) as? [Assignment] {
            tableOutlet.setNumberOfRows(allAssignments.count, withRowType: kAssignmentRow)
            for (index, assignment) in enumerate(allAssignments) {
                if let assignmentRow = tableOutlet.rowControllerAtIndex(index) as? AssignmentRow {
                    assignmentRow.assignment = assignment
                }
            }
        }
    }


}
