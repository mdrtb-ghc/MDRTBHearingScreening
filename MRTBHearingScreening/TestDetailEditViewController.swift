//
//  TestDetailEditViewController.swift
//  MRTBHearingScreening
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patient_id.text = test.patient_id
        test_id.text = test.test_id
        test_date.setDate(test.test_date ?? NSDate(), animated: true)
        test_location.selectedSegmentIndex = (test.test_location?.toInt() ?? UISegmentedControlNoSegment)
        test_type.selectedSegmentIndex = (test.test_type?.toInt() ?? UISegmentedControlNoSegment)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
