//
//  ConnectivityManager.swift
//  workTrackR
//
//  Created by Marc Bintinger on 15.10.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import Foundation
import WatchConnectivity

private var sharedConnectivityHandler = ConnectivityHandler()

class ConnectivityHandler : NSObject, WCSessionDelegate {
    
    // MARK: - Singleton
    class var sharedInstance:ConnectivityHandler {
        return sharedConnectivityHandler
    }
    
    var unassignedClient:Client = Client.getUnassignedClient()
    
    var session = WCSession.defaultSession()
    var messages = [String]() {
        // fire KVO-updates for Swift property
        willSet { willChangeValueForKey("messages") }
        didSet  { didChangeValueForKey("messages") }
    }
    
    var running:Bool = false
    var date:NSDate = NSDate()
    var msg:NSString = "" {
        willSet { willChangeValueForKey("msg") }
        didSet  { didChangeValueForKey("msg") }
    }
    
    
    private override init() {
        super.init()
        session.delegate = self
        session.activateSession()
        
        NSLog("%@", "Paired Watch: \(session.paired), Watch App Installed: \(session.watchAppInstalled)")
    }
    
    // MARK: - WCSessionDelegate
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //handle received message
        let status = message["status"] as? String

        if (status == "startAssignment") {

            dispatch_async(dispatch_get_main_queue()) {
                print("create Assignment \(status)")
                Assignment.createAssignmentForClientNow(self.unassignedClient, withDescription: "New Assignment")
            }
            //send a reply
            replyHandler(["status":"Assignment running"])

            
        } else if status == "endAssignment" {

            dispatch_async(dispatch_get_main_queue()) {
                print("end Assignment \(status)")
                Assignment.endPreviousAssignmentForClient(self.unassignedClient)
            }
            //send a reply
            replyHandler(["status":"Assignment ended"])

            
        } else {
            //future status types
        }
        
        
        
    }
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        self.msg = applicationContext["msg"]! as! NSString
        self.running = applicationContext["running"]! as! Bool
        self.date = applicationContext["date"]! as! NSDate
        
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        let msg = userInfo["msg"]!
        self.messages.append("UserInfo \(msg)")
    }
    
}
