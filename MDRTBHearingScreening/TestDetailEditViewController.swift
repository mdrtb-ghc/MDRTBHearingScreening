//
//  TestDetailEditViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 4/2/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import Foundation

class TestDetailEditViewController: UIViewController {

    var test: Test!
    
    @IBOutlet weak var patient_id: UITextField!
    @IBOutlet weak var test_id: UITextField!
    
    var test_date = UIDatePicker()
    @IBOutlet weak var test_date_button: DesignableButton!
    @IBAction func test_date_button_tapped(sender: DesignableButton) {
        
        test_date.addTarget(self, action: "test_date_changed", forControlEvents: UIControlEvents.ValueChanged)
        
        let picker_view = UIView()
        let picker_controller = UIViewController()
        picker_view.addSubview(test_date)
        picker_controller.view = picker_view
        
        let popover_controller = UIPopoverController(contentViewController: picker_controller)
        popover_controller.setPopoverContentSize(CGSize(width: 320, height: 216), animated: true)
        popover_controller.presentPopoverFromRect(CGRect(x: test_date_button.frame.width/2, y: test_date_button.frame.height, width: 0, height: 0), inView: test_date_button, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
    }
    func test_date_changed() {
        test_date_button.setTitle(test.mediumDateString(test_date.date), forState: UIControlState.Normal)
    }
    
    @IBOutlet weak var test_location: UISegmentedControl!
    @IBOutlet weak var test_type: UISegmentedControl!
    
    var patient_dob = UIDatePicker()
    @IBOutlet weak var patient_dob_button: DesignableButton!
    @IBAction func patient_dob_button_tapped(sender: DesignableButton) {
        
        patient_dob.datePickerMode = UIDatePickerMode.Date
        patient_dob.addTarget(self, action: "patient_dob_changed", forControlEvents: UIControlEvents.ValueChanged)
        
        let picker_view = UIView()
        let picker_controller = UIViewController()
        picker_view.addSubview(patient_dob)
        picker_controller.view = picker_view
        
        let popover_controller = UIPopoverController(contentViewController: picker_controller)
        popover_controller.setPopoverContentSize(CGSize(width: 320, height: 216), animated: true)
        popover_controller.presentPopoverFromRect(CGRect(x: patient_dob_button.frame.width/2, y: patient_dob_button.frame.height, width: 0, height: 0), inView: patient_dob_button, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
    }
    func patient_dob_changed() {
        patient_dob_button.setTitle(test.mediumDateString(patient_dob.date), forState: UIControlState.Normal)
        
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let components = calendar.components(.Year, fromDate: patient_dob.date, toDate: NSDate(), options: [])
        let years = components.year
        patient_age.text = String(years)
    }
    
    @IBOutlet weak var patient_age: UITextField!
    @IBOutlet weak var patient_gender: UISegmentedControl!
    @IBOutlet weak var patient_consent: UISegmentedControl!
    
    @IBAction func patient_age_changed(sender: UITextField) {
        if let age = Int(sender.text ?? "") {
            let calendar = NSCalendar.autoupdatingCurrentCalendar()
            if let dob = calendar.dateByAddingUnit(.Year, value: -age, toDate: NSDate(), options: []) {
                patient_dob.date = dob
                patient_dob_button.setTitle(test.mediumDateString(dob), forState: UIControlState.Normal)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(test.test_id ?? "") - Details"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "goNext")
        
        patient_id.text = test.patient_id
        test_id.text = test.test_id
        
        test_date.setDate(test.getDate("test_date") ?? NSDate(), animated: true)
        test_date_button.setTitle(test.mediumDateString(test.getDate("test_date")), forState: UIControlState.Normal)
        
        test_location.selectedSegmentIndex = (Int(test.test_location ?? "") ?? UISegmentedControlNoSegment)
        test_type.selectedSegmentIndex = (Int(test.test_type ?? "") ?? UISegmentedControlNoSegment)
        
        patient_dob.setDate(test.getDate("patient_dob") ?? NSDate(timeIntervalSince1970: 0), animated: true)
        patient_dob_button.setTitle(test.mediumDateString(test.getDate("patient_dob")), forState: UIControlState.Normal)
        patient_age.text = test.patient_age
        patient_gender.selectedSegmentIndex = (Int(test.patient_gender ?? "") ?? UISegmentedControlNoSegment)
        patient_consent.selectedSegmentIndex = (Int(test.patient_consent ?? "") ?? UISegmentedControlNoSegment)
    }
    
    // MARK: - Save Context on Close
    override func viewWillDisappear(animated: Bool) {
        // update test
        updateTest()
        test.saveTestContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTest() {
        
        test.test_id = test.test_id?.stringByReplacingOccurrencesOfString(test.patient_id ?? "", withString: patient_id.text ?? "")
        test.patient_id = patient_id.text
        // update baseline data from previous baseline test, in case patient id changed
        test._baseline_test = nil
        if let baselinetest = test.baseline_test {
            test.baseline_creatinine = baselinetest.baseline_creatinine
            test.baseline_ag_start_date = baselinetest.baseline_ag_start_date
            test.baseline_streptomycin = baselinetest.baseline_streptomycin
            test.baseline_capreomycin = baselinetest.baseline_capreomycin
            test.baseline_kanamicin = baselinetest.baseline_kanamicin
            test.baseline_amikacin = baselinetest.baseline_amikacin
            test.baseline_ag_dose_gt_3 = baselinetest.baseline_ag_dose_gt_3
        }
        
        test.date_modified = Test.getStringFromDate(NSDate(), includeTime: true)
        
        test.test_date = Test.getStringFromDate(test_date.date,includeTime: true)
        test.test_location = "\(test_location.selectedSegmentIndex)"
        test.test_type = "\(test_type.selectedSegmentIndex)"
        
        test.patient_dob = Test.getStringFromDate(patient_dob.date)
        test.patient_age = patient_age.text
        test.patient_gender = "\(patient_gender.selectedSegmentIndex)"
        test.patient_consent = "\(patient_consent.selectedSegmentIndex)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        updateTest()
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? HistoryDetailViewController {
                destinationController.test = test
            }
        }
        if (segue.identifier == "gotoOtoscopy") {
            if let destinationController = segue.destinationViewController as? OtoscopyDetailsViewController {
                destinationController.test = test
            }
        }
    }
}
