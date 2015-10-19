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
        
        // session?.applicationContext.
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
   
    @IBAction func endAssignmentAction() {
        
        let messageToSend = ["status":"endAssignment"]
        session!.sendMessage(messageToSend, replyHandler: { replyMessage in
            //handle and present the message on screen
            let value = replyMessage["status"] as? String
            self.statusLabelOutlet.setText(value)
            self.endAssignmentButtonOutlet.setHidden(true)
            self.startAssignmentButtonOutlet.setHidden(false)
            }, errorHandler: {error in
                // catch any errors here
                print(error)
        })
        
        
        //try! session!.updateApplicationContext(["msg" : "End Assignment", "running" : false, "date" : NSDate()])
    }
    
    @IBAction func startAssignmentAction() {

        let messageToSend = ["status":"startAssignment"]
        session!.sendMessage(messageToSend, replyHandler: { replyMessage in
            //handle and present the message on screen
            let value = replyMessage["status"] as? String
            self.statusLabelOutlet.setText(value)
            self.startAssignmentButtonOutlet.setHidden(true)
            self.endAssignmentButtonOutlet.setHidden(false)
            }, errorHandler: {error in
                // catch any errors here
                print(error)
        })
        
        // try! session!.updateApplicationContext(["msg" : "Start Assignment", "running" : true, "date" : NSDate()] )
    }
    /*
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let running : Bool = applicationContext["running"] as! Bool
 
        if running {
            startAssignmentButtonOutlet.setHidden(true)
            endAssignmentButtonOutlet.setHidden(false)
            statusLabelOutlet.setText("Ass. running")
        } else {
            endAssignmentButtonOutlet.setHidden(true)
            startAssignmentButtonOutlet.setHidden(false)
            statusLabelOutlet.setText("No Assignment")
        }
    }
*/
}
