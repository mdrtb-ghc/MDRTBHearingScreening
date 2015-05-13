//
//  BaselineDetailViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 4/4/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class BaselineDetailViewController: UIViewController {

    var test: Test!
    
    @IBOutlet weak var baseline_creatinine: DesignableTextField!
    @IBOutlet weak var baseline_ag_start_date: UIDatePicker!
    @IBOutlet weak var baseline_streptomycin: UISegmentedControl!
    @IBOutlet weak var baseline_capreomycin: UISegmentedControl!
    @IBOutlet weak var baseline_kanamicin: UISegmentedControl!
    @IBOutlet weak var baseline_amikacin: UISegmentedControl!
    @IBOutlet weak var baseline_ag_dose_gt_3: UISegmentedControl!
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Baseline Treatment"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "goNext")
        
        baseline_creatinine.text = test.baseline_creatinine
        baseline_ag_start_date.maximumDate = NSDate()
        baseline_ag_start_date.setDate(test.getDate("baseline_ag_start_date") ?? NSDate(), animated: true)
        
        baseline_streptomycin.selectedSegmentIndex = test.baseline_streptomycin?.toInt() ?? UISegmentedControlNoSegment
        baseline_capreomycin.selectedSegmentIndex = test.baseline_capreomycin?.toInt() ?? UISegmentedControlNoSegment
        baseline_kanamicin.selectedSegmentIndex = test.baseline_kanamicin?.toInt() ?? UISegmentedControlNoSegment
        baseline_amikacin.selectedSegmentIndex = test.baseline_amikacin?.toInt() ?? UISegmentedControlNoSegment
        baseline_ag_dose_gt_3.selectedSegmentIndex = test.baseline_ag_dose_gt_3?.toInt() ?? UISegmentedControlNoSegment
        
        if let type = test.test_type {
            // if not baseline test disable controls so read only
            baseline_creatinine.enabled = type == "0"
            baseline_creatinine.borderWidth = type == "0" ? 1 : 0
            baseline_ag_start_date.enabled = type == "0"
            baseline_streptomycin.enabled = type == "0"
            baseline_capreomycin.enabled = type == "0"
            baseline_kanamicin.enabled = type == "0"
            baseline_amikacin.enabled = type == "0"
            baseline_ag_dose_gt_3.enabled = type == "0"
        }
    }
    
    // MARK: - Save Context on Close
    override func viewWillDisappear(animated: Bool) {
        // update test
        updateTest()
        //test.saveTestContext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTest() {
        test.date_modified = Test.getStringFromDate(NSDate(), includeTime: true)
        
        test.baseline_creatinine = baseline_creatinine.text
        test.baseline_ag_start_date = Test.getStringFromDate(baseline_ag_start_date.date)
        test.baseline_streptomycin = "\(baseline_streptomycin.selectedSegmentIndex)"
        test.baseline_capreomycin = "\(baseline_capreomycin.selectedSegmentIndex)"
        test.baseline_kanamicin = "\(baseline_kanamicin.selectedSegmentIndex)"
        test.baseline_amikacin = "\(baseline_amikacin.selectedSegmentIndex)"
        test.baseline_ag_dose_gt_3 = "\(baseline_ag_dose_gt_3.selectedSegmentIndex)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        updateTest()
        
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? MonthlyDetailViewController {
                destinationController.test = test
            }
        }
    }
}
