//
//  ListViewController.swift
//  On the Map
//
//  Created by Nick Cohen on 5/23/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation
import UIKit

class ListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem(title: "List", image: UIImage(), tag: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func refreshData() {
        self.tableView.reloadData()
    }
    
    // open detail view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var studentLocation = (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations[indexPath.row]
        if let mediaURL = studentLocation.mediaURL {
            println("tableView didDeselectRowAtIndexPath=\(indexPath.row) url=\(studentLocation.mediaURL!)")
            if let url = NSURL(string: mediaURL) {
                UIApplication.sharedApplication().openURL(url)
            } else {
                showErrorAlert("Invalid URL \(mediaURL)")
            }
        } else {
            showErrorAlert("Invalid URL nil")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations.count
        println("tableView count=\(count)")
        return count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as! UITableViewCell
        var studentLocation = (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations[indexPath.row]
        let label = cell.viewWithTag(1001) as! UILabel
        
        
        if let firstName = studentLocation.firstName, lastName = studentLocation.lastName {
            label.text = "\(firstName) \(lastName)"
        } else {
            label.text = "Unknown Name"
        }
        
        return cell
        
    }
}
