//
//  AssignmentRow.swift
//  workTrackR
//
//  Created by Marc Bintinger on 07.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import WatchKit

class AssignmentRow: NSObject {
   
    var assignment:Assignment! {
        didSet {
            nameLabelOutlet.setText(assignment.desc)
            doneButtonOutlet.setBackgroundImage(bMCheckCircle.checkCircle(assignment.running.boolValue, radius: 15, lineWidth: 2))
        }
    }
    @IBOutlet weak var nameLabelOutlet: WKInterfaceLabel!
    @IBOutlet weak var doneButtonOutlet: WKInterfaceButton!
    @IBAction func doneButtonAction() {
        if let exisistingAssignemnt = CoreData.managedObjectByURI(assignment.objectID.URIRepresentation()) as? Assignment {
            //set to start or stop
            exisistingAssignemnt.switchState()
            assignment = exisistingAssignemnt
            CommandTunnel.addCommand(kChangedData)
        }
    }
}
