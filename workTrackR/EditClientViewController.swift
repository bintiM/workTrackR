//
//  EditClientViewController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 11.10.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import UIKit

extension UIButton {
    override public var enabled: Bool {
        didSet {
            if enabled {
                self.layer.borderColor = UIColor.blackColor().CGColor
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
}

class EditClientViewController: UIViewController {

    var client:Client! {
        didSet {
            title = client.name
        }
    }
    
    @IBOutlet weak var clientNameTextField: UITextField!
    
    @IBOutlet weak var colorButtonOutlet1: UIButton!
    @IBOutlet weak var colorButtonOutlet2: UIButton!
    @IBOutlet weak var colorButtonOutlet3: UIButton!
    @IBOutlet weak var colorButtonOutlet4: UIButton!
    @IBOutlet weak var colorButtonOutlet5: UIButton!
    @IBOutlet weak var colorButtonOutlet6: UIButton!
    @IBOutlet weak var colorButtonOutlet7: UIButton!
    @IBOutlet weak var colorButtonOutlet8: UIButton!
    @IBOutlet weak var colorButtonOutlet9: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kColorBackground
        
        colorButtonOutlet1.backgroundColor = kColor1
        colorButtonOutlet2.backgroundColor = kColor2
        colorButtonOutlet3.backgroundColor = kColor3
        colorButtonOutlet4.backgroundColor = kColor4
        colorButtonOutlet5.backgroundColor = kColor5
        colorButtonOutlet6.backgroundColor = kColor6
        colorButtonOutlet7.backgroundColor = kColor7
        colorButtonOutlet8.backgroundColor = kColor8
        colorButtonOutlet9.backgroundColor = kColor9
        
        clientNameTextField.text = client.name
        clientNameTextField.textColor = client.getUIColor()

 
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
    
    
    @IBAction func colorButtonAction1(sender: AnyObject) {
        client.setUIColor(kColor1)
        clientNameTextField.textColor = kColor1
        colorButtonOutlet1.layer.borderWidth = 1.5
        colorButtonOutlet2.layer.borderWidth = 0
        colorButtonOutlet3.layer.borderWidth = 0
        colorButtonOutlet4.layer.borderWidth = 0
        colorButtonOutlet5.layer.borderWidth = 0
        colorButtonOutlet6.layer.borderWidth = 0
        colorButtonOutlet7.layer.borderWidth = 0
        colorButtonOutlet8.layer.borderWidth = 0
        colorButtonOutlet9.layer.borderWidth = 0
    }
    
    @IBAction func colorButtonAction2(sender: AnyObject) {
        client.setUIColor(kColor2)
        clientNameTextField.textColor = kColor2
        colorButtonOutlet1.layer.borderWidth = 0
        colorButtonOutlet2.layer.borderWidth = 1.5
        colorButtonOutlet3.layer.borderWidth = 0
        colorButtonOutlet4.layer.borderWidth = 0
        colorButtonOutlet5.layer.borderWidth = 0
        colorButtonOutlet6.layer.borderWidth = 0
        colorButtonOutlet7.layer.borderWidth = 0
        colorButtonOutlet8.layer.borderWidth = 0
        colorButtonOutlet9.layer.borderWidth = 0
    }
    
    @IBAction func colorButtonAction3(sender: AnyObject) {
        client.setUIColor(kColor3)
        clientNameTextField.textColor = kColor3
        colorButtonOutlet1.layer.borderWidth = 0
        colorButtonOutlet2.layer.borderWidth = 0
        colorButtonOutlet3.layer.borderWidth = 1.5
        colorButtonOutlet4.layer.borderWidth = 0
        colorButtonOutlet5.layer.borderWidth = 0
        colorButtonOutlet6.layer.borderWidth = 0
        colorButtonOutlet7.layer.borderWidth = 0
        colorButtonOutlet8.layer.borderWidth = 0
        colorButtonOutlet9.layer.borderWidth = 0

    }
    
    @IBAction func colorButtonAction4(sender: AnyObject) {
        client.setUIColor(kColor4)
        clientNameTextField.textColor = kColor4
        colorButtonOutlet1.layer.borderWidth = 0
        colorButtonOutlet2.layer.borderWidth = 0
        colorButtonOutlet3.layer.borderWidth = 0
        colorButtonOutlet4.layer.borderWidth = 1.5
        colorButtonOutlet5.layer.borderWidth = 0
        colorButtonOutlet6.layer.borderWidth = 0
        colorButtonOutlet7.layer.borderWidth = 0
        colorButtonOutlet8.layer.borderWidth = 0
        colorButtonOutlet9.layer.borderWidth = 0

    }
    
    @IBAction func colorButtonAction5(sender: AnyObject) {
        client.setUIColor(kColor5)
        clientNameTextField.textColor = kColor5
        colorButtonOutlet1.layer.borderWidth = 0
        colorButtonOutlet2.layer.borderWidth = 0
        colorButtonOutlet3.layer.borderWidth = 0
        colorButtonOutlet4.layer.borderWidth = 0
        colorButtonOutlet5.layer.borderWidth = 1.5
        colorButtonOutlet6.layer.borderWidth = 0
        colorButtonOutlet7.layer.borderWidth = 0
        colorButtonOutlet8.layer.borderWidth = 0
        colorButtonOutlet9.layer.borderWidth = 0

    }
    
    @IBAction func colorButtonAction6(sender: AnyObject) {
        client.setUIColor(kColor6)
        clientNameTextField.textColor = kColor6
        colorButtonOutlet1.layer.borderWidth = 0
        colorButtonOutlet2.layer.borderWidth = 0
        colorButtonOutlet3.layer.borderWidth = 0
        colorButtonOutlet4.layer.borderWidth = 0
        colorButtonOutlet5.layer.borderWidth = 0
        colorButtonOutlet6.layer.borderWidth = 1.5
        colorButtonOutlet7.layer.borderWidth = 0
        colorButtonOutlet8.layer.borderWidth = 0
        colorButtonOutlet9.layer.borderWidth = 0

    }
    
    @IBAction func colorButtonAction7(sender: AnyObject) {
        client.setUIColor(kColor7)
        clientNameTextField.textColor = kColor7
        colorButtonOutlet1.layer.borderWidth = 0
        colorButtonOutlet2.layer.borderWidth = 0
        colorButtonOutlet3.layer.borderWidth = 0
        colorButtonOutlet4.layer.borderWidth = 0
        colorButtonOutlet5.layer.borderWidth = 0
        colorButtonOutlet6.layer.borderWidth = 0
        colorButtonOutlet7.layer.borderWidth = 1.5
        colorButtonOutlet8.layer.borderWidth = 0
        colorButtonOutlet9.layer.borderWidth = 0

    }
    
    @IBAction func colorButtonAction8(sender: AnyObject) {
        client.setUIColor(kColor8)
        clientNameTextField.textColor = kColor8
        colorButtonOutlet1.layer.borderWidth = 0
        colorButtonOutlet2.layer.borderWidth = 0
        colorButtonOutlet3.layer.borderWidth = 0
        colorButtonOutlet4.layer.borderWidth = 0
        colorButtonOutlet5.layer.borderWidth = 0
        colorButtonOutlet6.layer.borderWidth = 0
        colorButtonOutlet7.layer.borderWidth = 0
        colorButtonOutlet8.layer.borderWidth = 1.5
        colorButtonOutlet9.layer.borderWidth = 0

    }
    
    @IBAction func colorButtonAction9(sender: AnyObject) {
        client.setUIColor(kColor9)
        clientNameTextField.textColor = kColor9
        colorButtonOutlet1.layer.borderWidth = 0
        colorButtonOutlet2.layer.borderWidth = 0
        colorButtonOutlet3.layer.borderWidth = 0
        colorButtonOutlet4.layer.borderWidth = 0
        colorButtonOutlet5.layer.borderWidth = 0
        colorButtonOutlet6.layer.borderWidth = 0
        colorButtonOutlet7.layer.borderWidth = 0
        colorButtonOutlet8.layer.borderWidth = 0
        colorButtonOutlet9.layer.borderWidth = 1.5

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
