//
//  AboutViewController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 21.09.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTitleLabelOutlet: UILabel!
    @IBOutlet weak var messagesLabelOutlet: UILabel!
    
    var msg : NSString?
    var connectivityHandler : ConnectivityHandler!
    var counter = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "About"
        aboutTitleLabelOutlet.text = "test"

        counter = 0
        self.view.backgroundColor = kColorBackground
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateAppContextAction(sender: AnyObject) {
        try! connectivityHandler.session.updateApplicationContext(["msg" : "Message \(++counter)", "running" : true])
        print("set appContext to running")
    }

    @IBAction func transferUserInfoAction(sender: AnyObject) {
        try! connectivityHandler.session.updateApplicationContext(["msg" : "Message \(++counter)", "running" : false])
        print("set appContext to stop")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
