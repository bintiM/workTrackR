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
           
            // UIView.appearance().backgroundColor = kColorDarkGreen
            beginDateLabelOutlet.font = kFontThinSmall
            beginDateLabelOutlet.textColor = kColorStandard
            endDateLabelOutlet.font = kFontThinSmall
            endDateLabelOutlet.textColor = kColorStandard
            assignmentDescLabelOutlet.font = kFontThin
            assignmentDescLabelOutlet.textColor = kColorStandard

            
            assignmentDescLabelOutlet.text = assignment.desc
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "d.M. HH:mm:ss"

            if assignment.begin.timeIntervalSince1970.distanceTo(0.0) != 0.0 {
                beginDateLabelOutlet.text = dateFormatter.stringFromDate(assignment.begin)
            } else {
                beginDateLabelOutlet.text = "noch nicht begonnen"
            }
            if assignment.end.timeIntervalSince1970.distanceTo(0.0) != 0.0 {
                endDateLabelOutlet.text = dateFormatter.stringFromDate(assignment.end)
                endButtonOutlet.enabled = false
            } else {
                endDateLabelOutlet.text = "..."
                endButtonOutlet.enabled = true
            }
            

        }
    }
    @IBOutlet weak var endButtonOutlet: UIButton! {
        didSet {
            endButtonOutlet.setTitle("End", forState: .Normal)
        }
    }
/*
    @IBOutlet weak var nameButtonOutlet: UIButton! {
        didSet {
            nameButtonOutlet.layer.cornerRadius = 6.0
//            nameButtonOutlet.layer.borderColor = UIColor.lightGrayColor().CGColor
            nameButtonOutlet.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
            nameButtonOutlet.layer.borderWidth = 1.0
            nameButtonOutlet.layer.backgroundColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        }
    }
*/
    @IBOutlet weak var assignmentDescLabelOutlet: UILabel!
    @IBOutlet weak var beginDateLabelOutlet: UILabel!
    @IBOutlet weak var endDateLabelOutlet: UILabel!
    @IBOutlet weak var doneImageViewOutlet: UIImageView!
    @IBAction func nameButtonAction(sender: AnyObject) {
    }
    
    @IBAction func endButtonAction(sender: AnyObject) {
        assignment.end = NSDate()
        CoreData.sharedInstance.saveContext()
    }

    func enableEndButton() {
        endButtonOutlet.enabled = true
    }
    
    func disableEndButton() {
        endButtonOutlet.enabled = false
    }
    
}
