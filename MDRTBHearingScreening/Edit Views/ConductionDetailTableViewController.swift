//
//  ConductionDetailTableViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 4/3/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class ConductionDetailTableViewController: UITableViewController, ConductionDetailTableViewCellDelegate {
    
    var sections = [""]
    var rows: [[String:String?]] = [["label":"125 Hz"],
        ["label":"250 Hz"],
        ["label":"500 Hz"],
        ["label":"1000 Hz"],
        ["label":"2000 Hz"],
        ["label":"4000 Hz"],
        ["label":"8000 Hz"]]

    func dbLevelUpdated(cell: UITableViewCell, newDbLevel: Int) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            println(newDbLevel)
            rows[indexPath.row]["value"] = newDbLevel.description
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return rows.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ConductionTableCell", forIndexPath: indexPath) as! ConductionDetailTableViewCell
        
        if indexPath.row < rows.count {
            
            let row = rows[indexPath.row]
            cell.Frequency.text = row["label"]! ?? "Row \(indexPath.row)"
            
            let dbLevel = row["value"]!?.toInt() ?? UISegmentedControlNoSegment
            let dbIndex = dbLevel/5
            if dbIndex%2 == 0 {
                cell.DbLevelsA.selectedSegmentIndex = dbIndex/2
                cell.DbLevelsB.selectedSegmentIndex = UISegmentedControlNoSegment
            } else {
                cell.DbLevelsA.selectedSegmentIndex = UISegmentedControlNoSegment
                cell.DbLevelsB.selectedSegmentIndex = dbIndex/2
            }
        }
        cell.delegate = self
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionTitle = sections[section]
        return sectionTitle
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
