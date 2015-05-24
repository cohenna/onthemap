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
    
    var udacityUser : UdacityUser?
    var originalStudentLocation : StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEnterLocation" {
            (segue.destinationViewController as! EnterLocationViewController).udacityUser = self.udacityUser
            (segue.destinationViewController as! EnterLocationViewController).originalStudentLocation = self.originalStudentLocation
        }
    }
    
    func segueToEnterLocation() {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("showEnterLocation", sender: self)
        })
    }
    
    @IBAction func enterLocation(sender: UIBarButtonItem) {
        // check whether user has a StudentLocation
        PulseClient.sharedInstance().getStudentLocations(self.udacityUser!.uniqueKey, limit : nil, offset : nil, allowDuplicates: true) {
            (result : [StudentLocation]?, error) in
            if let result = result {
                if result.count >= 1 {
                    self.originalStudentLocation = result[0]
                    /*var alert = UIAlertController(title: nil, message: "You have already posted a location.  Would you like to overwrite your previously posted location?", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    */
                    /*
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                    message:@"This is an alert."
                    preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];*/
                    
                    var alert = UIAlertController(title: nil, message: "You have already posted a location.  Would you like to overwrite your previously posted location?", preferredStyle: UIAlertControllerStyle.ActionSheet)
                    alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: {
                        (action : UIAlertAction!) in
                        self.segueToEnterLocation()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)


                } else {
                    self.segueToEnterLocation()
                }
            }
            //(result: [StudentLocation]?, error: NSError?) in
            //println("")
            println("test")
        }
    }
}