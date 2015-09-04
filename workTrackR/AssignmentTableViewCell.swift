//
//  AssigmentTableViewCell.swift
//  workTrackR
//
//  Created by Marc Bintinger on 03.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    
    
    var assignment:Assignment! {
        didSet {
            nameButtonOutlet.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            
            nameButtonOutlet.setTitle(assignment.desc, forState: .Normal)
            let width = doneImageViewOutlet.bounds.size.width
            let height = doneImageViewOutlet.bounds.size.height
            doneImageViewOutlet.image = bMCheckCircle.checkCircle(assignment.done.boolValue, radius: width/2.0, lineWidth: 2.0)
        }
    }
    @IBOutlet weak var nameButtonOutlet: UIButton! {
        didSet {
            nameButtonOutlet.layer.cornerRadius = 6.0
            nameButtonOutlet.layer.borderColor = UIColor.lightGrayColor().CGColor
            nameButtonOutlet.layer.borderWidth = 1.0
            nameButtonOutlet.layer.backgroundColor = UIColor(white: 0.95, alpha: 1.0).CGColor
        }
    }

    @IBOutlet weak var doneImageViewOutlet: UIImageView!
    @IBAction func nameButtonAction(sender: AnyObject) {
    }

    func enableNameButton() {
        nameButtonOutlet.enabled = true
    }
    
    func disableNameButton() {
        nameButtonOutlet.enabled = false
    }
    
    
}
