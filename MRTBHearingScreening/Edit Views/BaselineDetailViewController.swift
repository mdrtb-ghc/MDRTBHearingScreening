//
//  BaselineDetailViewController.swift
//  MRTBHearingScreening
//
//  Created by Miguel Clark on 4/4/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class BaselineDetailViewController: UIViewController {

    var test: Test!
    
    @IBOutlet weak var baseline_creatinine: UITextField!
    @IBOutlet weak var baseline_ag_start_date: UIDatePicker!
    @IBOutlet weak var baseline_streptomycin: UISegmentedControl!
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        println("date changed to ::\(sender.date)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        baseline_creatinine.text = test.baseline_creatinine
        baseline_ag_start_date.maximumDate = NSDate()
        baseline_ag_start_date.setDate(test.baseline_ag_start_date ?? NSDate(), animated: true)
        baseline_streptomycin.selectedSegmentIndex = test.baseline_streptomycin?.toInt() ?? UISegmentedControlNoSegment
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
