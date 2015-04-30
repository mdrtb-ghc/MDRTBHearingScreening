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
    @IBOutlet weak var baseline_capreomycin: UISegmentedControl!
    @IBOutlet weak var baseline_kanamicin: UISegmentedControl!
    @IBOutlet weak var baseline_amikacin: UISegmentedControl!
    @IBOutlet weak var baseline_ag_dose_gt_3: UISegmentedControl!
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        baseline_creatinine.text = test.baseline_creatinine
        baseline_ag_start_date.maximumDate = NSDate()
        baseline_ag_start_date.setDate(test.getDate("baseline_ag_start_date") ?? NSDate(), animated: true)
        
        baseline_streptomycin.selectedSegmentIndex = test.baseline_streptomycin?.toInt() ?? UISegmentedControlNoSegment
        baseline_capreomycin.selectedSegmentIndex = test.baseline_capreomycin?.toInt() ?? UISegmentedControlNoSegment
        baseline_kanamicin.selectedSegmentIndex = test.baseline_kanamicin?.toInt() ?? UISegmentedControlNoSegment
        baseline_amikacin.selectedSegmentIndex = test.baseline_amikacin?.toInt() ?? UISegmentedControlNoSegment
        baseline_ag_dose_gt_3.selectedSegmentIndex = test.baseline_ag_dose_gt_3?.toInt() ?? UISegmentedControlNoSegment
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
