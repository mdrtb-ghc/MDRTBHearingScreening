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
    
    var baseline_ag_start_date = UIDatePicker()
    @IBOutlet weak var baseline_ag_date_button: DesignableButton!
    @IBAction func baseline_ag_date_button_tapped(sender: DesignableButton) {
        
        baseline_ag_start_date.addTarget(self, action: "baseline_ag_start_date_changed", forControlEvents: UIControlEvents.ValueChanged)
        baseline_ag_start_date.datePickerMode = UIDatePickerMode.Date
        
        let picker_view = UIView()
        let picker_controller = UIViewController()
        picker_view.addSubview(baseline_ag_start_date)
        picker_controller.view = picker_view
        
        let popover_controller = UIPopoverController(contentViewController: picker_controller)
        popover_controller.setPopoverContentSize(CGSize(width: 320, height: 216), animated: true)
        popover_controller.presentPopoverFromRect(CGRect(x: baseline_ag_date_button.frame.width/2, y: baseline_ag_date_button.frame.height, width: 0, height: 0), inView: baseline_ag_date_button, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
    }
    func baseline_ag_start_date_changed() {
        baseline_ag_date_button.setTitle(test.mediumDateString(baseline_ag_start_date.date), forState: UIControlState.Normal)
    }
    
    
    @IBOutlet weak var baseline_ag_start_date_readonly: DesignableTextField!
    @IBOutlet weak var baseline_streptomycin: UISegmentedControl!
    @IBOutlet weak var baseline_capreomycin: UISegmentedControl!
    @IBOutlet weak var baseline_kanamicin: UISegmentedControl!
    @IBOutlet weak var baseline_amikacin: UISegmentedControl!
    @IBOutlet weak var baseline_ag_dose_gt_3: UISegmentedControl!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
        baseline_ag_start_date.setDate(test.getDate("baseline_ag_start_date") ?? NSDate(), animated: true)
        baseline_ag_date_button.setTitle(test.mediumDateString(baseline_ag_start_date.date), forState: UIControlState.Normal)
        baseline_ag_start_date_readonly.text = test.mediumDateString(test.getDate("baseline_ag_start_date"))
        baseline_streptomycin.selectedSegmentIndex = Int(test.baseline_streptomycin ?? "") ?? UISegmentedControlNoSegment
        baseline_capreomycin.selectedSegmentIndex = Int(test.baseline_capreomycin ?? "") ?? UISegmentedControlNoSegment
        baseline_kanamicin.selectedSegmentIndex = Int(test.baseline_kanamicin ?? "") ?? UISegmentedControlNoSegment
        baseline_amikacin.selectedSegmentIndex = Int(test.baseline_amikacin ?? "") ?? UISegmentedControlNoSegment
        baseline_ag_dose_gt_3.selectedSegmentIndex = Int(test.baseline_ag_dose_gt_3 ?? "") ?? UISegmentedControlNoSegment
        
        if let type = test.test_type {
            // if not baseline test disable controls so read only
            baseline_creatinine.enabled = type == "0"
            baseline_creatinine.borderWidth = type == "0" ? 1 : 0
            
            baseline_ag_date_button.enabled = type == "0"
            baseline_ag_date_button.borderWidth = (type == "0") ? 1 : 0
            
            //baseline_ag_start_date.hidden = type != "0"
            //baseline_ag_start_date_readonly.hidden = type == "0"
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
