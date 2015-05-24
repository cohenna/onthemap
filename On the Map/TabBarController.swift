//
//  TabBarController.swift
//  On the Map
//
//  Created by Nick Cohen on 5/23/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation
import UIKit

class TabBarController : UITabBarController {
    
    var currentOffset : Int = 0
    
    @IBOutlet weak var enterLocationButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.viewControllers![1] as! UIViewController).tabBarItem = UITabBarItem(title: "List", image: UIImage(), tag: 0)
        
        objc_sync_enter((UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations)
        if (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations.count == 0 {
            ParseClient.sharedInstance().getStudentLocations(nil,  limit: 10,  offset: 0, allowDuplicates: false, completionHandler: { (result : [StudentLocation]?, error) in
                println("tabbarcontroller count=\(result!.count)")
                for studentLocation in result! {
                    (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations.append(studentLocation)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.selectedViewController!.refreshData()
                })
                objc_sync_exit((UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations)

            })
        } else {
            objc_sync_exit((UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations)
        }
    }
        
    func segueToEnterLocation() {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("showEnterLocation", sender: self)
        })
    }
    
    @IBAction func enterLocation(sender: UIBarButtonItem) {
        // check whether user has a StudentLocation
        enterLocationButton.enabled = false
        ParseClient.sharedInstance().getStudentLocations((UIApplication.sharedApplication().delegate as! AppDelegate).udacityUser!.uniqueKey, limit : nil, offset : nil, allowDuplicates: true) {
            (result : [StudentLocation]?, error) in
            self.enterLocationButton.enabled = true
            if let result = result {
                if result.count >= 1 {
                    var alert = UIAlertController(title: nil, message: "You have already posted a location.  Would you like to overwrite your previously posted location?", preferredStyle: UIAlertControllerStyle.ActionSheet)
                    alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: {
                        (action : UIAlertAction!) in
                        (UIApplication.sharedApplication().delegate as! AppDelegate).originalStudentLocation = result[0]
                        self.segueToEnterLocation()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
                        (action : UIAlertAction!) in
                        
                        
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)


                } else {
                    self.segueToEnterLocation()
                }
            }
        }
    }
}