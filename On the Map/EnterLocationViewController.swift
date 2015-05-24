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
    
    var studentLocation : StudentLocation?
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var locationText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationText.delegate = self
        
        if let studentLocation = (UIApplication.sharedApplication().delegate as! AppDelegate).originalStudentLocation {
            if let mapString = studentLocation.mapString {
                locationText.text = mapString
            }
        }
        
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
            (segue.destinationViewController as! EnterUrlViewController).studentLocation = self.studentLocation
            (segue.destinationViewController as! EnterUrlViewController).locationText = self.locationText.text
        }
    }
    
    func segueToEnterUrl() {
        self.performSegueWithIdentifier("showEnterUrl", sender: self)
    }
    
    func geoCode() {
        var geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationText!.text, completionHandler: {
            (result: [AnyObject]!, error: NSError!) in
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
                    sl.firstName = (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUser!.firstName
                    sl.lastName = (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUser!.lastName
                    sl.mapString = self.locationText.text
                    sl.uniqueKey = (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUser!.uniqueKey
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
    
    override func keyboardWillShow(notification: NSNotification) {
        if locationText.isFirstResponder() {
            println("navigation height: \(self.navigationController!.navigationBar.frame.size.height)")
            self.view.frame.origin.y -= getKeyboardHeight(notification) - self.navigationController!.navigationBar.frame.size.height
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        if locationText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification) - self.navigationController!.navigationBar.frame.size.height
        }
    }
}