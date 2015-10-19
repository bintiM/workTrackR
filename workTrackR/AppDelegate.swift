//
//  AppDelegate.swift
//  workTrackR
//
//  Created by Marc Bintinger on 25.08.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var connectivityHandler : ConnectivityHandler?
    var msg : NSString?
    var unassignedClient:Client = Client.getUnassignedClient()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UINavigationBar.appearance().barStyle = UIBarStyle.Default
        UINavigationBar.appearance().translucent = true
        UIView.appearance().tintColor = kColorStandard
        // UIView.appearance().backgroundColor = kColorBackground
        
        /*
        if WCSession.isSupported() {
            ConnectivityHandler.sharedInstance.
        } else {
            NSLog("WCSession not supported (f.e. on iPad).")
        }
        */
        // watch connectivityHandler
        
        //self.connectivityHandler?.addObserver(self, forKeyPath: "messages", options: NSKeyValueObservingOptions(), context: nil)
        ConnectivityHandler.sharedInstance.addObserver(self, forKeyPath: "msg", options: NSKeyValueObservingOptions(), context: nil)
        
        // iCloud Ordner erstellen
        
        if let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("Documents") {
            if (!NSFileManager.defaultManager().fileExistsAtPath(iCloudDocumentsURL.path!, isDirectory: nil)) {
                try! NSFileManager.defaultManager().createDirectoryAtURL(iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
            }
        }
        
        
        return true
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object === ConnectivityHandler.sharedInstance && keyPath == "msg" {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                print("fired")
                self.updateStatus()
            }
        }
    }
    
    func updateStatus() {
        
        let msg = ConnectivityHandler.sharedInstance.session.receivedApplicationContext["msg"]!
        let running : Bool = ConnectivityHandler.sharedInstance.session.receivedApplicationContext["running"]!.boolValue
        // let running = false
        

        if running {
            try! ConnectivityHandler.sharedInstance.session.updateApplicationContext(["msg" : "\(msg)", "running" : true])
            Assignment.createAssignmentForClientNow(self.unassignedClient, withDescription: "New Assignment")
        } else {
            try! ConnectivityHandler.sharedInstance.session.updateApplicationContext(["msg" : "\(msg)", "running" : false])
            Assignment.endPreviousAssignmentForClient(self.unassignedClient)
        }
       
        
    }

    /* dropbox zeug
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if DBSession.sharedSession().handleOpenURL(url) {
            if DBSession.sharedSession().isLinked() {
                NSNotificationCenter.defaultCenter().postNotificationName("didLinkToDropboxAccountNotification", object: nil)
                return true
            }
        }
        return false
    }
    */
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    
        CoreData.sharedInstance.saveContext()
        ConnectivityHandler.sharedInstance.removeObserver(self, forKeyPath: "msg")
    }

}