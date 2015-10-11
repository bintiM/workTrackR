//
//  EditClientViewController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 11.10.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import UIKit

class EditClientViewController: UIViewController {

    var client:Client! {
        didSet {
            title = client.name
        }
    }
    
    @IBOutlet weak var clientNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientNameTextField.text = client.name

 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        //save data
        client.name = clientNameTextField.text!
        CoreData.sharedInstance.saveContext()
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
