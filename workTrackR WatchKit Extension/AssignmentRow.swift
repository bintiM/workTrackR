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
        }
    }
    @IBOutlet weak var nameLabelOutlet: WKInterfaceLabel!
}
