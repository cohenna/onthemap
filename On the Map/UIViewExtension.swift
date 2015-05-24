//
//  UIViewExtension.swift
//  On the Map
//
//  Created by Nick Cohen on 5/22/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func shakeView(view: UIView?) {
        UIView.shakeView(view, direction: 1, shakes: 0, duration: 0.03, maxShakes: 10)
    }
    
    class func shakeView(view: UIView?, direction: Int, shakes: Int, duration: Double, maxShakes: Int) {
        if let view = view {
            UIView.animateWithDuration(duration, animations: { () in
                view.transform = CGAffineTransformMakeTranslation(CGFloat(5*direction), 0.0)
                }, completion: {
                    (finished: Bool) in
                    if(shakes >= maxShakes)
                    {
                        view.transform = CGAffineTransformIdentity;
                        return;
                    }
                    self.shakeView(view, direction: direction*(-1), shakes: shakes + 1, duration: duration, maxShakes: maxShakes);
            })
        } else {
            println("error in shakeView")
        }
    }
}