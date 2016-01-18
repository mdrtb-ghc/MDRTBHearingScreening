//
//  FollowUpsTableViewController.swift
//  MDRTBHearingScreening
//
//  Created by GHC on 1/16/16.
//  Copyright © 2016 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class FollowUpsTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController! = nil
    var groupedData: Dictionary<NSDate,[String]>? = [
        NSDate(timeIntervalSinceNow:-2*60*60*24):["1","2","3","4","5"],
        NSDate(timeIntervalSinceNow:-1*60*60*24):["1","2","3","4","5"],
        NSDate(timeIntervalSinceNow:0*60*60*24):["1","2","3","4","5"],
        NSDate(timeIntervalSinceNow:1*60*60*24):["1","2","3","4","5"],
        NSDate(timeIntervalSinceNow:2*60*60*24):["1","2","3","4","5"]]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // table datasource, grouped by date
    var groupedTests : [String:[Test]?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("closeModal"))
        
        self.title = "Follow Ups"
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fr = NSFetchRequest(entityName: "Test")
        
        var dateString = "2016-01-01"
        if let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: NSDate(), options: []) {
            dateString = Test.getStringFromDate(date, includeTime: false)
        }
        let predicate = NSPredicate(format: "test_visitnext >= %@", argumentArray: [dateString])
        fr.predicate = predicate
        let sortDescriptor1 = NSSortDescriptor(key: "test_visitnext", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "patient_id", ascending: true)
        fr.sortDescriptors = [sortDescriptor1,sortDescriptor2]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: context, sectionNameKeyPath: "test_visitnext", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching data");
        }

        
    }
    
    func closeModal() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            //let i = sections.startIndex.advancedBy(section)
            let section = sections[section]
            return section.numberOfObjects
        }
        return 0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let section = sections[section]
            
            let df = NSDateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            if let date = df.dateFromString(section.name) {
                df.dateFormat = "EEEE, MMM d y"
                return df.stringFromDate(date)
            }
            
            return section.name
        }
        /*
        if let sections = groupedData {
            let i = sections.startIndex.advancedBy(section)
            let section = sections[i]
            let date = section.0
            let df = NSDateFormatter()
            df.dateFormat = "EEEE, MMM d y"
            return df.stringFromDate(date)
        }
        */
        return ""
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)

        var text = ""
        
        if let test = fetchedResultsController.objectAtIndexPath(indexPath) as? Test {
            text = test.patient_id ?? ""
        }
        
        /*
        if let sections = groupedData {
            let i = sections.startIndex.advancedBy(indexPath.section)
            let section = sections[i]
            let row = section.1[indexPath.row]
            text = row
        }
        */
        
        // Configure the cell...
        cell.textLabel?.text = text
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
