//
//  PatientDetailEditViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 4/3/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class PatientDetailEditViewController: UIViewController {
    
    var test: Test!
    
    lazy var settings : NSDictionary = {
        let customPlistUrl = NSBundle.mainBundle().URLForResource("MDRTBHearingScreening", withExtension: "plist")!
        return NSDictionary(contentsOfURL: customPlistUrl)!
        }()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let components = calendar.components(.Year, fromDate: sender.date, toDate: NSDate(), options: [])
        let years = components.year
        ageTextField.text = String(years)
    
    }
    @IBOutlet weak var ageTextField: UITextField!
    @IBAction func agTextField_Changed(sender: UITextField) {
        if let age = Int(sender.text ?? "") {
            let calendar = NSCalendar.autoupdatingCurrentCalendar()
            if let dob = calendar.dateByAddingUnit(.Year, value: -age, toDate: NSDate(), options: []) {
                datePicker.date = dob
            }

        }
    }
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var consentSegment: UISegmentedControl!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Patient History"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "goNext")

        idTextField.text = test.getString("patient_id")
        datePicker.setDate(test.getDate("patient_dob") ?? NSDate(timeIntervalSince1970: 0), animated: true)
        ageTextField.text = test.patient_age
        if let segments = settings["genders"] as? [String] {
            genderSegment.removeAllSegments()
            for title in segments {
                genderSegment.insertSegmentWithTitle(title, atIndex: genderSegment.numberOfSegments, animated: true)
            }
        }
        genderSegment.selectedSegmentIndex = (Int(test.patient_gender ?? "") ?? UISegmentedControlNoSegment)
        
        consentSegment.selectedSegmentIndex = (Int(test.patient_consent ?? "") ?? UISegmentedControlNoSegment)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? HistoryDetailViewController {
                
                // update test
                test.patient_dob = Test.getStringFromDate(datePicker.date)
                test.patient_age = ageTextField.text
                test.patient_gender = genderSegment.selectedSegmentIndex.description
                test.patient_consent = consentSegment.selectedSegmentIndex.description

                destinationController.test = test
            }
        }
    }

    
}
