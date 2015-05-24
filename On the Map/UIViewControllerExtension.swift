//
//  UIViewControllerExtension.swift
//  On the Map
//
//  Created by Nick Cohen on 5/24/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(errorMessage: String) {
        var alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}