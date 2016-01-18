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
    // table datasource, grouped by date
    var groupedTests = [String:[Test]]()
    var sections = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("closeModal"))
        
        self.title = "Follow Up Calendar"
        
        tableView.allowsSelection = false
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fr = NSFetchRequest(entityName: "Test")
        let predicate = NSPredicate(format: "test_visitnext != nil && test_visitnext != \"\"")
        fr.predicate = predicate
        let sortDescriptor1 = NSSortDescriptor(key: "patient_id", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "test_visitnext", ascending: true)
        fr.sortDescriptors = [sortDescriptor1,sortDescriptor2]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: context, sectionNameKeyPath: "patient_id", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
            if let patients = fetchedResultsController.sections {
                for patient in patients {
                    if let lastTest = patient.objects?.last as? Test {
                        if let nextTestDate = lastTest.test_visitnext {
                            if var tests = groupedTests[nextTestDate] {
                                tests.append(lastTest)
                                groupedTests[nextTestDate] = tests
                            } else {
                                groupedTests[nextTestDate] = [lastTest]
                            }
                        }
                    }
                }
                self.sections = groupedTests.keys.sort()
            }
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
        return self.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = self.sections[section]
        if let tests = groupedTests[date] {
            return tests.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateString = self.sections[section]
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        if let date = df.dateFromString(dateString) {
            df.dateFormat = "EEEE, MMM d y"
            return df.stringFromDate(date)
        }
        
        return dateString
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        
        var text = ""
        
        /*
        if let test = fetchedResultsController.objectAtIndexPath(indexPath) as? Test {
            text = test.test_visitnext ?? ""
        }
        */
        
        let date = self.sections[indexPath.section]
        if let tests = groupedTests[date] {
            if let test = tests[indexPath.row] as? Test {
                
                let id = test.patient_id ?? ""
                var lastdate = ""
                let df = NSDateFormatter()
                if let date = test.getDate("test_date"){
                    df.dateFormat = "EEEE, MMM d y"
                    lastdate = df.stringFromDate(date)
                }
                text = "\(id) | Last visit : \(lastdate)"
                
                
                let flag = UILabel(frame: CGRect(x: 5, y: 5, width: 35, height: 35))
                flag.backgroundColor = .redColor()
                flag.textColor = .whiteColor()
                flag.textAlignment = .Center
                
                if(test.outcome_hearingloss_ag == "1") {
                    flag.text = "AG"
                }
                
                if (test.outcome_hearingloss == "1") {
                   cell.addSubview(flag)
                }
            }
        }
        
        // Configure the cell...
        
        let textLabel = UILabel(frame: CGRect(x: 50, y: 5, width: 500, height: 35))
        textLabel.text = text
        cell.addSubview(textLabel)
        
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
