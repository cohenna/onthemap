//
//  EnterLocationViewController.swift
//  On the Map
//
//  Created by Nick Cohen on 5/23/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

var DEFAULT_LOCATION_TEXT = "Enter Location"

class EnterLocationViewController : UIViewController, UITextFieldDelegate {
    
    var udacityUser : UdacityUser?
    var studentLocation : StudentLocation?
    var originalStudentLocation : StudentLocation?
    
    @IBOutlet weak var locationText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEnterUrl" {
            (segue.destinationViewController as! EnterUrlViewController).udacityUser = self.udacityUser
            (segue.destinationViewController as! EnterUrlViewController).studentLocation = self.studentLocation
            (segue.destinationViewController as! EnterUrlViewController).locationText = self.locationText.text
            (segue.destinationViewController as! EnterUrlViewController).originalStudentLocation = self.originalStudentLocation
        }
    }
    
    func segueToEnterUrl() {
        //dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("showEnterUrl", sender: self)
        //})
    }
    
    func geoCode() {
        var geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationText!.text, completionHandler: {
            (result: [AnyObject]!, error: NSError!) in
            //println("test")
            if let error = error {
                // show error
                self.showErrorAlert("Please Enter a Valid Location")
            } else {
                if result.count == 0 {
                    // show error
                    self.showErrorAlert("Please Enter a Valid Location")
                } else {
                    var placemark = result[0] as! CLPlacemark
                    
                    
                    var sl = StudentLocation()
                    sl.latitude = placemark.location.coordinate.latitude
                    sl.longitude = placemark.location.coordinate.longitude
                    sl.firstName = self.udacityUser!.firstName
                    sl.lastName = self.udacityUser!.lastName
                    sl.mapString = self.locationText.text
                    sl.uniqueKey = self.udacityUser!.uniqueKey
                    self.studentLocation = sl
                    
                    self.segueToEnterUrl()
                }
            }
        })

    }
    
    @IBAction func findOnTheMap(sender: UIButton) {
        if locationText.text == DEFAULT_LOCATION_TEXT || locationText.text == "" {
            // alert
            self.showErrorAlert("Please Enter a Valid Location")

        } else {
            //segueToEnterUrl()
            geoCode()
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.text == DEFAULT_LOCATION_TEXT {
            textField.text = ""
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if locationText.isFirstResponder() {
            println("navigation height: \(self.navigationController!.navigationBar.frame.size.height)")
            self.view.frame.origin.y -= getKeyboardHeight(notification) - self.navigationController!.navigationBar.frame.size.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if locationText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification) - self.navigationController!.navigationBar.frame.size.height
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}