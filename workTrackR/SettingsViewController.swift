//
//  SettingsViewController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 21.09.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTitleLabelOutlet: UILabel!
    @IBOutlet weak var dropboxTitleLabelOutlet: UILabel!
    @IBOutlet weak var connectDropboxOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        self.view.backgroundColor = kColorDarkGreen
/*
        //dropbox stuff
        let appKey = "rt7ui8v0otd1odj"
        let appSecret = "ux2okmzfd5nnrlf"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDidLinkNotification:", name: "didLinkToDropboxAccountNotification", object: nil)
        
        let dropboxSession = DBSession(appKey: appKey, appSecret: appSecret, root: kDBRootAppFolder)
        DBSession.setSharedSession(dropboxSession)
        
        if DBSession.sharedSession().isLinked() {
            connectDropboxOutlet.setTitle("Disconnect", forState: .Normal)
        }
*/
        

       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectDropboxAction(sender: AnyObject) {
/*
        if !DBSession.sharedSession().isLinked() {
            DBSession.sharedSession().linkFromController(self)
        }
        else {
            DBSession.sharedSession().unlinkAll()
            connectDropboxOutlet.setTitle("connect", forState: .Normal)
        }
*/
    }
    
    func handleDidLinkNotification(notification: NSNotification) {
/*
        connectDropboxOutlet.setTitle("Disconnect", forState: .Normal)
*/
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func prepareCSVFile() -> String {

        var csvData:String!
        
        return ""
    }
}
