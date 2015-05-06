//
//  HistoryDetailViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 4/4/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {

    var test: Test!
    
    @IBOutlet weak var HistorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var HistoryEarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var HistoryRingingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var HistoryTimingTextField: UITextField!
    
    @IBAction func HistorySegmentedControlValueChanged(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex > 0) {
            // if yes (> 0), then enable other controls
            HistoryEarSegmentedControl.enabled = true
            HistoryRingingSegmentedControl.enabled = true
            HistoryTimingTextField.enabled = true
        } else {
            // else disable others and set values to nil
            HistoryEarSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
            HistoryEarSegmentedControl.enabled = false
            HistoryRingingSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
            HistoryRingingSegmentedControl.enabled = false
            HistoryTimingTextField.text = nil
            HistoryTimingTextField.enabled = false
        }
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        HistorySegmentedControl.selectedSegmentIndex = test.history?.toInt() ?? UISegmentedControlNoSegment
        HistoryEarSegmentedControl.selectedSegmentIndex = test.history_ear?.toInt() ?? UISegmentedControlNoSegment
        HistoryTimingTextField.text = test.history_timing
        HistoryRingingSegmentedControl.selectedSegmentIndex = test.history_ringing?.toInt() ?? UISegmentedControlNoSegment
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
