//
//  MapViewController.swift
//  On the Map
//
//  Created by Nick Cohen on 5/23/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapViewController : UIViewController, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        self.tabBarItem = UITabBarItem(title: "Map", image: UIImage(), tag: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    override func refreshData() {
        map.removeAnnotations(map.annotations)
        objc_sync_enter((UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations)
        for studentLocation in (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations {
            var point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude!, longitude: studentLocation.longitude!)
            point.title = studentLocation.firstName! + " " + studentLocation.lastName!
            point.subtitle = studentLocation.mediaURL!
            self.map.addAnnotation(point)
            println("\(studentLocation.uniqueKey!) \(point.title)")
        }
        objc_sync_exit((UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        println("mapView didSelectAnnotationView")
        if var point = view.annotation as? MKPointAnnotation {
            println("\(point.title) \(point.subtitle)")
        } else {
            
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        println("mapView viewForAnnotation")
        var annotationView = MKPinAnnotationView(annotation: annotation!, reuseIdentifier: "")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("mapView calloutAccessoryControlTapped")

        if var point = view.annotation as? MKPointAnnotation {
            println("\(point.title) \(point.subtitle)")
            if let url = NSURL(string: point.subtitle) {
                UIApplication.sharedApplication().openURL(url)
            } else {
                showErrorAlert("Invalid URL \(point.subtitle)")
            }
        }
    }
}
