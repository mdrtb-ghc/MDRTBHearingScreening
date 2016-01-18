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
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(test.test_id ?? "") - Patient History"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "goNext")
                
        HistorySegmentedControl.selectedSegmentIndex = Int(test.history ?? "") ?? UISegmentedControlNoSegment
        HistoryEarSegmentedControl.selectedSegmentIndex = Int(test.history_ear ?? "") ?? UISegmentedControlNoSegment
        HistoryTimingTextField.text = test.history_timing
        HistoryRingingSegmentedControl.selectedSegmentIndex = Int(test.history_ringing ?? "") ?? UISegmentedControlNoSegment
        
        if(HistorySegmentedControl.selectedSegmentIndex > 0) {
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

    // MARK: - Save Context on Close
    override func viewWillDisappear(animated: Bool) {
        //update test
        updateTest()
        //test.saveTestContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTest() {
        test.date_modified = Test.getStringFromDate(NSDate(), includeTime: true)
        
        test.history = HistorySegmentedControl.selectedSegmentIndex.description
        test.history_ear = HistoryEarSegmentedControl.selectedSegmentIndex.description
        test.history_ringing = HistoryRingingSegmentedControl.selectedSegmentIndex.description
        test.history_timing = HistoryTimingTextField.text
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        updateTest()
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? BaselineDetailViewController {
                destinationController.test = test
            }
        }
    }
}
