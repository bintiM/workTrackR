//
//  bMCheckCircle.swift
//  workTrackR
//
//  Created by Marc Bintinger on 04.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import UIKit

class bMCheckCircle {
    
    static func checkCircle (checked:Bool, radius:CGFloat, lineWidth:CGFloat = 1.0, uncheckedBackgroudColor:UIColor = UIColor.lightGrayColor(), checkedBackgroundColor:UIColor = UIColor.greenColor(), strokeColor:UIColor = UIColor.blackColor()) -> UIImage {
        
        let center = CGPointMake(radius, radius)
        let size = CGSizeMake(2 * radius, 2 * radius)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius - lineWidth, startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true)
        circlePath.lineWidth = lineWidth

        (checked ? checkedBackgroundColor : uncheckedBackgroudColor).setFill()
        
        
        strokeColor.setStroke()
        circlePath.fill()
        circlePath.stroke()
        
        if checked {
            let checkMark = "√" as NSString
            let fontAttributes = [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(radius * 1.7),
                NSForegroundColorAttributeName : strokeColor
            ]
            checkMark.drawAtPoint(CGPointMake(radius/5, -radius/6), withAttributes: fontAttributes)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
