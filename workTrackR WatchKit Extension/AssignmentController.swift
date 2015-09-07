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
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func reloadData() {
        CoreData.sharedInstance.managedObjectContext?.reset()
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
