//
//  InterfaceController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 04.10.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session : WCSession?
    var counter = 0
    
    @IBOutlet var statusLabelOutlet: WKInterfaceLabel!
    @IBOutlet var endAssignmentButtonOutlet: WKInterfaceButton!
    @IBOutlet var startAssignmentButtonOutlet: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        statusLabelOutlet.setText("Test")
        
        endAssignmentButtonOutlet.setHidden(true)
        
    }
    
    override func willActivate() {

        super.willActivate()
        
        
        session = WCSession.defaultSession()
        session?.delegate = self
        session?.activateSession()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
   
    @IBAction func endAssignmentAction() {
        try! session!.updateApplicationContext(["msg" : "End Assignment", "running" : false])
    }
    
    @IBAction func startAssignmentAction() {
        try! session!.updateApplicationContext(["msg" : "Start Assignment", "running" : true])
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let msg = applicationContext["msg"]!
        let running : Bool = applicationContext["running"] as! Bool
        // let running = false
        
        statusLabelOutlet.setText("\(msg)")
 
        if running {
            startAssignmentButtonOutlet.setHidden(true)
            endAssignmentButtonOutlet.setHidden(false)

        } else {
            endAssignmentButtonOutlet.setHidden(true)
            startAssignmentButtonOutlet.setHidden(false)
        }
    }
    
}
