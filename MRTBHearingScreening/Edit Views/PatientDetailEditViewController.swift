//
//  PatientDetailEditViewController.swift
//  MRTBHearingScreening
//
//  Created by Miguel Clark on 4/3/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class PatientDetailEditViewController: UIViewController {
    
    var test: Test!
    var test_prev: Test!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let components = calendar.components(.CalendarUnitYear, fromDate: sender.date, toDate: NSDate(), options: nil)
        let years = components.year
        ageTextField.text = String(years)
    
    }
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.text = test.patient_id
        datePicker.setDate(test.patient_dob ?? NSDate(), animated: true)
        ageTextField.text = test.patient_age
        genderSegment.selectedSegmentIndex = (test.patient_gender?.toInt() ?? UISegmentedControlNoSegment)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
