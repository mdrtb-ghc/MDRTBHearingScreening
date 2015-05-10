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
    
    @IBOutlet weak var test_date: UIDatePicker!
    @IBOutlet weak var test_location: UISegmentedControl!
    @IBOutlet weak var test_type: UISegmentedControl!
    
    @IBOutlet weak var patient_dob: UIDatePicker!
    @IBOutlet weak var patient_age: UITextField!
    @IBOutlet weak var patient_gender: UISegmentedControl!
    @IBOutlet weak var patient_consent: UISegmentedControl!
    
    @IBAction func patient_dob_changed(sender: UIDatePicker) {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let components = calendar.components(.CalendarUnitYear, fromDate: sender.date, toDate: NSDate(), options: nil)
        let years = components.year
        patient_age.text = String(years)
        
    }
    @IBAction func patient_age_changed(sender: UITextField) {
        if let age = sender.text.toInt() {
            let calendar = NSCalendar.autoupdatingCurrentCalendar()
            if let dob = calendar.dateByAddingUnit(.CalendarUnitYear, value: -age, toDate: NSDate(), options: nil) {
                patient_dob.date = dob
            }
        }
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
        
        title = "Test Details"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "goNext")
        
        patient_id.text = test.patient_id
        test_id.text = test.test_id
        
        test_date.setDate(test.getDate("test_date") ?? NSDate(), animated: true)
        test_location.selectedSegmentIndex = (test.test_location?.toInt() ?? UISegmentedControlNoSegment)
        test_type.selectedSegmentIndex = (test.test_type?.toInt() ?? UISegmentedControlNoSegment)
        
        patient_dob.setDate(test.getDate("patient_dob") ?? NSDate(timeIntervalSince1970: 0), animated: true)
        patient_age.text = test.patient_age
        patient_gender.selectedSegmentIndex = (test.patient_gender?.toInt() ?? UISegmentedControlNoSegment)
        patient_consent.selectedSegmentIndex = (test.patient_consent?.toInt() ?? UISegmentedControlNoSegment)
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
        
        test.test_date = Test.getStringFromDate(test_date.date,includeTime: true)
        test.test_location = "\(test_location.selectedSegmentIndex)"
        test.test_type = "\(test_type.selectedSegmentIndex)"
        
        test.patient_dob = Test.getStringFromDate(patient_dob.date)
        test.patient_age = patient_age.text
        test.patient_gender = "\(patient_gender.selectedSegmentIndex)"
        test.patient_consent = "\(patient_consent.selectedSegmentIndex)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
