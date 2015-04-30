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
    var test_baseline : Test?
    
    func getBaselineTest() -> Test? {
        if(self.test.patient_id != nil && self.test.test_date != nil) {
            println("Looking up Baseline test for patient id = \(self.test.patient_id!)")
            let context = self.test.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName:"Test")
            let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "patient_id == %@ && test_type == \"0\" && test_date < %@", argumentArray: [self.test.patient_id!, self.test.test_date!])
            fetchRequest.predicate = predicate
            
            // Execute the fetch request
            var err : NSError?
            if let results = context.executeFetchRequest(fetchRequest, error: &err) as! [Test]? {
                return results.first
            }
        }
        return nil
    }
    
    @IBOutlet weak var testId: UILabel!
    @IBOutlet weak var testDate: UILabel!
    @IBOutlet weak var testTime: UILabel!
    @IBOutlet weak var testLocation: UILabel!
    @IBOutlet weak var testType: UILabel!
    
    @IBOutlet weak var patientId: UILabel!
    @IBOutlet weak var patientDOB: UILabel!
    @IBOutlet weak var patientAge: UILabel!
    @IBOutlet weak var patientGender: UILabel!
    @IBOutlet weak var patient_eligible: UILabel!
    @IBOutlet weak var patient_consent: UILabel!
    
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var history_ear: UILabel!
    @IBOutlet weak var history_ringing: UILabel!
    @IBOutlet weak var history_timing: UILabel!
    
    @IBOutlet weak var baseline_creatinine: UILabel!
    @IBOutlet weak var baseline_ag_start_date: UILabel!
    @IBOutlet weak var baseline_streptomycin: UILabel!
    @IBOutlet weak var baseline_capreomycin: UILabel!
    @IBOutlet weak var baseline_kanamicin: UILabel!
    @IBOutlet weak var baseline_amikacin: UILabel!
    @IBOutlet weak var baseline_ag_dose_gt_3: UILabel!
    
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
    
    @IBOutlet weak var right_normal: UILabel!
    @IBOutlet weak var right_wax: UILabel!
    @IBOutlet weak var right_infection: UILabel!
    @IBOutlet weak var right_perforated: UILabel!
    @IBOutlet weak var right_fluid: UILabel!
    
    @IBOutlet weak var right_125: UILabel!
    @IBOutlet weak var right_250: UILabel!
    @IBOutlet weak var right_500: UILabel!
    @IBOutlet weak var right_1000: UILabel!
    @IBOutlet weak var right_2000: UILabel!
    @IBOutlet weak var right_4000: UILabel!
    @IBOutlet weak var right_8000: UILabel!
    
    @IBOutlet weak var right_125_baseline: UILabel!
    @IBOutlet weak var right_250_baseline: UILabel!
    @IBOutlet weak var right_500_baseline: UILabel!
    @IBOutlet weak var right_1000_baseline: UILabel!
    @IBOutlet weak var right_2000_baseline: UILabel!
    @IBOutlet weak var right_4000_baseline: UILabel!
    @IBOutlet weak var right_8000_baseline: UILabel!
    
    @IBOutlet weak var right_125_bg: UILabel!
    @IBOutlet weak var right_250_bg: UILabel!
    @IBOutlet weak var right_500_bg: UILabel!
    @IBOutlet weak var right_1000_bg: UILabel!
    @IBOutlet weak var right_2000_bg: UILabel!
    @IBOutlet weak var right_4000_bg: UILabel!
    @IBOutlet weak var right_8000_bg: UILabel!
    
    @IBOutlet weak var left_125: UILabel!
    @IBOutlet weak var left_250: UILabel!
    @IBOutlet weak var left_500: UILabel!
    @IBOutlet weak var left_1000: UILabel!
    @IBOutlet weak var left_2000: UILabel!
    @IBOutlet weak var left_4000: UILabel!
    @IBOutlet weak var left_8000: UILabel!
    
    @IBOutlet weak var left_125_baseline: UILabel!
    @IBOutlet weak var left_250_baseline: UILabel!
    @IBOutlet weak var left_500_baseline: UILabel!
    @IBOutlet weak var left_1000_baseline: UILabel!
    @IBOutlet weak var left_2000_baseline: UILabel!
    @IBOutlet weak var left_4000_baseline: UILabel!
    @IBOutlet weak var left_8000_baseline: UILabel!
    
    @IBOutlet weak var left_125_bg: UILabel!
    @IBOutlet weak var left_250_bg: UILabel!
    @IBOutlet weak var left_500_bg: UILabel!
    @IBOutlet weak var left_1000_bg: UILabel!
    @IBOutlet weak var left_2000_bg: UILabel!
    @IBOutlet weak var left_4000_bg: UILabel!
    @IBOutlet weak var left_8000_bg: UILabel!
   
    @IBOutlet weak var outcome_hearing: UILabel!
    @IBOutlet weak var outcome_recomendation: UILabel!
    @IBOutlet weak var outcome_plan: UILabel!
    @IBOutlet weak var outcome_comments: UILabel!
    
    func configureView() {
        // Set up view
        if test != nil {
            
            let number = test.test_id ?? ""
            let date = test.mediumDateString(test.getDate("test_date"))
            let type = test.getType()
            title = "#\(number) | \(date) | \(type)"
            
            testId.text = test.test_id
            testDate.text = test.mediumDateString(test.getDate("test_date"))
            testTime.text = test.mediumTimeString(test.getDate("test_date"))
            testLocation.text = test.getLocation()
            testType.text = test.getType()
            
            // attempt to get prev baseline test
            if(test_baseline == nil) {
                test_baseline = getBaselineTest()
            }
            // if we have a previous baseline test, use those values for the patient and bsaeline data
            if(test_baseline != nil) {
                test.patient_dob = test_baseline?.patient_dob
                test.patient_age = test_baseline?.patient_age
                test.patient_gender = test_baseline?.patient_gender
                test.patient_consent = test_baseline?.patient_consent
                test.patient_eligible = test_baseline?.patient_eligible
                
                test.baseline_creatinine = test_baseline?.baseline_creatinine
                test.baseline_ag_start_date = test_baseline?.baseline_ag_start_date
                test.baseline_streptomycin = test_baseline?.baseline_streptomycin
                test.baseline_capreomycin = test_baseline?.baseline_capreomycin
                test.baseline_kanamicin = test_baseline?.baseline_kanamicin
                test.baseline_amikacin = test_baseline?.baseline_amikacin
                test.baseline_ag_dose_gt_3 = test_baseline?.baseline_ag_dose_gt_3
            }
            
            patientId.text = test.patient_id
            patientDOB.text = test.mediumDateString(test.getDate("patient_dob"))
            patientAge.text = test.patient_age
            patientGender.text = test.getOption("genders",index: test.patient_gender)
            patient_consent.text = test.hasConsent()
            patient_eligible.text = test.isEligible()
            
            history.text = test.getOption("yesno", index: test.history)
            history_ear.text = test.getOption("ears", index: test.history_ear)
            history_ringing.text = test.getOption("yesno", index: test.history_ringing)
            history_timing.text = test.history_timing
            
            baseline_creatinine.text = test.baseline_creatinine
            baseline_ag_start_date.text = test.mediumDateString(test.getDate("baseline_ag_start_date"))
            baseline_streptomycin.text = test.getOption("yesno", index: test.baseline_streptomycin)
            baseline_capreomycin.text = test.getOption("yesno", index: test.baseline_capreomycin)
            baseline_kanamicin.text = test.getOption("yesno", index: test.baseline_kanamicin)
            baseline_amikacin.text = test.getOption("yesno", index: test.baseline_amikacin)
            baseline_ag_dose_gt_3.text = test.getOption("yesno", index: test.baseline_ag_dose_gt_3)
            
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
            
            
            right_125.text = test.right_125
            right_250.text = test.right_250
            right_500.text = test.right_500
            right_1000.text = test.right_1000
            right_2000.text = test.right_2000
            right_4000.text = test.right_4000
            right_8000.text = test.right_8000
            
            left_125.text = test.left_125
            left_250.text = test.left_250
            left_500.text = test.left_500
            left_1000.text = test.left_1000
            left_2000.text = test.left_2000
            left_4000.text = test.left_4000
            left_8000.text = test.left_8000
            
            // display baseline audiometer results for comparison
            if(test_baseline != nil) {
                right_125_baseline.text = test_baseline!.right_125
                right_250_baseline.text = test_baseline!.right_250
                right_500_baseline.text = test_baseline!.right_500
                right_1000_baseline.text = test_baseline!.right_1000
                right_2000_baseline.text = test_baseline!.right_2000
                right_4000_baseline.text = test_baseline!.right_4000
                right_8000_baseline.text = test_baseline!.right_8000
                
                
                left_125_baseline.text = test_baseline!.left_125
                left_250_baseline.text = test_baseline!.left_250
                left_500_baseline.text = test_baseline!.left_500
                left_1000_baseline.text = test_baseline!.left_1000
                left_2000_baseline.text = test_baseline!.left_2000
                left_4000_baseline.text = test_baseline!.left_4000
                left_8000_baseline.text = test_baseline!.left_8000
                
                
                // check levels
                isDbLoss20(test.right_125,baselineDb:test_baseline?.right_125,currLabel:right_125,baselineLabel:right_125_baseline,bgLabel:right_125_bg)
                isDbLoss20(test.right_250,baselineDb:test_baseline?.right_250,currLabel:right_250,baselineLabel:right_250_baseline,bgLabel:right_250_bg)
                isDbLoss20(test.right_500,baselineDb:test_baseline?.right_500,currLabel:right_500,baselineLabel:right_500_baseline,bgLabel:right_500_bg)
                isDbLoss20(test.right_1000,baselineDb:test_baseline?.right_1000,currLabel:right_1000,baselineLabel:right_1000_baseline,bgLabel:right_1000_bg)
                isDbLoss20(test.right_2000,baselineDb:test_baseline?.right_2000,currLabel:right_2000,baselineLabel:right_2000_baseline,bgLabel:right_2000_bg)
                isDbLoss20(test.right_4000,baselineDb:test_baseline?.right_4000,currLabel:right_4000,baselineLabel:right_4000_baseline,bgLabel:right_4000_bg)
                isDbLoss20(test.right_8000,baselineDb:test_baseline?.right_8000,currLabel:right_8000,baselineLabel:right_8000_baseline,bgLabel:right_8000_bg)

                isDbLoss20(test.left_125,baselineDb:test_baseline?.left_125,currLabel:left_125,baselineLabel:left_125_baseline,bgLabel:left_125_bg)
                isDbLoss20(test.left_250,baselineDb:test_baseline?.left_250,currLabel:left_250,baselineLabel:left_250_baseline,bgLabel:left_250_bg)
                isDbLoss20(test.left_500,baselineDb:test_baseline?.left_500,currLabel:left_500,baselineLabel:left_500_baseline,bgLabel:left_500_bg)
                isDbLoss20(test.left_1000,baselineDb:test_baseline?.left_1000,currLabel:left_1000,baselineLabel:left_1000_baseline,bgLabel:left_1000_bg)
                isDbLoss20(test.left_2000,baselineDb:test_baseline?.left_2000,currLabel:left_2000,baselineLabel:left_2000_baseline,bgLabel:left_2000_bg)
                isDbLoss20(test.left_4000,baselineDb:test_baseline?.left_4000,currLabel:left_4000,baselineLabel:left_4000_baseline,bgLabel:left_4000_bg)
                isDbLoss20(test.left_8000,baselineDb:test_baseline?.left_8000,currLabel:left_8000,baselineLabel:left_8000_baseline,bgLabel:left_8000_bg)

            }
            
        }
    }
    
    
    func isDbLoss20(currDb: String?, baselineDb: String?, currLabel:UILabel, baselineLabel:UILabel, bgLabel:UILabel) -> Bool {
        
        let curr = currDb?.toInt() ?? 0 as Int
        let baseline = baselineDb?.toInt() ?? 0 as Int
        
        if curr - baseline >= 20 {
            currLabel.textColor = UIColor.whiteColor()
            baselineLabel.textColor = UIColor.whiteColor()
            bgLabel.hidden = false
            return true
        } else {
            return false
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
            
        } else if (segue.identifier == "LeftConductionDetail") {
            let toNavView = segue.destinationViewController as! UINavigationController
            let toView = toNavView.viewControllers[0] as! ConductionDetailTableViewController
            
            var rows = [[String:String?]]()
            rows.append(["label":"125 Hz","value":test.left_125])
            rows.append(["label":"250 Hz","value":test.left_250])
            rows.append(["label":"500 Hz","value":test.left_500])
            rows.append(["label":"1000 Hz","value":test.left_1000])
            rows.append(["label":"2000 Hz","value":test.left_2000])
            rows.append(["label":"4000 Hz","value":test.left_4000])
            rows.append(["label":"8000 Hz","value":test.left_8000])
            
            toView.rows = rows
            toView.title = "Left Ear Audiometer Test"
            toView.sections = ["Left"]
            
        } else if (segue.identifier == "RightConductionDetail") {
            let toNavView = segue.destinationViewController as! UINavigationController
            let toView = toNavView.viewControllers[0] as! ConductionDetailTableViewController
            
            var rows = [[String:String?]]()
            rows.append(["label":"125 Hz","value":test.right_125])
            rows.append(["label":"250 Hz","value":test.right_250])
            rows.append(["label":"500 Hz","value":test.right_500])
            rows.append(["label":"1000 Hz","value":test.right_1000])
            rows.append(["label":"2000 Hz","value":test.right_2000])
            rows.append(["label":"4000 Hz","value":test.right_4000])
            rows.append(["label":"8000 Hz","value":test.right_8000])
            
            toView.rows = rows
            toView.title = "Right Ear Audiometer Tests"
            toView.sections = ["Right"]
        }

    }
    
    @IBAction func modalSave(sender: UIStoryboardSegue) {
        println("modalSave")
        
        if (sender.identifier == "TestDetailSave") {
            let controller = sender.sourceViewController as? TestDetailEditViewController
            
            self.test.test_id = controller?.test_id.text
            self.test.test_date = controller?.test_date.date.descriptionWithLocale(nil)
            self.test.test_location = controller?.test_location.selectedSegmentIndex < 0 ? "" : controller?.test_location.selectedSegmentIndex.description
            self.test.test_type = controller?.test_type.selectedSegmentIndex < 0 ? "" : controller?.test_type.selectedSegmentIndex.description

        } else if (sender.identifier == "PatientDetailSave") {
            let controller = sender.sourceViewController as? PatientDetailEditViewController
            
            self.test.patient_age = controller?.ageTextField.text
            self.test.patient_dob = controller?.datePicker.date.descriptionWithLocale(nil)
            self.test.patient_gender = controller?.genderSegment.selectedSegmentIndex < 0 ? "" : controller?.genderSegment.selectedSegmentIndex.description
            self.test.patient_consent = controller?.consentSegment.selectedSegmentIndex < 0 ? "" : controller?.consentSegment.selectedSegmentIndex.description
        
        } else if (sender.identifier == "HistoryDetailSave") {
            let controller = sender.sourceViewController as? HistoryDetailViewController
            
            self.test.history = controller?.HistorySegmentedControl.selectedSegmentIndex < 0 ? "" : controller?.HistorySegmentedControl.selectedSegmentIndex.description
            self.test.history_ear = controller?.HistoryEarSegmentedControl.selectedSegmentIndex < 0 ? "" : controller?.HistoryEarSegmentedControl.selectedSegmentIndex.description
            self.test.history_timing = controller?.HistoryTimingTextField.text
            self.test.history_ringing = controller?.HistoryRingingSegmentedControl.selectedSegmentIndex < 0 ? "" : controller?.HistoryRingingSegmentedControl.selectedSegmentIndex.description
            
        } else if(sender.identifier == "BaselineDetailSave"){
            let controller = sender.sourceViewController as? BaselineDetailViewController
            
            self.test.baseline_creatinine = controller?.baseline_creatinine.text
            self.test.baseline_ag_start_date = controller?.baseline_ag_start_date.date.descriptionWithLocale(nil)
            
            self.test.baseline_streptomycin = controller?.baseline_streptomycin.selectedSegmentIndex > 0 ? "" : controller?.baseline_streptomycin.selectedSegmentIndex.description
            self.test.baseline_capreomycin = controller?.baseline_capreomycin.selectedSegmentIndex < 0 ? "" : controller?.baseline_capreomycin.selectedSegmentIndex.description
            self.test.baseline_kanamicin = controller?.baseline_kanamicin.selectedSegmentIndex < 0 ? "" : controller?.baseline_kanamicin.selectedSegmentIndex.description
            self.test.baseline_amikacin = controller?.baseline_amikacin.selectedSegmentIndex < 0 ? "" : controller?.baseline_amikacin.selectedSegmentIndex.description
            self.test.baseline_ag_dose_gt_3 = controller?.baseline_ag_dose_gt_3.selectedSegmentIndex < 0 ? "" : controller?.baseline_ag_dose_gt_3.selectedSegmentIndex.description
            
        } else if(sender.identifier == "MonthlyDetailSave"){
            let controller = sender.sourceViewController as? MonthlyDetailViewController
            self.test.monthly_ag_dose = controller?.monthly_ag_dose.text
            self.test.monthly_ag_frequency = controller?.monthly_ag_frequency.text
            self.test.monthly_ag_level = controller?.monthly_ag_level.text
            self.test.monthly_ag_route = controller?.monthly_ag_route.selectedSegmentIndex < 0 ? "" : controller?.monthly_ag_route.selectedSegmentIndex.description
            self.test.monthly_ag_type = controller?.monthly_ag_type.selectedSegmentIndex < 0 ? "" : controller?.monthly_ag_type.selectedSegmentIndex.description
            self.test.monthly_creatinine_level = controller?.monthly_creatinine_level.text
            self.test.monthly_furosemide = controller?.monthly_furosemide.selectedSegmentIndex < 0 ? "" : controller?.monthly_furosemide.selectedSegmentIndex.description
            
        } else if(sender.identifier == "OtoscopyDetailSave"){
            let controller = sender.sourceViewController as? OtoscopyDetailsViewController
            
            self.test.right_normal = controller?.right_normal.selectedSegmentIndex < 0 ? "" : controller?.right_normal.selectedSegmentIndex.description
            self.test.right_wax = controller?.right_wax.selectedSegmentIndex < 0 ? "" : controller?.right_wax.selectedSegmentIndex.description
            self.test.right_infection = controller?.right_infection.selectedSegmentIndex < 0 ? "" : controller?.right_infection.selectedSegmentIndex.description
            self.test.right_perforated = controller?.right_perforated.selectedSegmentIndex < 0 ? "" : controller?.right_perforated.selectedSegmentIndex.description
            self.test.right_fluid = controller?.right_fluid.selectedSegmentIndex < 0 ? "" : controller?.right_fluid.selectedSegmentIndex.description
            self.test.right_notes = controller?.right_notes.text
            
            self.test.left_normal = controller?.left_normal.selectedSegmentIndex < 0 ? "" : controller?.left_normal.selectedSegmentIndex.description
            self.test.left_wax = controller?.left_wax.selectedSegmentIndex < 0 ? "" : controller?.left_wax.selectedSegmentIndex.description
            self.test.left_infection = controller?.left_infection.selectedSegmentIndex < 0 ? "" : controller?.left_infection.selectedSegmentIndex.description
            self.test.left_perforated = controller?.left_perforated.selectedSegmentIndex < 0 ? "" : controller?.left_perforated.selectedSegmentIndex.description
            self.test.left_fluid = controller?.left_fluid.selectedSegmentIndex < 0 ? "" : controller?.left_fluid.selectedSegmentIndex.description
            self.test.left_notes = controller?.left_notes.text
                        
        } else if(sender.identifier == "ConductionDetailSave"){
            let controller = sender.sourceViewController as? ConductionDetailTableViewController
            
            var selectedIndexPath = self.tableView.indexPathForSelectedRow()
            // decide which data was saved, left or right....
            // Right Ear - Section 6
            if selectedIndexPath?.section == 6 {
                test.right_125 = controller?.rows[0]["value"]!
                test.right_250 = controller?.rows[1]["value"]!
                test.right_500 = controller?.rows[2]["value"]!
                test.right_1000 = controller?.rows[3]["value"]!
                test.right_2000 = controller?.rows[4]["value"]!
                test.right_4000 = controller?.rows[5]["value"]!
                test.right_8000 = controller?.rows[6]["value"]!
            }

            // Left Ear - Section 7
            if selectedIndexPath?.section == 7 {
                test.left_125 = controller?.rows[0]["value"]!
                test.left_250 = controller?.rows[1]["value"]!
                test.left_500 = controller?.rows[2]["value"]!
                test.left_1000 = controller?.rows[3]["value"]!
                test.left_2000 = controller?.rows[4]["value"]!
                test.left_4000 = controller?.rows[5]["value"]!
                test.left_8000 = controller?.rows[6]["value"]!
            }

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
