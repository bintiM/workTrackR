//
//  UIView+Extension.swift
//  workTrackR
//
//  Created by Marc Bintinger on 30.08.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import UIKit

extension UIView {

    var viewController:UIViewController? {
        return traverseResponderChainToFindViewController()
    }
    
    private func traverseResponderChainToFindViewController() -> UIViewController? {
        if let responder = nextResponder() as? UIViewController {
            return responder
        }
        if let responder = nextResponder() as? UIView {
            return responder.traverseResponderChainToFindViewController()
        }
        return nil
    }
}