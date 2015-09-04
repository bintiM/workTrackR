//
//  ClientRow.swift
//  workTrackR
//
//  Created by Marc Bintinger on 04.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import UIKit
import WatchKit

class ClientRow: NSObject {
    var client:Client! {
        didSet {
            nameLabelOutlet.setText(client.name)
        }
    }
   
    @IBOutlet weak var nameLabelOutlet: WKInterfaceLabel!
}
