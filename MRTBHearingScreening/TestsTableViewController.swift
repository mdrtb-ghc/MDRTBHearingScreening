//
//  TestsTableViewController
//  MRTBHearingScreening
//
//  Created by Laura Greisman on 3/29/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class TestsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    var fetchedResultsController: NSFetchedResultsController! {
        if(_fetchedResultsController != nil) {
            return _fetchedResultsController;
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Test")
        let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil);
        frc.delegate = self;
        _fetchedResultsController = frc;
        return _fetchedResultsController;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        NSNotificationCenter.defaultCenter().addObserverForName("openURL", object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            println(notification)
            
            let openPanel = UIDocumentMenuViewController(URL: notification.object as! NSURL, inMode: UIDocumentPickerMode.MoveToService)
            self.presentViewController(openPanel, animated: true, completion: { () -> Void in
                println("doc viewer loaded")
            })
        }
        
        var error: NSError?
        if(!fetchedResultsController.performFetch(&error)) {
            println("Error fetching data");
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let objects = fetchedResultsController.fetchedObjects
        let count: Int? = objects?.count
        if(count != nil) {
            return count!
        } else {
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TestTableCell") as! UITableViewCell
        let test = fetchedResultsController.objectAtIndexPath(indexPath) as! Test
        
        let number = test.test_id ?? ""
        let date = test.mediumDateString(test.test_date) ?? ""
        let patient = test.patient_id ?? ""
        let type = test.getType()

        var title = "#\(number) [\(type)] \(date), Patient #\(patient)"
        cell.textLabel?.text = title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetailSegue", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: NSFetchedResultsController
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
        case .Insert :
            println("Insert detected")
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break;
        case .Update :
            println("Update detected")
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break;
        case .Delete :
            println("Delete detected")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break;
        case .Move :
            println("Move detected")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break;
        default :
            println("Change Type %@ not handled",type.rawValue)
        }
    }
    
    // MARK: Misc
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetailSegue") {
            
            let toView = segue.destinationViewController as! DetailTableViewController
            let indexPath = (sender as! NSIndexPath)
            let test = fetchedResultsController.objectAtIndexPath(indexPath) as! Test
            toView.test = test
            return
        }
        if (segue.identifier == "addNewSegue") {
            
            let context = fetchedResultsController.managedObjectContext
            let test = Test.addTest(context)
            
            let toView = segue.destinationViewController as! DetailTableViewController
            toView.test = test
            
            return
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from datasource and updating the tableview)
            
            let context = fetchedResultsController.managedObjectContext
            let test = fetchedResultsController.objectAtIndexPath(indexPath) as! Test
            Test.deleteTest(test)
            
        }
    }
    
    
    // MARK: UI Bound Functions
    
    @IBAction func exportTests(sender: UIBarButtonItem) {
        println("exporting tests to csv")
        
        var lines = NSMutableString()
        if let tests = fetchedResultsController.fetchedObjects as? [Test] {
            // TODO - fix header, doesn't match data order
            //lines.appendString(Test.csvHeaderString(fetchedResultsController.managedObjectContext)+"\n")
            for t in tests {
                lines.appendString(t.toCSVString()+"\n")
            }
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let url = appDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent("out.csv")
        var err: NSError?
        lines.writeToURL(url, atomically: true, encoding: NSUTF8StringEncoding, error: &err)
        
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        
        if activityController.respondsToSelector("popoverPresentationController") {
            // iOS 8+ only
            let presentationController = activityController.popoverPresentationController
            presentationController?.barButtonItem = sender
        }
    }
    
    @IBAction func exportDb(sender: UIBarButtonItem) {
        println("exporting core data db")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let urls = [appDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent("MRTBHearingScreening.mainstore")]
        
        let activityController = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        
        if activityController.respondsToSelector("popoverPresentationController") {
            // iOS 8+ only
            let presentationController = activityController.popoverPresentationController
            presentationController?.barButtonItem = sender
        }
    }
}
