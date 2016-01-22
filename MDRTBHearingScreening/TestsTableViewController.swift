//
//  TestsTableViewController
//  MDRTBHearingScreening
//
//  Created by Laura Greisman on 3/29/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class TestsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    var searchController: UISearchController!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    func getPatients() -> [String] {
        var _patients = [String]()
        for obj in self.fetchedResultsController.fetchedObjects ?? [] {
            if let test = obj as? Test {
                if let patientId = test.patient_id {
                    if !_patients.contains(patientId) {
                        _patients.append(patientId)
                    }
                }
            }
        }
        return _patients
    }
        
    func initializeFetchedResultsController(searchString: String? = nil) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Test")
        let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if searchString != nil && searchString != "" {
            let predicate = NSPredicate(format: "patient_id contains %@", argumentArray: [searchString!])
            fetchRequest.predicate = predicate
        }
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserverForName("openURL", object: nil, queue: nil) { (notification: NSNotification) -> Void in
            print(notification)
            
            let openPanel = UIDocumentMenuViewController(URL: notification.object as! NSURL, inMode: UIDocumentPickerMode.MoveToService)
            self.presentViewController(openPanel, animated: true, completion: { () -> Void in
                print("doc viewer loaded")
            })
        }
        
    }
    
    
    
    override func viewDidLoad() {
        initializeFetchedResultsController()
        
        // update count
        if let tests = fetchedResultsController.fetchedObjects {
            title = "Hearing Tests (\(getPatients().count) patients, \(tests.count) tests)"
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsScopeBar = false
        //searchController.searchBar.barTintColor = UIColor.whiteColor()
        //searchController.searchBar.scopeButtonTitles = ["All","Hearing Loss","AG Hearing Loss","Study"]
        
        searchController.searchBar.placeholder = "Search by MRN..."
        searchController.searchBar.keyboardType = .NumbersAndPunctuation
        searchController.searchBar.sizeToFit()
        
        
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        initializeFetchedResultsController(searchController.searchBar.text)
        tableView.reloadData()
        // update count
        if let tests = fetchedResultsController.fetchedObjects {
            title = "Hearing Tests (\(getPatients().count) patients, \(tests.count) tests)"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TestTableCell", forIndexPath: indexPath) as! TestsTableViewCell
        
        let test = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Test
        let number = test.test_id ?? ""
        let date = test.mediumDateString(test.getDate("test_date"))
        let type = test.getType()
        
        var nextVisitDate = "Unscheduled"
        if(test.outcome_plan == "5") {
            nextVisitDate = "Patient Expired"
        } else if(test.test_visitnext != nil) {
            if let date = test.getDate("test_visitnext") {
                let df = NSDateFormatter()
                df.dateFormat = "EEE, MMM d y"
                nextVisitDate = df.stringFromDate(date)
            }
        }
        
        // Flags for Hearing Loss and Risk for Lost Followup
        if (test.outcome_hearingloss == "1") {
            cell.flag.backgroundColor = UIColor.redColor()
        } else if(Test.risk_lost_followup(test.patient_id)) {
            cell.flag.backgroundColor = UIColor.yellowColor()
        } else {
            cell.flag.backgroundColor = nil
        }
        cell.flag.text = (test.outcome_hearingloss_ag == "1") ? "AG" : ""
        
        cell.test_id.text = "#\(number)"
        cell.detail.text = "\(date) | \(type) | Next Visit : \(nextVisitDate)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedTest = fetchedResultsController.objectAtIndexPath(indexPath) as? Test {
            performSegueWithIdentifier("gotoPage1", sender: selectedTest)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        if type.rawValue > 0 {
            
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
            }
            
            // update count
            if let tests = fetchedResultsController.fetchedObjects {
                title = "Hearing Tests (\(getPatients().count) patients, \(tests.count) tests)"
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    @IBAction func touchAddNewTest(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Please enter the Patient MRN", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Enter Patient MRN..."
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            print("cancel")
        }))
        alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let textField = alertController.textFields?.first {
                let context = self.fetchedResultsController.managedObjectContext
                let test = Test.newTest(context, patientId:textField.text!)
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
            let test = fetchedResultsController.objectAtIndexPath(indexPath) as! Test
            Test.deleteTest(test)
        }
    }
    
    var activityIndicatorController = UIViewController()
    
    // MARK: UI Bound Functions
    @IBAction func exportAllTests(sender: UIBarButtonItem) {
        // Exports ALL tests, regardless of consent
        
        if let navController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ImportExportNavController") as? UINavigationController {
            if let controller = navController.topViewController as? ImportExportViewController {
                controller.currentMode = .ExportAllToCSV
                presentViewController(navController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func exportStudyTests(sender: UIBarButtonItem) {
        // Exports Study tests only, where patient_consent = 1
        
        if let navController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ImportExportNavController") as? UINavigationController {
            if let controller = navController.topViewController as? ImportExportViewController {
                controller.currentMode = .ExportStudyOnlyToCSV
                presentViewController(navController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func followUps(sender: UIBarButtonItem) {
        let followUpsController = FollowUpsTableViewController(style: .Grouped)
        let navController = UINavigationController(rootViewController: followUpsController)
        navController.modalPresentationStyle = .PageSheet
        navController.modalTransitionStyle = .CoverVertical
        presentViewController(navController, animated: true, completion: nil)        
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
