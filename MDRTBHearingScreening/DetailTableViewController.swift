//
//  DetailTableViewController.swift
//  MDRTBHearingScreening
//
//  Created by Laura Greisman on 3/29/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    var test : Test!
    
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
    
    @IBOutlet weak var baseline_tablecell: UITableViewCell!
    @IBOutlet weak var baseline_creatinine: UILabel!
    @IBOutlet weak var baseline_ag_start_date: UILabel!
    @IBOutlet weak var baseline_streptomycin: UILabel!
    @IBOutlet weak var baseline_capreomycin: UILabel!
    @IBOutlet weak var baseline_kanamicin: UILabel!
    @IBOutlet weak var baseline_amikacin: UILabel!
    @IBOutlet weak var baseline_ag_dose_gt_3: UILabel!
    
    @IBOutlet weak var monthly_ag_type: UILabel!
    @IBOutlet weak var monthly_ag_dose: UILabel!
    @IBOutlet weak var monthly_ag_frequency: UILabel!
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
   
    @IBOutlet weak var outcome_hearingloss: UILabel!
    @IBOutlet weak var outcome_hearingloss_ag: UILabel!
    @IBOutlet weak var outcome_plan: UILabel!
    @IBOutlet weak var outcome_comments: UILabel!
    
    func configureView() {
        // Set up view
        if test != nil {
            
            testId.text = test.test_id
            testDate.text = test.mediumDateString(test.getDate("test_date"))
            testTime.text = test.mediumTimeString(test.getDate("test_date"))
            testLocation.text = test.getLocation()
            testType.text = test.getType()
            
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
            if let test_baseline = test.baseline_test {
                right_125_baseline.text = test_baseline.right_125
                right_250_baseline.text = test_baseline.right_250
                right_500_baseline.text = test_baseline.right_500
                right_1000_baseline.text = test_baseline.right_1000
                right_2000_baseline.text = test_baseline.right_2000
                right_4000_baseline.text = test_baseline.right_4000
                right_8000_baseline.text = test_baseline.right_8000
                
                
                left_125_baseline.text = test_baseline.left_125
                left_250_baseline.text = test_baseline.left_250
                left_500_baseline.text = test_baseline.left_500
                left_1000_baseline.text = test_baseline.left_1000
                left_2000_baseline.text = test_baseline.left_2000
                left_4000_baseline.text = test_baseline.left_4000
                left_8000_baseline.text = test_baseline.left_8000
                
                
                // check for hearing loss
                let dbDiffs_right = [
                    (right_125_bg,calcDbDiff(test.right_125, baseline: test_baseline.right_125)),
                    (right_250_bg,calcDbDiff(test.right_250, baseline: test_baseline.right_250)),
                    (right_500_bg,calcDbDiff(test.right_500, baseline: test_baseline.right_500)),
                    (right_1000_bg,calcDbDiff(test.right_1000, baseline: test_baseline.right_1000)),
                    (right_2000_bg,calcDbDiff(test.right_2000, baseline: test_baseline.right_2000)),
                    (right_4000_bg,calcDbDiff(test.right_4000, baseline: test_baseline.right_4000)),
                    (right_8000_bg,calcDbDiff(test.right_8000, baseline: test_baseline.right_8000))
                ]
                displayHearingLossAlerts(dbDiffs_right)
                let dbDiffs_left = [
                    (left_125_bg,calcDbDiff(test.left_125, baseline: test_baseline.left_125)),
                    (left_250_bg,calcDbDiff(test.left_250, baseline: test_baseline.left_250)),
                    (left_500_bg,calcDbDiff(test.left_500, baseline: test_baseline.left_500)),
                    (left_1000_bg,calcDbDiff(test.left_1000, baseline: test_baseline.left_1000)),
                    (left_2000_bg,calcDbDiff(test.left_2000, baseline: test_baseline.left_2000)),
                    (left_4000_bg,calcDbDiff(test.left_4000, baseline: test_baseline.left_4000)),
                    (left_8000_bg,calcDbDiff(test.left_8000, baseline: test_baseline.left_8000))
                ]
                displayHearingLossAlerts(dbDiffs_left)
            }
            
            outcome_hearingloss.text = test.outcome_hearingloss == "0" ? "No" : (test.outcome_hearingloss == "1" ? "Yes" : "")
            outcome_hearingloss_ag.text = test.outcome_hearingloss_ag == "0" ? "No" : (test.outcome_hearingloss_ag == "1" ? "Yes" : "")
            
            if(test.outcome_plan == "1") {
                outcome_plan.text = "Stop Injectables"
            } else if(test.outcome_plan == "2") {
                outcome_plan.text = "Change Dose"
            } else if(test.outcome_plan == "3") {
                outcome_plan.text = "Re-Check in 2 weeks"
            } else if(test.outcome_plan == "4") {
                outcome_plan.text = "Re-Check in 1 month"
            } else if(test.outcome_plan == "5") {
                outcome_plan.text = "Other"
            } else {
                outcome_plan.text = ""
            }
            //outcome_comments.text = test.outcome_comments
            
        }
    }
    
    func calcDbDiff(curr:String?,baseline:String?) -> Int {
        if let curr = curr?.toInt() {
            if let baseline = baseline?.toInt() {
                return curr - baseline
            }
        }
        return 0
    }
    
    func displayHearingLossAlerts(dbDiffs:[(UILabel!, Int)]) {
        for var i = 0;i < dbDiffs.count; i++ {
            dbDiffs[i].0.hidden = !(dbDiffs[i].1 >= 20)
            
            if i < dbDiffs.count-1 && dbDiffs[i].1 >= 10 && dbDiffs[i+1].1 >= 10 {
                dbDiffs[i].0.hidden = false
            }
            if i > 0 && dbDiffs[i].1 >= 10 && dbDiffs[i-1].1 >= 10 {
                dbDiffs[i].0.hidden = false
            }
            
            if i < dbDiffs.count-2 && dbDiffs[i].1 > 0 && dbDiffs[i+1].1 > 0  && dbDiffs[i+2].1 > 0 {
                dbDiffs[i].0.hidden = false
            }
            if i > 0 && i < dbDiffs.count-1 && dbDiffs[i].1 > 0 && dbDiffs[i+1].1 > 0  && dbDiffs[i-1].1 > 0 {
                dbDiffs[i].0.hidden = false
            }
            if i > 1 && dbDiffs[i].1 > 0 && dbDiffs[i-1].1 > 0  && dbDiffs[i-2].1 > 0 {
                dbDiffs[i].0.hidden = false
            }
            
        }
    }
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Results Summary"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Outcomes", style: .Plain, target: self, action: "goNext")
        
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel.font = UIFont.boldSystemFontOfSize(18)
        }
        
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "goNext") {
            let toView = segue.destinationViewController as! OutcomesViewController
            toView.test = test
            
        } else if (segue.identifier == "TestDetailEdit") {
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
            
        } else if (segue.identifier == "RightConductionDetail") {
            let toView = segue.destinationViewController as! AudiometerResultsViewController
            toView.test = test
            toView.ear = "Right"
            
        } else if (segue.identifier == "LeftConductionDetail") {
            let toView = segue.destinationViewController as! AudiometerResultsViewController
            toView.test = test
            toView.ear = "Left"
            
        } else if (segue.identifier == "OutcomeDetail") {
            if let toView = segue.destinationViewController as? OutcomesViewController {
                toView.test = test
            }
        }
    }
    
    @IBAction func closeModal(sender: UIStoryboardSegue) {
        // dismiss modal
        sender.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
        
        // refresh tableview
        configureView()

        // deselect selected row
        if let selectedRow = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(selectedRow, animated: false)
        }
    }
    
}
