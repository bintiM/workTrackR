//
//  SelectClientTableViewCell.swift
//  workTrackR
//
//  Created by Marc Bintinger on 11.10.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import UIKit

class SelectClientTableViewCell: UITableViewCell {

    var client:Client! {
        didSet {
            
            //nameButtonOutlet.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            //nameButtonOutlet.titleLabel?.font = kFontThin
            // nameButtonOutlet.setTitle(client.name, forState: .Normal)
            
            
            clientNameLabelOutlet.text = client.name
            clientNameLabelOutlet.textColor = client.getUIColor()
        }
    }
    
    @IBOutlet weak var clientNameLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // self.backgroundColor = kColor1
    }

}
