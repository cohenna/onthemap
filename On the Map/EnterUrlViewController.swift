//
//  EnterUrlViewController.swift
//  On the Map
//
//  Created by Nick Cohen on 5/23/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

var DEFAULT_URL_TEXT = "Enter URL"
class EnterUrlViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var udacityUser : UdacityUser?
    var studentLocation : StudentLocation?
    var originalStudentLocation : StudentLocation?
    var locationText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
                
    }
    
    override func viewWillAppear(animated: Bool) {
        map.removeAnnotations(map.annotations)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.zoomToLocation()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.text == DEFAULT_URL_TEXT {
            textField.text = ""
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    func zoomToLocation() {
        if let studentLocation = studentLocation {
            var point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude!, longitude: studentLocation.longitude!)
            point.title = studentLocation.firstName! + " " + studentLocation.lastName!
            //point.subtitle = studentLocation.mediaURL!
            self.map.addAnnotation(point)
            
            var region = MKCoordinateRegion()
            region.center.latitude = studentLocation.latitude!
            region.center.longitude = studentLocation.longitude!
            region.span = MKCoordinateSpanMake(0.00725, 0.00725)
            self.map.setRegion(region, animated: true)
        }
    }
    
    func postLocation() {
        if let originalStudentLocation = originalStudentLocation {
            // update current location
        } else {
            // add new location
        }
    }
    
    @IBAction func submit(sender: AnyObject) {
        if urlText.text == DEFAULT_LOCATION_TEXT || urlText.text == "" {
            // alert
            self.showErrorAlert("Please Enter a Valid Location")
            
        } else {
            //segueToEnterUrl()
            postLocation()
        }
    }
}