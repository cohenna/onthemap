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
    
    var studentLocation : StudentLocation?
    var locationText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        urlText.delegate = self
        
        if let studentLocation = (UIApplication.sharedApplication().delegate as! AppDelegate).originalStudentLocation {
            if let mediaURL = studentLocation.mediaURL {
                urlText.text = mediaURL
            }
        }
                
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
            self.map.addAnnotation(point)
            
            var region = MKCoordinateRegion()
            region.center.latitude = studentLocation.latitude!
            region.center.longitude = studentLocation.longitude!
            region.span = MKCoordinateSpanMake(0.00725, 0.00725)
            self.map.setRegion(region, animated: true)
        }
    }
    
    
    func postOrPutLocation() {
        
        if let studentLocation = studentLocation {
            submitButton.enabled = false
            if let originalStudentLocation = (UIApplication.sharedApplication().delegate as! AppDelegate).originalStudentLocation {
                // update current location
                studentLocation.objectId = originalStudentLocation.objectId
                ParseClient.sharedInstance().putStudentLocation(studentLocation, completionHandler: {
                    (result: AnyObject?, error: NSError?) in
                    self.submitButton.enabled = true
                    if let error = error {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showErrorAlert("Error entering Student Location")
                        })
                    } else if let updatedAt = result as? String {
                        println("updatedAt=\(updatedAt)")
                        
                        // replace stored location
                        (UIApplication.sharedApplication().delegate as! AppDelegate).originalStudentLocation = studentLocation
                        
                        // replace location in array
                        var index = -1
                        for sl in (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations {
                            if sl.objectId == studentLocation.objectId {
                                index += 1
                                break
                            }
                            index += 1
                        }
                        if index >= 0 {
                            (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations[index] = studentLocation
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showErrorAlert("Error2 entering Student Location")
                        })
                    }
                })
            } else {
                // add new location
                ParseClient.sharedInstance().postStudentLocation(studentLocation, completionHandler: {
                    (result: AnyObject?, error: NSError?) in
                    self.submitButton.enabled = true
                    if let error = error {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showErrorAlert("Error entering Student Location")
                        })
                    } else if let objectId = result as? String {
                        studentLocation.objectId = objectId
                        
                        // replace stored location
                        (UIApplication.sharedApplication().delegate as! AppDelegate).originalStudentLocation = studentLocation
                        
                        // add location to array
                        (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations.append(studentLocation)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showErrorAlert("Error2 entering Student Location")
                        })
                    }
                })

                
                
            }
        } else {
            showErrorAlert("Error with Student Location")
        }
    }
    
    @IBAction func submit(sender: AnyObject) {
        if urlText.text == DEFAULT_LOCATION_TEXT || urlText.text == "" {
            // alert
            self.showErrorAlert("Please Enter a Valid Location")
            
        } else {
            studentLocation?.mediaURL = urlText.text
            postOrPutLocation()
        }
    }
}