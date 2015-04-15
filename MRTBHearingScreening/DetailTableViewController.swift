//
//  DetailTableViewController.swift
//  MRTBHearingScreening
//
//  Created by Laura Greisman on 3/29/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    var test : Test!
    var test_prev : Test?
    
    @IBOutlet weak var testId: UILabel!
    @IBOutlet weak var testDate: UILabel!
    @IBOutlet weak var testTime: UILabel!
    @IBOutlet weak var testLocation: UILabel!
    @IBOutlet weak var testType: UILabel!
    
    @IBOutlet weak var patientId: UILabel!
    @IBOutlet weak var patientDOB: UILabel!
    @IBOutlet weak var patientAge: UILabel!
    @IBOutlet weak var patientGender: UILabel!
    
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var history_ear: UILabel!
    @IBOutlet weak var history_ringing: UILabel!
    @IBOutlet weak var history_timing: UILabel!
    
    @IBOutlet weak var baseline_creatinine: UILabel!
    @IBOutlet weak var baseline_ag_start_date: UILabel!
    @IBOutlet weak var baseline_streptomycin: UILabel!
    
    @IBOutlet weak var monthly_ag_type: UILabel!
    @IBOutlet weak var monthly_ag_dose: UILabel!
    @IBOutlet weak var monthly_ag_route: UILabel!
    @IBOutlet weak var monthly_ag_frequency: UILabel!
    @IBOutlet weak var monthly_ag_level: UILabel!
    @IBOutlet weak var monthly_creatinine_level: UILabel!
    @IBOutlet weak var monthly_furosemide: UILabel!
    
    @IBOutlet weak var left_normal: UILabel!
    @IBOutlet weak var left_wax: UILabel!
    @IBOutlet weak var left_infection: UILabel!
    @IBOutlet weak var left_perforated: UILabel!
    @IBOutlet weak var left_fluid: UILabel!
    
    @IBOutlet weak var left_normal_prev: UILabel!
    @IBOutlet weak var left_wax_prev: UILabel!
    @IBOutlet weak var left_infection_prev: UILabel!
    @IBOutlet weak var left_perforated_prev: UILabel!
    @IBOutlet weak var left_fluid_prev: UILabel!
    
    @IBOutlet weak var right_normal: UILabel!
    @IBOutlet weak var right_wax: UILabel!
    @IBOutlet weak var right_infection: UILabel!
    @IBOutlet weak var right_perforated: UILabel!
    @IBOutlet weak var right_fluid: UILabel!
    
    @IBOutlet weak var right_normal_prev: UILabel!
    @IBOutlet weak var right_wax_prev: UILabel!
    @IBOutlet weak var right_infection_prev: UILabel!
    @IBOutlet weak var right_perforated_prev: UILabel!
    @IBOutlet weak var right_fluid_prev: UILabel!
    
    @IBOutlet weak var left_125: UILabel!
    @IBOutlet weak var left_250: UILabel!
    @IBOutlet weak var left_500: UILabel!
    @IBOutlet weak var left_1000: UILabel!
    @IBOutlet weak var left_2000: UILabel!
    @IBOutlet weak var left_4000: UILabel!
    @IBOutlet weak var left_8000: UILabel!
  
    @IBOutlet weak var left_125_prev: UILabel!
    @IBOutlet weak var left_250_prev: UILabel!
    @IBOutlet weak var left_500_prev: UILabel!
    @IBOutlet weak var left_1000_prev: UILabel!
    @IBOutlet weak var left_2000_prev: UILabel!
    @IBOutlet weak var left_4000_prev: UILabel!
    @IBOutlet weak var left_8000_prev: UILabel!
    
    @IBOutlet weak var right_125: UILabel!
    @IBOutlet weak var right_250: UILabel!
    @IBOutlet weak var right_500: UILabel!
    @IBOutlet weak var right_1000: UILabel!
    @IBOutlet weak var right_2000: UILabel!
    @IBOutlet weak var right_4000: UILabel!
    @IBOutlet weak var right_8000: UILabel!
    
    @IBOutlet weak var right_125_prev: UILabel!
    @IBOutlet weak var right_250_prev: UILabel!
    @IBOutlet weak var right_500_prev: UILabel!
    @IBOutlet weak var right_1000_prev: UILabel!
    @IBOutlet weak var right_2000_prev: UILabel!
    @IBOutlet weak var right_4000_prev: UILabel!
    @IBOutlet weak var right_8000_prev: UILabel!
    
    func configureView() {
        // Set up view
        if test != nil {
            
            let titleTest = test.test_id ?? ""
            let titlePatient = test.patient_id ?? ""
            title = "\(titleTest) - \(titlePatient)"
            
            testId.text = test.test_id
            testDate.text = test.mediumDateString(test.test_date)
            testTime.text = test.mediumTimeString(test.test_date)
//            testLocation.text = test.getOption("locations",key: test.test_location)
//            testType.text = test.getOption("types",key: test.test_type)
            testLocation.text = test.getLocation()
            testLocation.text = test.getType()
            
            patientId.text = test.patient_id
            patientDOB.text = test.mediumDateString(test.patient_dob)
            patientAge.text = test.patient_age
            patientGender.text = test.getOption("genders",index: test.patient_gender)
            
            history.text = test.getOption("yesno", index: test.history)
            history_ear.text = test.getOption("ears", index: test.history_ear)
            history_ringing.text = test.getOption("yesno", index: test.history_ringing)
            history_timing.text = test.history_timing
            
            baseline_creatinine.text = test.baseline_creatinine
            baseline_ag_start_date.text = test.mediumDateString(test.baseline_ag_start_date)
            baseline_streptomycin.text = test.getOption("yesno", index: test.baseline_streptomycin)
            
            monthly_ag_dose.text = test.monthly_ag_dose
            monthly_ag_frequency.text = test.monthly_ag_frequency
            monthly_ag_level.text = test.monthly_ag_level
            monthly_ag_route.text = test.getOption("ag_routes", index: test.monthly_ag_route)
            monthly_ag_type.text = test.getOption("ag_types", index:test.monthly_ag_type)
            monthly_creatinine_level.text = test.monthly_creatinine_level
            monthly_furosemide.text = test.getOption("yesno", index: test.monthly_furosemide)
            
            left_fluid.text = test.getOption("severity", index: test.left_fluid)
            left_infection.text = test.getOption("severity", index: test.left_infection)
            left_normal.text = test.getOption("yesno", index: test.left_normal)
            left_perforated.text = test.getOption("severity", index: test.left_perforated)
            left_wax.text = test.getOption("severity", index: test.left_wax)
            
            right_fluid.text = test.getOption("severity", index: test.right_fluid)
            right_infection.text = test.getOption("severity", index: test.right_infection)
            right_normal.text = test.getOption("yesno", index: test.right_normal)
            right_perforated.text = test.getOption("severity", index: test.right_perforated)
            right_wax.text = test.getOption("severity", index: test.right_wax)
            
            left_125.text = test.left_125
            left_250.text = test.left_250
            left_500.text = test.left_500
            left_1000.text = test.left_1000
            left_2000.text = test.left_2000
            left_4000.text = test.left_4000
            left_8000.text = test.left_8000
            
            right_125.text = test.right_125
            right_250.text = test.right_250
            right_500.text = test.right_500
            right_1000.text = test.right_1000
            right_2000.text = test.right_2000
            right_4000.text = test.right_4000
            right_8000.text = test.right_8000
            
            
            if(test_prev != nil) {
/*
                left_fluid_prev.text = test_prev!.left_fluid
                left_infection_prev.text = test_prev!.left_infection
                left_normal_prev.text = test_prev!.left_normal
                left_perforated_prev.text = test_prev!.left_perforated
                left_wax_prev.text = test_prev!.left_wax
                
                right_fluid_prev.text = test_prev!.right_fluid
                right_infection_prev.text = test_prev!.right_infection
                right_normal_prev.text = test_prev!.right_normal
                right_perforated_prev.text = test_prev!.right_perforated
                right_wax_prev.text = test_prev!.right_wax
*/
                

                left_125_prev.text = test_prev!.left_125
                left_250_prev.text = test_prev!.left_250
                left_500_prev.text = test_prev!.left_500
                left_1000_prev.text = test_prev!.left_1000
                left_2000_prev.text = test_prev!.left_2000
                left_4000_prev.text = test_prev!.left_4000
                left_8000_prev.text = test_prev!.left_8000
                
                right_125_prev.text = test_prev!.right_125
                right_250_prev.text = test_prev!.right_250
                right_500_prev.text = test_prev!.right_500
                right_1000_prev.text = test_prev!.right_1000
                right_2000_prev.text = test_prev!.right_2000
                right_4000_prev.text = test_prev!.right_4000
                right_8000_prev.text = test_prev!.right_8000
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    // MARK: - Save Contect on Close
    
    override func viewWillDisappear(animated: Bool) {
        saveTestContext()
    }
    
    func saveTestContext() {
        if(test.hasChanges) {
            println("item changed, saving context")
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            var error: NSError?
            if(!managedContext.save(&error)) {
                println(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println(test)
        
        if (segue.identifier == "TestDetailEdit") {
            let toView = segue.destinationViewController as! TestDetailEditViewController
            toView.test = test
            
        } else if (segue.identifier == "PatientDetailEdit") {
            let toView = segue.destinationViewController as! PatientDetailEditViewController
            toView.test = test
            
        } else if (segue.identifier == "HistoryDetail") {
            let toView = segue.destinationViewController as! HistoryDetailViewController
            toView.test = test
            
        } else if (segue.identifier == "BaselineDetail") {
            let toView = segue.destinationViewController as! BaselineDetailViewController
            toView.test = test
            
        } else if (segue.identifier == "MonthlyDetail") {
            let toView = segue.destinationViewController as! MonthlyDetailViewController
            toView.test = test
            
            
        } else if (segue.identifier == "OtoscopyDetail") {
            let toView = segue.destinationViewController as! OtoscopyDetailsViewController
            toView.test = test
            
        } else if (segue.identifier == "ConductionDetail") {
            let toNavView = segue.destinationViewController as! UINavigationController
            let toView = toNavView.viewControllers[0] as! ConductionDetailTableViewController
            
            var left_rows = [[String:AnyObject?]]()
            left_rows.append(["label":"125 Hz","value":test.left_125])
            left_rows.append(["label":"250 Hz","value":test.left_250])
            left_rows.append(["label":"500 Hz","value":test.left_500])
            left_rows.append(["label":"1000 Hz","value":test.left_1000])
            left_rows.append(["label":"2000 Hz","value":test.left_2000])
            left_rows.append(["label":"4000 Hz","value":test.left_4000])
            left_rows.append(["label":"8000 Hz","value":test.left_8000])
            
            var right_rows = [[String:AnyObject?]]()
            right_rows.append(["label":"125 Hz","value":test.right_125])
            right_rows.append(["label":"250 Hz","value":test.right_250])
            right_rows.append(["label":"500 Hz","value":test.right_500])
            right_rows.append(["label":"1000 Hz","value":test.right_1000])
            right_rows.append(["label":"2000 Hz","value":test.right_2000])
            right_rows.append(["label":"4000 Hz","value":test.right_4000])
            right_rows.append(["label":"8000 Hz","value":test.right_8000])
            
            toView.sections = ["Left Ear","Right Ear"]
            toView.rows = [left_rows,right_rows]
        }

    }
    
    @IBAction func modalSave(sender: UIStoryboardSegue) {
        println("modalSave")
        
        if (sender.identifier == "TestDetailSave") {
            let controller = sender.sourceViewController as? TestDetailEditViewController
            self.test.patient_id = controller?.patient_id.text
            self.test.test_id = controller?.test_id.text
            self.test.test_date = controller?.test_date.date
            self.test.test_location = controller?.test_location.selectedSegmentIndex.description
            self.test.test_type = controller?.test_type.selectedSegmentIndex.description
            
            // Lookup Patient Id to get previous test details
            if self.test.patient_id != nil {
                println("Looking up previous test with patient id = \(self.test.patient_id!)")
                let context = test.managedObjectContext!
                let fetchRequest = NSFetchRequest(entityName:"Test")
                let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                let predicate = NSPredicate(format: "patient_id == %@ && test_id != %@", argumentArray: [self.test.patient_id!, self.test.test_id!])
                fetchRequest.predicate = predicate
                
                // Execute the fetch request, and cast the results to an array of LogItem objects
                var err : NSError?
                if let results = context.executeFetchRequest(fetchRequest, error: &err) as! [Test]? {
                    self.test_prev = results.first
                    
                    println(self.test_prev)
                    
                    // update DOB, Age, Gender from prev test
                    self.test.patient_age = self.test_prev?.patient_age
                    self.test.patient_dob = self.test_prev?.patient_dob
                    self.test.patient_gender = self.test_prev?.patient_gender
                    
                    // if test type > 0 (not Baseline), update baseline data from prev test
                    if(self.test.test_type?.toInt() > 0) {
                        self.test.baseline_ag_start_date = self.test_prev?.baseline_ag_start_date
                        self.test.baseline_creatinine = self.test_prev?.baseline_creatinine
                        self.test.baseline_streptomycin = self.test_prev?.baseline_streptomycin                        
                    }
                }
                if (err != nil) {
                    println(err)
                }
            }

        } else if (sender.identifier == "PatientDetailSave") {
            let controller = sender.sourceViewController as? PatientDetailEditViewController
            self.test.patient_id = controller?.idTextField.text
            self.test.patient_age = controller?.ageTextField.text
            self.test.patient_dob = controller?.datePicker.date
            self.test.patient_gender = controller?.genderSegment.selectedSegmentIndex.description
            
        
        } else if (sender.identifier == "HistoryDetailSave") {
            let controller = sender.sourceViewController as? HistoryDetailViewController
            self.test.history = controller?.HistorySegmentedControl.selectedSegmentIndex.description
            self.test.history_ear = controller?.HistoryEarSegmentedControl.selectedSegmentIndex.description
            self.test.history_timing = controller?.HistoryTimingTextField.text
            self.test.history_ringing = controller?.HistoryRingingSegmentedControl.selectedSegmentIndex.description
            
        } else if(sender.identifier == "BaselineDetailSave"){
            let controller = sender.sourceViewController as? BaselineDetailViewController
            self.test.baseline_creatinine = controller?.baseline_creatinine.text
            self.test.baseline_ag_start_date = controller?.baseline_ag_start_date.date
            self.test.baseline_streptomycin = controller?.baseline_streptomycin.selectedSegmentIndex.description
            
        } else if(sender.identifier == "MonthlyDetailSave"){
            let controller = sender.sourceViewController as? MonthlyDetailViewController
            self.test.monthly_ag_dose = controller?.monthly_ag_dose.text
            self.test.monthly_ag_frequency = controller?.monthly_ag_frequency.text
            self.test.monthly_ag_level = controller?.monthly_ag_level.text
            self.test.monthly_ag_route = controller?.monthly_ag_route.selectedSegmentIndex.description
            self.test.monthly_ag_type = controller?.monthly_ag_type.selectedSegmentIndex.description
            self.test.monthly_creatinine_level = controller?.monthly_creatinine_level.text
            self.test.monthly_furosemide = controller?.monthly_furosemide.selectedSegmentIndex.description
            
        } else if(sender.identifier == "OtoscopyDetailSave"){
            let controller = sender.sourceViewController as? OtoscopyDetailsViewController
            
            self.test.left_normal = controller?.left_normal.selectedSegmentIndex.description
            self.test.left_wax = controller?.left_wax.selectedSegmentIndex.description
            self.test.left_infection = controller?.left_infection.selectedSegmentIndex.description
            self.test.left_perforated = controller?.left_perforated.selectedSegmentIndex.description
            self.test.left_fluid = controller?.left_fluid.selectedSegmentIndex.description
            self.test.left_notes = controller?.left_notes.text
            
            self.test.right_normal = controller?.right_normal.selectedSegmentIndex.description
            self.test.right_wax = controller?.right_wax.selectedSegmentIndex.description
            self.test.right_infection = controller?.right_infection.selectedSegmentIndex.description
            self.test.right_perforated = controller?.right_perforated.selectedSegmentIndex.description
            self.test.right_fluid = controller?.right_fluid.selectedSegmentIndex.description
            self.test.left_notes = controller?.left_notes.text
                        
        } else if(sender.identifier == "ConductionDetailSave"){
            let controller = sender.sourceViewController as? ConductionDetailTableViewController
            
            test.left_125 = controller?.rows[0][0]["value"] as! String?
            test.left_250 = controller?.rows[0][1]["value"] as! String?
            test.left_500 = controller?.rows[0][2]["value"] as! String?
            test.left_1000 = controller?.rows[0][3]["value"] as! String?
            test.left_2000 = controller?.rows[0][4]["value"] as! String?
            test.left_4000 = controller?.rows[0][5]["value"] as! String?
            test.left_8000 = controller?.rows[0][6]["value"] as! String?
            
            test.right_125 = controller?.rows[1][0]["value"] as! String?
            test.right_250 = controller?.rows[1][1]["value"] as! String?
            test.right_500 = controller?.rows[1][2]["value"] as! String?
            test.right_1000 = controller?.rows[1][3]["value"] as! String?
            test.right_2000 = controller?.rows[1][4]["value"] as! String?
            test.right_4000 = controller?.rows[1][5]["value"] as! String?
            test.right_8000 = controller?.rows[1][6]["value"] as! String?
            
        }
        
        
        
        // save managed context and refresh view
        saveTestContext()
        configureView()
        
        sender.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func modalCancel(sender: UIStoryboardSegue) {
        println("modalCancel")
        sender.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    @IBAction func valueChanged(sender: AnyObject) {
    if let field = sender as? ManagedTextField {
    let key = field.key
    var value : AnyObject?
    
    if let attributeDescription = test.entity.attributesByName[key] as? NSAttributeDescription {
    switch attributeDescription.attributeType {
    case NSAttributeType.StringAttributeType : value = field.text
    case NSAttributeType.DoubleAttributeType : value = (field.text as NSString).doubleValue
    case NSAttributeType.DateAttributeType : println("date")
    default : value = field.text
    }
    }
    
    test.setValue(value, forKey: key)
    
    
    } else if let field = sender as? ManagedSegmentedControl {
    let key = field.key
    let value = field.selectedSegmentIndex
    
    
    test.setValue(value, forKey: key)
    }
    }
    
    */
    
}
