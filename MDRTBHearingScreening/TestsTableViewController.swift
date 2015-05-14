//
//  TestsTableViewController
//  MDRTBHearingScreening
//
//  Created by Laura Greisman on 3/29/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class TestsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    
    // Search by MRN implementation
    
    var searchResults : [Test]?
    
    // MARK: UISearchDisplayDelegate
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        // create fetchrequest
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fr = NSFetchRequest(entityName: "Test")
        let predicate = NSPredicate(format: "patient_id contains %@", argumentArray: [searchString])
        fr.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
        fr.sortDescriptors = [sortDescriptor]
        
        var error: NSError?
        if let results = context.executeFetchRequest(fr, error: nil) as? [Test] {
            searchResults = results
        }
        
        return true
    }
    
    
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
        
        if let tests = fetchedResultsController.fetchedObjects {
            title = "Hearing Tests (\(tests.count) total)"
        }
    }
    
    override func viewDidLoad() {
//        if let controller = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ImportExportViewController") as? ImportExportViewController {
//            
//            presentViewController(controller, animated: true, completion: nil)
//        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var objects = (tableView == self.tableView) ? fetchedResultsController.fetchedObjects : searchResults
        if objects != nil {
            return objects!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TestTableCell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TestTableCell")
        }
        
        if let test = ((tableView == self.tableView) ? fetchedResultsController.objectAtIndexPath(indexPath) : searchResults![indexPath.row]) as? Test {
            let number = test.test_id ?? ""
            let date = test.mediumDateString(test.getDate("test_date"))
            let type = test.getType()
            var title = "#\(number) | \(date) | \(type)"
            cell!.textLabel?.text = title
            
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let selectedTest = ((tableView == self.tableView) ? fetchedResultsController.objectAtIndexPath(indexPath) : searchResults![indexPath.row]) as? Test {
            
            performSegueWithIdentifier("gotoPage1", sender: selectedTest)
            
            
            /*
            
            // create new context for the single object selected
            var selectedObjectContext = NSManagedObjectContext()
            selectedObjectContext.persistentStoreCoordinator = selectedObject.managedObjectContext?.persistentStoreCoordinator
            
            // get test from new context
            if let selectedTest = selectedObjectContext.existingObjectWithID(selectedObject.objectID,error:nil) as? Test {
                performSegueWithIdentifier("gotoPage1", sender: selectedTest)
            }

            */
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
        case .Insert :
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break;
        case .Update :
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break;
        case .Delete :
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break;
        case .Move :
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break;
        default :
            println("Change Type %@ not handled",type.rawValue)
        }
        
        // update count
        if let tests = fetchedResultsController.fetchedObjects {
            title = "Hearing Tests (\(tests.count) total)"
        }
    }
    
    
    @IBAction func touchAddNewTest(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Please enter the Patient MRN", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Enter Patient MRN..."
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            println("cancel")
        }))
        alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let textField = alertController.textFields?.first as? UITextField {
                let context = self.fetchedResultsController.managedObjectContext
                let test = Test.newTest(context, patientId:textField.text)
                self.performSegueWithIdentifier("gotoPage1", sender: test)
            }
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return (tableView == self.tableView)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from datasource and updating the tableview)
            
            let context = fetchedResultsController.managedObjectContext
            let test = fetchedResultsController.objectAtIndexPath(indexPath) as! Test
            Test.deleteTest(test)
            
        }
    }
    
    var activityIndicatorController = UIViewController()
    
    // MARK: UI Bound Functions
    @IBAction func exportAllTests(sender: UIBarButtonItem) {
        // Exports ALL tests, regardless of consent
        //performSegueWithIdentifier("showImportExportModal", sender: false)
        
        if let navController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ImportExportNavController") as? UINavigationController {
            if let controller = navController.topViewController as? ImportExportViewController {
                controller.currentMode = .ExportAllToCSV
                presentViewController(navController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func exportStudyTests(sender: UIBarButtonItem) {
        // Exports Study tests only, where patient_consent = 1
        //performSegueWithIdentifier("showImportExportModal", sender: true)
        
        if let navController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ImportExportNavController") as? UINavigationController {
            if let controller = navController.topViewController as? ImportExportViewController {
                controller.currentMode = .ExportStudyOnlyToCSV
                presentViewController(navController, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "gotoPage1") {
            if let test = sender as? Test {
                if let toView = segue.destinationViewController as? TestDetailEditViewController {
                    toView.test = test
                }
            }
        }
        if (segue.identifier == "goToSummary") {
            if let test = sender as? Test {
                if let toView = segue.destinationViewController as? DetailTableViewController {
                    toView.test = test
                }
            }
        }
    }


}
