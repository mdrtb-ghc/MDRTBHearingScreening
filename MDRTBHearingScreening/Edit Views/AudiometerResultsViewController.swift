//
//  AudiometerResultsViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 5/8/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class AudiometerResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConductionDetailTableViewCellDelegate {
    var test: Test!
    var ear: String!
    let frequencies: [String] = ["125",
        "250",
        "500",
        "1000",
        "2000",
        "4000",
        "8000"]
    
    @IBOutlet weak var tableView: UITableView!
    
    func dbLevelUpdated(cell: UITableViewCell, newDbLevel: String) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            let frequency = frequencies[indexPath.row]
            test.setValue(newDbLevel, forKey: (ear.lowercaseString+"_"+frequency))
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
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
    
    // MARK: - Save Context on Close
    override func viewWillDisappear(animated: Bool) {
        //test.saveTestContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frequencies.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConductionTableCell", forIndexPath: indexPath) as! ConductionDetailTableViewCell
        
        if indexPath.row < frequencies.count {
            
            let frequency = frequencies[indexPath.row]
            cell.Frequency.text = "\(frequency) Hz"
            
            if let dbLevel = test.valueForKey(ear.lowercaseString+"_"+frequency) as? String {
                let dbIndex = (dbLevel.toInt() ?? 0)/5
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
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? AudiometerResultsViewController {
                destinationController.test = test
                destinationController.ear = "Left"
            }
            if let destinationController = segue.destinationViewController as? DetailTableViewController {
                destinationController.test = test
            }
        }
    }
}