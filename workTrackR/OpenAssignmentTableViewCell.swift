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
            
            assignmentDescriptionOutlet.text = assignment.desc

            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "d.M. HH:mm:ss"
            dateFormatter.dateFormat = "HH:mm:ss"
            
            if assignment.begin.timeIntervalSince1970.distanceTo(0.0) != 0.0 {
                beginDateLabelOutlet.text = dateFormatter.stringFromDate(assignment.begin)
            } else {
                beginDateLabelOutlet.text = "noch nicht begonnen"
            }
            if assignment.end.timeIntervalSince1970.distanceTo(0.0) != 0.0 {
                endDateLabelOutlet.text = dateFormatter.stringFromDate(assignment.end)
                assignmentDescriptionOutlet.textColor = kColorVeryLightGray
                beginDateLabelOutlet.textColor = kColorVeryLightGray
                runningSinceLabelOutlet.textColor = kColorVeryLightGray
                endDateLabelOutlet.textColor = kColorVeryLightGray
                endedAtLabelOutlet.textColor = kColorVeryLightGray
            } else {
                endedAtLabelOutlet.text = "Duration"
                let durationMin = round(-assignment.begin.timeIntervalSinceNow/60)
                endDateLabelOutlet.text = String(Int(durationMin)) + " min."
                
            }
            
            // self.contentView.backgroundColor = assignment.client.getUIColor()
            colorButtonOutlet.backgroundColor = assignment.client.getUIColor()
        }
    }
    @IBOutlet weak var assignmentDescriptionOutlet: UILabel!
    @IBOutlet weak var runningSinceLabelOutlet: UILabel!
    @IBOutlet weak var beginDateLabelOutlet: UILabel!
    @IBOutlet weak var endedAtLabelOutlet: UILabel!
    @IBOutlet weak var endDateLabelOutlet: UILabel!
    
    @IBOutlet weak var colorButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
