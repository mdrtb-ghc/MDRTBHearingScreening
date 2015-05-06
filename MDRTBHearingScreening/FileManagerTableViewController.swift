//
//  FileManagerTableViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 4/5/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class FileManagerTableViewController: UITableViewController {
    
    let filePropertiesToGet = [
        NSURLIsDirectoryKey,
        NSURLIsReadableKey,
        NSURLCreationDateKey,
        NSURLContentAccessDateKey,
        NSURLContentModificationDateKey
    ]
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.incapari.MDRTBHearingScreening" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var documentsList: [AnyObject]? = {
        var err: NSError?
        return NSFileManager.defaultManager().contentsOfDirectoryAtURL(self.applicationDocumentsDirectory,
            includingPropertiesForKeys: self.filePropertiesToGet,
            options: NSDirectoryEnumerationOptions.SkipsHiddenFiles,
            error: &err)
        }()
    
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return documentsList?.count ?? 0
    }

    
    func urlIsDir(url: NSURL) -> Bool {
        var value:AnyObject?
        var error:NSError?
        if url.getResourceValue(
            &value,
            forKey: NSURLIsDirectoryKey,
            error: &error) && value != nil{
                let number = value as! NSNumber
                return number.boolValue
        }
        
        return false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DocumentTableViewCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        if let url = documentsList?[indexPath.row] as! NSURL? {
            
            cell.textLabel?.text = url.lastPathComponent
            cell.detailTextLabel?.text = url.path
            
            if urlIsDir(url) {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.DetailButton
            }
        }
        return cell
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from datasource and updating the tableview)
            
            /*
            var confirmDeleteAlert = UIAlertController(title: "Are you sure?", message: "This is permenant", preferredStyle: UIAlertControllerStyle.ActionSheet)
            confirmDeleteAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action:UIAlertAction!) -> Void in
                println("Delete!!!")
            }))
            confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) -> Void in
                println("Cancel!!!")
            }))
            
            confirmDeleteAlert.popoverPresentationController?.sourceView = self
            
            presentViewController(confirmDeleteAlert, animated: true, completion: { () -> Void in
                println("complete")
            })

            */
            
        }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SelectDirSegue" {
            let dest = segue.destinationViewController as! FileManagerTableViewController
            let selectedCell = sender as! UITableViewCell
            if let selectedPath = selectedCell.detailTextLabel?.text as String? {
                let selectedURL = NSURL(fileURLWithPath: selectedPath, isDirectory: true)
                dest.documentsList = NSFileManager.defaultManager().contentsOfDirectoryAtURL(selectedURL!,
                    includingPropertiesForKeys: self.filePropertiesToGet,
                    options: NSDirectoryEnumerationOptions.SkipsHiddenFiles,
                    error: nil)
                dest.title = selectedURL?.lastPathComponent
            }
        }
        
    }
    
}
