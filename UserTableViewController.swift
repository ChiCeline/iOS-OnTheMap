//
//  UserTableViewController.swift
//  OnTheMap
//
//  Created by Chi Zhang on 11/14/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

/* Table view of users */

class UserTableViewController: UITableViewController {
    
    private let reuseIdentifier = "userTableCell"
    
    // Users' data for table
    var students: [Student] = [Student]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register table cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // setup UI
        setUpTalbeRowHeight()
        setUpNavigationBar()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUserData()
    }
    
    
    // MARK: Table view protocol functions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NetworkClient.sharedInstance().openURL(students[indexPath.row].mediaURL)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)! as UITableViewCell
        let student = students[indexPath.row]
        
        cell.textLabel!.text = "\(student.firstName) \(student.lastName)"
        cell.imageView!.image = nil
        
        return cell
    }
    
    
    // MARK: Touch up buttons
    
    /* add pin button */
    func addPinButtonTouchUp(sender: AnyObject) {
        let newUserVC = NewUserViewController()
        self.presentViewController(newUserVC, animated: true, completion: nil)
    }
    
    /* refresh button */
    func refreshButtonTouchUp(sender: AnyObject) {
        self.reloadUserData()
    }
    
    /* logout button */
    func logoutButtonTouchUp(sender: AnyObject) {
        NetworkClient.sharedInstance().logOutOfUdacitySession { success, error in
            if success {
                dispatch_async(dispatch_get_main_queue()){
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                NSLog(error!)
            }
        }
    }
    
    /* Helper function to reload users data to table */
    private func reloadUserData() {
        
        NetworkClient.sharedInstance().getAllStudents{ success, students, error in
            if success {
                self.students = students!
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                NSLog(error!)
            }
        }
    }
    
    
    // MARK: Helper functions to initialize UI
    
    private func setUpTalbeRowHeight() {
        tableView.rowHeight = 80
    }
    
    private func setUpNavigationBar() {
        
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = UIColor.blueColor()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutButtonTouchUp:")
        let addPinButton = UIBarButtonItem(title: "Add Pin", style: UIBarButtonItemStyle.Plain, target: self, action: "addPinButtonTouchUp:")
        let refreshButton = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: "refreshButtonTouchUp:")
        
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        
    }
    
}
