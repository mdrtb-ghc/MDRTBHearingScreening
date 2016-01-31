//
//  FollowUpsTableViewController.swift
//  MDRTBHearingScreening
//
//  Created by GHC on 1/16/16.
//  Copyright © 2016 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class DataItem {
    var textLabel = ""
    var valueLabel = ""
    var labelLevel = 0.0
    var detailData = []
    
    init() {
        
    }
    init(label: String, queryresult: AnyObject?, labelLevel: Double = 0.0) {
        self.textLabel = label
        self.labelLevel = labelLevel
        if let tests = queryresult as? [[String:AnyObject]] {
            if var patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } ).allObjects as? [String] {
                patients.sortInPlace()
                valueLabel = "\(patients.count) patients, \(tests.count) tests"
                detailData = patients
            }
        }
    }
}


class AnalysisTableViewController: UITableViewController {
    
    var data: [[DataItem]] = [[]]
    var sectionHeaders = ["Totals","Study","Patients Reporting Subjective Hearing Loss Breakdown","Patients Not Reporting Subjective Hearing Loss Breakdown"]
    
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
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let maleAgeRangeItem = DataItem()
        maleAgeRangeItem.textLabel = "Age Range"
        maleAgeRangeItem.labelLevel = 1
        if let result = queryData("Test", propertiesToFetch: ["patient_age"], predicateFormat: "patient_consent = %@ && patient_gender= %@", predicateArgs: ["1","0"]) as? [[String:AnyObject]] {
            var ages = result.map { Int($0["patient_age"] as? String ?? "") ?? 0 }
            ages.sortInPlace()
            ages = ages.filter({ (x: Int) -> Bool in
                return x > 0
            })
            maleAgeRangeItem.valueLabel = "\(ages.first ?? 0) - \(ages.last ?? 0)"
        }
        
        let femaleAgeRangeItem = DataItem()
        femaleAgeRangeItem.textLabel = "Age Range"
        femaleAgeRangeItem.labelLevel = 1
        if let result = queryData("Test", propertiesToFetch: ["patient_age"], predicateFormat: "patient_consent = %@ && patient_gender= %@", predicateArgs: ["1","1"]) as? [[String:AnyObject]] {
            var ages = result.map { Int($0["patient_age"] as? String ?? "") ?? 0 }
            ages.sortInPlace()
            ages = ages.filter({ (x: Int) -> Bool in
                return x > 0
            })
            femaleAgeRangeItem.valueLabel = "\(ages.first ?? 0) - \(ages.last ?? 0)"
        }
        
