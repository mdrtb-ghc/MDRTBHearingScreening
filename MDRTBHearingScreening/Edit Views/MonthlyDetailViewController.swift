//
//  MonthlyDetailViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 4/4/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class MonthlyDetailViewController: UIViewController {

    var test: Test!
    
    @IBOutlet weak var monthly_ag_type: UISegmentedControl!
    @IBOutlet weak var monthly_ag_dose: UITextField!
    @IBOutlet weak var monthly_ag_frequency: UITextField!
    @IBOutlet weak var monthly_creatinine_level: UITextField!
    @IBOutlet weak var monthly_furosemide: UISegmentedControl!
   
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Current Treatment"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "goNext")
        
        monthly_ag_type.selectedSegmentIndex = test.monthly_ag_type?.toInt() ?? UISegmentedControlNoSegment
        monthly_ag_dose.text = test.monthly_ag_dose
        monthly_ag_frequency.text = test.monthly_ag_frequency
        monthly_creatinine_level.text = test.monthly_creatinine_level
        monthly_furosemide.selectedSegmentIndex = test.monthly_furosemide?.toInt() ?? UISegmentedControlNoSegment
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
        
        test.monthly_ag_type = "\(monthly_ag_type.selectedSegmentIndex)"
        test.monthly_ag_dose = monthly_ag_dose.text
        test.monthly_ag_frequency = monthly_ag_frequency.text
        test.monthly_creatinine_level = monthly_creatinine_level.text
        test.monthly_furosemide = "\(monthly_furosemide.selectedSegmentIndex)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? OtoscopyDetailsViewController {
                destinationController.test = test
            }
        }
    }

}
