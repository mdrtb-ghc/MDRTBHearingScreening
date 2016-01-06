//
//  ConductionDetailTableViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 4/3/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class ConductionDetailTableViewController: UITableViewController, ConductionDetailTableViewCellDelegate {
    
    var test: Test!
    var ear: String!
    let frequencies: [String] = ["125",
        "250",
        "500",
        "1000",
        "2000",
        "4000",
        "8000"]

    func dbLevelUpdated(cell: UITableViewCell, newDbLevel: String) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            print(newDbLevel)
            let frequency = frequencies[indexPath.row]
            test.setValue(newDbLevel, forKey: (ear.lowercaseString+"_"+frequency))
            //rows[indexPath.row]["value"] = newDbLevel.description
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: (ear == "Left") ? "Summary" : "Next", style: .Plain, target: self, action: "goNext")
        
        title = "Audiometer Results - \(ear)"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return frequencies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ConductionTableCell", forIndexPath: indexPath) as! ConductionDetailTableViewCell
        
        if indexPath.row < frequencies.count {
            
            let frequency = frequencies[indexPath.row]
            cell.Frequency.text = "\(frequency) Hz"
            
            if let dbLevel = test.valueForKey(ear.lowercaseString+"_"+frequency) as? String {
                let dbIndex = (Int(dbLevel) ?? 0)/5
                if dbIndex%2 == 0 {
                    cell.DbLevelsA.selectedSegmentIndex = dbIndex/2
                    cell.DbLevelsB.selectedSegmentIndex = UISegmentedControlNoSegment
                } else {
                    cell.DbLevelsA.selectedSegmentIndex = UISegmentedControlNoSegment
                    cell.DbLevelsB.selectedSegmentIndex = dbIndex/2
                }
            } else {
                cell.DbLevelsA.selectedSegmentIndex = UISegmentedControlNoSegment
                cell.DbLevelsB.selectedSegmentIndex = UISegmentedControlNoSegment
            }
        }
        cell.delegate = self
        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        test.saveTestContext()
       if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? ConductionDetailTableViewController {
                destinationController.test = test
                destinationController.ear = "Left"
            }
            if let destinationController = segue.destinationViewController as? DetailTableViewController {
                destinationController.test = test
            }
        }
    }
}
