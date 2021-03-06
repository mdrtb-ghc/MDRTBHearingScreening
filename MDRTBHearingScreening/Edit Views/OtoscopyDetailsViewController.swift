//
//  OtoscopyDetailsViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 4/4/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class OtoscopyDetailsViewController: UIViewController {

    var test: Test!
    
    @IBOutlet weak var left_normal: UISegmentedControl!
    @IBAction func left_normal_valuechanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            left_wax.selectedSegmentIndex = 0
            left_wax.enabled = false
            left_infection.selectedSegmentIndex = 0
            left_infection.enabled = false
            left_perforated.selectedSegmentIndex = 0
            left_perforated.enabled = false
            left_fluid.selectedSegmentIndex = 0
            left_fluid.enabled = false
        } else {
            left_wax.enabled = true
            left_infection.enabled = true
            left_perforated.enabled = true
            left_fluid.enabled = true
        }
    }
    @IBOutlet weak var left_wax: UISegmentedControl!
    @IBOutlet weak var left_infection: UISegmentedControl!
    @IBOutlet weak var left_perforated: UISegmentedControl!
    @IBOutlet weak var left_fluid: UISegmentedControl!
    @IBOutlet weak var left_notes: DesignableTextView!
    
    @IBOutlet weak var right_normal: UISegmentedControl!
    @IBAction func right_normal_valuechanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            right_wax.selectedSegmentIndex = 0
            right_wax.enabled = false
            right_infection.selectedSegmentIndex = 0
            right_infection.enabled = false
            right_perforated.selectedSegmentIndex = 0
            right_perforated.enabled = false
            right_fluid.selectedSegmentIndex = 0
            right_fluid.enabled = false
        } else {
            right_wax.enabled = true
            right_infection.enabled = true
            right_perforated.enabled = true
            right_fluid.enabled = true
        }
    }
    @IBOutlet weak var right_wax: UISegmentedControl!
    @IBOutlet weak var right_infection: UISegmentedControl!
    @IBOutlet weak var right_perforated: UISegmentedControl!
    @IBOutlet weak var right_fluid: UISegmentedControl!
    @IBOutlet weak var right_notes: DesignableTextView!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(test.test_id ?? "") - Otoscopy"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "goNext")
        
        left_normal.selectedSegmentIndex = Int(test.left_normal ?? "") ?? -1
        left_wax.selectedSegmentIndex = Int(test.left_wax ?? "") ?? -1
        left_infection.selectedSegmentIndex = Int(test.left_infection ?? "") ?? -1
        left_perforated.selectedSegmentIndex = Int(test.left_perforated ?? "") ?? -1
        left_fluid.selectedSegmentIndex = Int(test.left_fluid ?? "") ?? -1
        left_notes.text = test.left_notes
        
        if left_normal.selectedSegmentIndex == 1 {
            left_wax.enabled = false
            left_infection.enabled = false
            left_perforated.enabled = false
            left_fluid.enabled = false
        }
        
        right_normal.selectedSegmentIndex = Int(test.right_normal ?? "") ?? -1
        right_wax.selectedSegmentIndex = Int(test.right_wax ?? "") ?? -1
        right_infection.selectedSegmentIndex = Int(test.right_infection ?? "") ?? -1
        right_perforated.selectedSegmentIndex = Int(test.right_perforated ?? "") ?? -1
        right_fluid.selectedSegmentIndex = Int(test.right_fluid ?? "") ?? -1
        right_notes.text = test.right_notes
        
        if right_normal.selectedSegmentIndex == 1 {
            right_wax.enabled = false
            right_infection.enabled = false
            right_perforated.enabled = false
            right_fluid.enabled = false
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
        
        test.left_normal = "\(left_normal.selectedSegmentIndex)"
        test.left_wax = "\(left_wax.selectedSegmentIndex)"
        test.left_infection = "\(left_infection.selectedSegmentIndex)"
        test.left_perforated = "\(left_perforated.selectedSegmentIndex)"
        test.left_fluid = "\(left_fluid.selectedSegmentIndex)"
        test.left_notes = left_notes.text
        
        test.right_normal = "\(left_normal.selectedSegmentIndex)"
        test.right_wax = "\(right_wax.selectedSegmentIndex)"
        test.right_infection = "\(right_infection.selectedSegmentIndex)"
        test.right_perforated = "\(right_perforated.selectedSegmentIndex)"
        test.right_fluid = "\(right_fluid.selectedSegmentIndex)"
        test.right_notes = right_notes.text
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        updateTest()
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? AudiometerResultsViewController {
                destinationController.test = test
                destinationController.ear = "Right"
            }
        }
    }

}
