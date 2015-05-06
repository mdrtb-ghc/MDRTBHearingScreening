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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    lazy var settings : NSDictionary = {
        let customPlistUrl = NSBundle.mainBundle().URLForResource("MDRTBHearingScreening", withExtension: "plist")!
        return NSDictionary(contentsOfURL: customPlistUrl)!
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        patient_id.text = test.patient_id
        test_id.text = test.test_id
        test_date.setDate(test.getDate("test_date") ?? NSDate(), animated: true)
        
        if let locations = settings["locations"] as? [String] {
            test_location.removeAllSegments()
            for location in locations {
                test_location.insertSegmentWithTitle(location, atIndex: test_type.numberOfSegments, animated: true)
            }
        }
        test_location.selectedSegmentIndex = (test.test_location?.toInt() ?? UISegmentedControlNoSegment)
        
        if let types = settings["types"] as? [String] {
            test_type.removeAllSegments()
            for type in types {
                test_type.insertSegmentWithTitle(type, atIndex: test_type.numberOfSegments, animated: true)
            }
        }
        test_type.selectedSegmentIndex = (test.test_type?.toInt() ?? UISegmentedControlNoSegment)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
