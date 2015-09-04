//
//  ClientController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 04.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class ClientController: WKInterfaceController {

    private var commandTunnelTimer:NSTimer!
    
    @IBOutlet weak var tableOutlet: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        reloadData()
        commandTunnelTimer?.invalidate()
        commandTunnelTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "checkCommand", userInfo: nil, repeats: true)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        commandTunnelTimer?.invalidate()
        super.didDeactivate()
    }

    func checkCommand() {
        if CommandTunnel.wasCommandAvailable(kPhoneChangedData) {
            reloadData()
        }
    }
    
    func reloadData() {
        CoreData.sharedInstance.managedObjectContext?.reset()
        let request = NSFetchRequest(entityName: kClient)
        request.sortDescriptors = [NSSortDescriptor(key: kClientOrder, ascending: true)]
        if let allClients = CoreData.sharedInstance.managedObjectContext?.executeFetchRequest(request, error: nil) as? [Client] {
            tableOutlet.setNumberOfRows(allClients.count, withRowType: kClientRow)
            for (index, client) in enumerate(allClients) {
                if let clientRow = tableOutlet.rowControllerAtIndex(index) as? ClientRow {
                    clientRow.client = client
                }
            }
        }
    }
    
}