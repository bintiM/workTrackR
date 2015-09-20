//
//  ClientTableViewCell.swift
//  workTrackR
//
//  Created by Marc Bintinger on 29.08.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {

    var client:Client! {
        didSet {
            UIView.appearance().backgroundColor = kColorDarkGreen
            //nameButtonOutlet.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            nameButtonOutlet.titleLabel?.font = kFontThin
            nameButtonOutlet.setTitle(client.name, forState: .Normal)
        }
    }
    
    @IBOutlet weak var nameButtonOutlet: UIButton! {
        didSet {
            nameButtonOutlet.layer.cornerRadius = 6.0
            nameButtonOutlet.layer.borderColor = UIColor.lightGrayColor().CGColor
            nameButtonOutlet.layer.borderWidth = 1.0
            nameButtonOutlet.layer.backgroundColor = kColorDarkGreen.CGColor
        }
    }
    @IBOutlet weak var doneCircleImageViewOutlet: UIImageView!
    @IBAction func nameButtonAction(sender: AnyObject) {
        editClient(client)
    }
    
    func editClient(client:Client) {
        
        let title = NSLocalizedString("titleEditClientDialog", value: "Edit Client", comment: "titel in alert view controller")
        let placeholder = NSLocalizedString("placeholderEditClientDialog", value: "Client", comment: "placeholder for inputTextField in edit alert view controller")
        let message = NSLocalizedString("messageEditClientDialog", value: "Change your Clientname", comment: "message in edit alert view controller")
        let ok = NSLocalizedString("okButton", value: "Ok", comment: "ok Button Label")
        let cancel = NSLocalizedString("cancelButton", value: "Cancel", comment: "cancel button label")
        
        let dialog = bMHelper.singleTextFieldDialogWithTitle(title, message: message, placeholder: placeholder, textFieldValue: client.name, ok: ok, cancel: cancel) { [weak self] (text) -> Void in
            
            client.name = text
            CoreData.sharedInstance.saveContext()
        
        }
        
        viewController?.presentViewController(dialog, animated: true, completion: nil)
        
    }
    
}
