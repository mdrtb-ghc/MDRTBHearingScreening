//
//  FollowUpsTableViewController.swift
//  MDRTBHearingScreening
//
//  Created by GHC on 1/16/16.
//  Copyright © 2016 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class AnalysisTableViewController: UITableViewController {
    
    var allPatientData: [NSFetchedResultsSectionInfo]?
    var studyOnlyPatientData: [NSFetchedResultsSectionInfo]?

    enum AnalysisDataRows {
        case Patients
        case StudyPatients
        case StudyMalePatients
        case StudyFemalePatients
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    func queryData(entityName: String = "Test", propertiesToFetch: [String], predicateFormat: String? = nil, predicateArgs:[String]? = []) -> [AnyObject]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let request = NSFetchRequest(entityName: entityName)
        
        request.propertiesToFetch = propertiesToFetch
        request.resultType = .DictionaryResultType
        
        if (predicateFormat != nil ) {
            request.predicate = NSPredicate(format: predicateFormat!, argumentArray: predicateArgs ?? [])
        }
        
        do {
            let result = try context.executeFetchRequest(request)
            if let dictionaryResult = result as? [[String:AnyObject]] {
                return dictionaryResult
            }
            
            return result
        } catch {
            print("Error fetching data");
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("closeModal"))
        
        self.title = "Basic Data Analysis Summary"
        
        tableView.allowsSelection = false
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
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 18
        case 2:
            return 8
        case 3:
            return 8
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        
        let textLabel = UILabel(frame: CGRect(x: 50, y: 5, width: 400, height: 35))
        let valueLabel = UILabel(frame: CGRect(x: 500, y: 5, width: 200, height: 35))
        cell.addSubview(textLabel)
        cell.addSubview(valueLabel)
        
        switch (indexPath.section,indexPath.row) {
        case (0,0) :
            textLabel.text = "Total #"
            if let tests = queryData("Test", propertiesToFetch: ["test_id","patient_id"]) as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,0) :
            textLabel.text = "# Study"
            if let tests = queryData("Test", propertiesToFetch: ["test_id","patient_id"], predicateFormat: "patient_consent == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,1) :
            textLabel.text = "# Male"
            if let tests = queryData("Test", propertiesToFetch: ["test_id","patient_id"], predicateFormat: "patient_consent == \"1\" && patient_gender == \"0\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,2) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "Age Range"
            if let result = queryData("Test", propertiesToFetch: ["patient_age"], predicateFormat: "patient_consent == \"1\" && patient_gender == \"0\"") as? [[String:AnyObject]] {
                var ages = result.map { Int($0["patient_age"] as? String ?? "") ?? 0 }
                ages.sortInPlace()
                ages = ages.filter({ (x: Int) -> Bool in
                    return x > 0
                })
                valueLabel.text = "\(ages.first ?? 0) - \(ages.last ?? 0)"
            }
        case (1,3) :
            textLabel.text = "# Female"
            if let tests = queryData("Test", propertiesToFetch: ["test_id","patient_id"], predicateFormat: "patient_consent == \"1\" && patient_gender == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,4) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "Age Range"
            if let result = queryData("Test", propertiesToFetch: ["patient_age"], predicateFormat: "patient_consent == \"1\" && patient_gender == \"1\"") as? [[String:AnyObject]] {
                var ages = result.map { Int($0["patient_age"] as? String ?? "") ?? 0 }
                ages.sortInPlace()
                ages = ages.filter({ (x: Int) -> Bool in
                    return x > 0
                })
                valueLabel.text = "\(ages.first ?? 0) - \(ages.last ?? 0)"
            }
        case (1,5) :
            textLabel.text = "# Subjective Hearing Loss at Baseline"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && test_type == \"0\" && history == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,6) :
            textLabel.text = "# Subjective Hearing Loss at Follow Up"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && test_type == \"1\" && history == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,7) :
            textLabel.text = "# Abnormal Otoscopy"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && (right_normal == \"0\" || left_normal == \"0\")") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,8) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# Wax"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"],predicateFormat: "patient_consent == \"1\" && (right_wax == \"1\" || left_wax == \"1\")") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,9) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# Infection"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"],predicateFormat: "patient_consent == \"1\" && (right_infection == \"1\" || left_infection == \"1\")") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,10) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# Perforated"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"],predicateFormat: "patient_consent == \"1\" && (right_perforated == \"1\" || left_perforated == \"1\")") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,11) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# Fluid"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"],predicateFormat: "patient_consent == \"1\" && (right_fluid == \"1\" || left_fluid == \"1\")") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,12) :
            textLabel.text = "# Expired (based on Outcome)"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"],predicateFormat: "patient_consent == \"1\" && outcome_plan == \"5\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(patients.count) patients"
            }
        case (1,13) :
            textLabel.text = "# Lost to Follow Up (last test > 2 months)"
            var lostfollowup = [String]()
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } )
                for patient in patients {
                    if Test.risk_lost_followup(String(patient)) {
                        lostfollowup.append(String(patient))
                    }
                }
                valueLabel.text = "\(lostfollowup.count) patients"
            }
        case (1,14) :
            textLabel.text = "# signs of audiometer test hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"],predicateFormat: "patient_consent == \"1\" && outcome_hearingloss == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,15) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# also with subjective loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"],predicateFormat: "patient_consent == \"1\" && outcome_hearingloss == \"1\" && history == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,16) :
            textLabel.text = "# hearing loss due to AG"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"],predicateFormat: "patient_consent == \"1\" && outcome_hearingloss_ag == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (1,17) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# also with subjective loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"],predicateFormat: "patient_consent == \"1\" && outcome_hearingloss_ag == \"1\" && history == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
            
        case (2,0) :
            textLabel.text = "# with subjective hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (2,1) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# Normal Otoscopy"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"1\" && (right_normal == \"1\" || left_normal == \"1\")") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (2,2) :
            textLabel.frame.insetInPlace(dx: 100, dy: 0)
            textLabel.text = "# signs of hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"1\" && (right_normal == \"1\" || left_normal == \"1\") && outcome_hearingloss = \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (2,3) :
            textLabel.frame.insetInPlace(dx: 150, dy: 0)
            textLabel.text = "# due to AG"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"1\" && (right_normal == \"1\" || left_normal == \"1\") && outcome_hearingloss_ag = \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (2,4) :
            textLabel.frame.insetInPlace(dx: 100, dy: 0)
            textLabel.text = "# no signs of hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"1\" && (right_normal == \"1\" || left_normal == \"1\") && outcome_hearingloss = \"0\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (2,5) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# Abnormal Otoscopy"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"1\" && (right_normal == \"0\" || left_normal == \"0\")") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (2,6) :
            textLabel.frame.insetInPlace(dx: 100, dy: 0)
            textLabel.text = "# signs of hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"1\" && (right_normal == \"0\" || left_normal == \"0\") && outcome_hearingloss = \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (2,7) :
            textLabel.frame.insetInPlace(dx: 150, dy: 0)
            textLabel.text = "# due to AG"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"1\" && (right_normal == \"0\" || left_normal == \"0\") && outcome_hearingloss_ag = \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (2,8) :
            textLabel.frame.insetInPlace(dx: 100, dy: 0)
            textLabel.text = "# no signs of hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"1\" && (right_normal == \"0\" || left_normal == \"0\") && outcome_hearingloss = \"0\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
            
        case (3,0) :
            textLabel.text = "# no subjective hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"0\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (3,1) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# Normal Otoscopy"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"0\" && (right_normal == \"1\" || left_normal == \"1\")") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (3,2) :
            textLabel.frame.insetInPlace(dx: 100, dy: 0)
            textLabel.text = "# signs of hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"0\" && (right_normal == \"1\" || left_normal == \"1\") && outcome_hearingloss = \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (3,3) :
            textLabel.frame.insetInPlace(dx: 150, dy: 0)
            textLabel.text = "# due to AG"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"0\" && (right_normal == \"1\" || left_normal == \"1\") && outcome_hearingloss_ag = \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (3,4) :
            textLabel.frame.insetInPlace(dx: 100, dy: 0)
            textLabel.text = "# no signs of hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"0\" && (right_normal == \"1\" || left_normal == \"1\") && outcome_hearingloss = \"0\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (3,5) :
            textLabel.frame.insetInPlace(dx: 50, dy: 0)
            textLabel.text = "# Abnormal Otoscopy"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"0\" && (right_normal == \"0\" || left_normal == \"0\")") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (3,6) :
            textLabel.frame.insetInPlace(dx: 100, dy: 0)
            textLabel.text = "# signs of hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"0\" && (right_normal == \"0\" || left_normal == \"0\") && outcome_hearingloss = \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (3,7) :
            textLabel.frame.insetInPlace(dx: 150, dy: 0)
            textLabel.text = "# due to AG"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"0\" && (right_normal == \"0\" || left_normal == \"0\") && outcome_hearingloss_ag = \"1\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        case (3,8) :
            textLabel.frame.insetInPlace(dx: 100, dy: 0)
            textLabel.text = "# no signs of hearing loss"
            if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\" && history == \"0\" && (right_normal == \"0\" || left_normal == \"0\") && outcome_hearingloss = \"0\"") as? [[String:AnyObject]] {
                let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects
                valueLabel.text = "\(tests.count) tests, \(patients.count) patients"
            }
        
        default :
            textLabel.text = "-"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.sizeToFit()
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