        let lostToFollowupItem = DataItem()
        lostToFollowupItem.textLabel = "# Lost to Follow Up (last test > 2 months)"
        if let tests = queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent == \"1\"") as? [[String:AnyObject]] {
            let patients = NSSet(array: tests.map { $0["patient_id"] ?? "" } )
            var lostfollowup = [String]()
            for patient in patients {
                if Test.risk_lost_followup(String(patient)) {
                    lostfollowup.append(String(patient))
                }
            }
            lostToFollowupItem.valueLabel = "\(lostfollowup.count) patients"
            lostToFollowupItem.detailData = lostfollowup
        }
        
        self.data = [
            [
                DataItem(label: "# Total", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: nil, predicateArgs: nil)),
                
                DataItem(label: "# in Study", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@", predicateArgs: ["1"])),
                
            ],
            [
                DataItem(label: "# Male", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && patient_gender = %@", predicateArgs: ["1","0"])),
                
                maleAgeRangeItem,
                
                DataItem(label: "# Female", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && patient_gender = %@", predicateArgs: ["1","1"])),
                
                femaleAgeRangeItem,
                
                DataItem(label: "# Subjective Hearing Loss at Baseline", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && test_type = %@ && history = %@", predicateArgs: ["1","0","1"])),
                
                DataItem(label: "# Subjective Hearing Loss at Followup", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && test_type = %@ && history = %@", predicateArgs: ["1","1","1"])),
                
                DataItem(label: "# Abnormal Otoscopy", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && (right_normal = %@ || left_normal = %@)", predicateArgs: ["1","0","0"])),
                
                DataItem(label: "# Wax", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && (right_wax = %@ || left_wax = %@)", predicateArgs: ["1","1","1"]),labelLevel:1),
                
                DataItem(label: "# Infection", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && (right_infection = %@ || left_infection = %@)", predicateArgs: ["1","1","1"]),labelLevel:1),
                
                DataItem(label: "# Perforated", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && (right_perforated = %@ || left_perforated = %@)", predicateArgs: ["1","1","1"]),labelLevel:1),
                
                DataItem(label: "# Fluid", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && (right_fluid = %@ || left_fluid = %@)", predicateArgs: ["1","1","1"]),labelLevel:1),
                
                DataItem(label: "# Expired (based on outcome)", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && outcome_plan = %@", predicateArgs: ["1","5"])),
                
                lostToFollowupItem,
                
                DataItem(label: "# signs of audiometer test hearing loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && outcome_hearingloss = %@", predicateArgs: ["1","1"])),
                
                DataItem(label: "# also with subjective loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && outcome_hearingloss = %@ && history = %@", predicateArgs: ["1","1","1"]),labelLevel:1),
                
                DataItem(label: "# hearing loss due to AG", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && outcome_hearingloss_ag = %@", predicateArgs: ["1","1"])),

                DataItem(label: "# also with subjective loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && outcome_hearingloss_ag = %@ && history = %@", predicateArgs: ["1","1","1"]),labelLevel:1),
                
            ],
            [
                DataItem(label: "# Subjective Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@", predicateArgs: ["1","1"])),
                
                DataItem(label: "# Normal Otoscopy", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && left_normal = %@ && right_normal = %@", predicateArgs: ["1","1","1","1"]),labelLevel:1),
                
                DataItem(label: "# Audiometer Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && left_normal = %@ && right_normal = %@ && outcome_hearingloss = %@", predicateArgs: ["1","1","1","1","1"]),labelLevel:2),
                
                DataItem(label: "# AG Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && left_normal = %@ && right_normal = %@ && outcome_hearingloss_ag = %@", predicateArgs: ["1","1","1","1","1"]),labelLevel:3),
                
                DataItem(label: "# Abnormal Otoscopy", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && (left_normal = %@ || right_normal = %@)", predicateArgs: ["1","1","0","0"]),labelLevel:1),
                
                DataItem(label: "# Audiometer Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && (left_normal = %@ || right_normal = %@) && outcome_hearingloss = %@", predicateArgs: ["1","1","0","0","1"]),labelLevel:2),
                
                DataItem(label: "# AG Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && (left_normal = %@ || right_normal = %@) && outcome_hearingloss_ag = %@", predicateArgs: ["1","1","0","0","1"]),labelLevel:3),
            ],
            [
                DataItem(label: "# No Subjective Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@", predicateArgs: ["1","0"])),
                
                DataItem(label: "# Normal Otoscopy", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && left_normal = %@ && right_normal = %@", predicateArgs: ["1","0","1","1"]),labelLevel:1),
                
                DataItem(label: "# Audiometer Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && left_normal = %@ && right_normal = %@ && outcome_hearingloss = %@", predicateArgs: ["1","0","1","1","1"]),labelLevel:2),
                
                DataItem(label: "# AG Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && left_normal = %@ && right_normal = %@ && outcome_hearingloss_ag = %@", predicateArgs: ["1","0","1","1","1"]),labelLevel:3),
                
                DataItem(label: "# Abnormal Otoscopy", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && (left_normal = %@ || right_normal = %@)", predicateArgs: ["1","0","0","0"]),labelLevel:1),
                
                DataItem(label: "# Audiometer Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && (left_normal = %@ || right_normal = %@) && outcome_hearingloss = %@", predicateArgs: ["1","0","0","0","1"]),labelLevel:2),
                
                DataItem(label: "# AG Hearing Loss", queryresult: queryData("Test", propertiesToFetch: ["patient_id"], predicateFormat: "patient_consent = %@ && history = %@ && (left_normal = %@ || right_normal = %@) && outcome_hearingloss_ag = %@", predicateArgs: ["1","0","0","0","1"]),labelLevel:3),
            ]
        ]
        
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
        return data.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        
        let textLabel = UILabel(frame: CGRect(x: 50, y: 5, width: 300, height: 35))
        let valueLabel = UILabel(frame: CGRect(x: 400, y: 5, width: 300, height: 35))
        cell.addSubview(textLabel)
        cell.addSubview(valueLabel)
        
        let dataItem = data[indexPath.section][indexPath.row]
        textLabel.frame.insetInPlace(dx: CGFloat(dataItem.labelLevel*20.0), dy: 0)
        textLabel.text = dataItem.textLabel
        valueLabel.frame.insetInPlace(dx: CGFloat(dataItem.labelLevel*20.0), dy: 0)
        valueLabel.text = dataItem.valueLabel
        
        if dataItem.detailData.count > 0 {
            cell.accessoryType = .DisclosureIndicator
        }

        
/*
        switch (indexPath.section,indexPath.row) {
        
        
        
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
*/
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataItem = data[indexPath.section][indexPath.row]
        if dataItem.detailData.count > 0 {
            if let detailData = dataItem.detailData as? [String] {
                let analysisDetailController = AnalysisDetailTableViewController()
                analysisDetailController.data = detailData
                analysisDetailController.sectionTitle = dataItem.textLabel
                self.navigationController?.pushViewController(analysisDetailController, animated: true)
            }
        }
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
