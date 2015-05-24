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
        PulseClient.sharedInstance().getStudentLocations(nil,  limit: 1000,  offset: nil, allowDuplicates: false, completionHandler: { (result : [StudentLocation]?, error) in
            for studentLocation in result! {
                var point = MKPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude!, longitude: studentLocation.longitude!)
                point.title = studentLocation.firstName! + " " + studentLocation.lastName!
                point.subtitle = studentLocation.mediaURL!
                self.map.addAnnotation(point)
                println("\(studentLocation.uniqueKey!) \(point.title)")
            }
        })
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        println("mapView didSelectAnnotationView")
        if var point = view.annotation as? MKPointAnnotation {
            println("\(point.title) \(point.subtitle)")
        } else {
            
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        println("mapView didChangeDragState")
        if var point = view.annotation as? MKPointAnnotation {
            
        }
        
        //        if var point = view as MKPointAnnotation {
        
//        }
    }
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        println("mapView viewForAnnotation")
        var annotationView = MKPinAnnotationView(annotation: annotation!, reuseIdentifier: "")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
        return annotationView
    }
/*    (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
    {
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
*/
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("mapView calloutAccessoryControlTapped")

        if var point = view.annotation as? MKPointAnnotation {
            println("\(point.title) \(point.subtitle)")
            var url = NSURL(string: point.subtitle)!
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
