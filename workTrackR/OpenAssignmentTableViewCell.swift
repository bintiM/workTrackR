//
//  OpenAssignmentTableViewCell.swift
//  workTrackR
//
//  Created by Marc Bintinger on 05.10.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import UIKit

class OpenAssignmentTableViewCell: UITableViewCell {

    var assignment:Assignment! {
        didSet {
            
//            assignmentDescriptionOutlet.font = kFontThin
//            assignmentDescriptionOutlet.textColor = kColorStandard
            
            
            assignmentDescriptionOutlet.text = assignment.desc
            /*
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
            */
            
        }
    }
    @IBOutlet weak var assignmentDescriptionOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
