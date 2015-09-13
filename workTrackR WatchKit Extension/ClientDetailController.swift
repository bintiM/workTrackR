//
//  ClientDetailController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 10.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import WatchKit
import Foundation


class ClientDetailController: WKInterfaceController {

    @IBOutlet weak var clientTitleLabelOutlet: WKInterfaceLabel!
    @IBOutlet weak var clientNameLabelOutlet: WKInterfaceLabel!
    @IBOutlet weak var assignmentTitleLabelOutlet: WKInterfaceLabel!
    @IBOutlet weak var quantityLabelOutlet: WKInterfaceLabel!
    @IBOutlet weak var quantityValueLabelOutlet: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
