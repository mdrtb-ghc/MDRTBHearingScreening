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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        monthly_ag_type.selectedSegmentIndex = test.monthly_ag_type?.toInt() ?? UISegmentedControlNoSegment
        monthly_ag_dose.text = test.monthly_ag_dose
        monthly_ag_frequency.text = test.monthly_ag_frequency
        monthly_creatinine_level.text = test.monthly_creatinine_level
        monthly_furosemide.selectedSegmentIndex = test.monthly_furosemide?.toInt() ?? UISegmentedControlNoSegment
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
