//
//  OtoscopyDetailsViewController.swift
//  MRTBHearingScreening
//
//  Created by Miguel Clark on 4/4/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData

class OtoscopyDetailsViewController: UIViewController {

    var test: Test!
    
    @IBOutlet weak var left_normal: UISegmentedControl!
    @IBOutlet weak var left_wax: UISegmentedControl!
    @IBOutlet weak var left_infection: UISegmentedControl!
    @IBOutlet weak var left_perforated: UISegmentedControl!
    @IBOutlet weak var left_fluid: UISegmentedControl!
    @IBOutlet weak var left_notes: UITextView!
    
    @IBOutlet weak var right_normal: UISegmentedControl!
    @IBOutlet weak var right_wax: UISegmentedControl!
    @IBOutlet weak var right_infection: UISegmentedControl!
    @IBOutlet weak var right_perforated: UISegmentedControl!
    @IBOutlet weak var right_fluid: UISegmentedControl!
    @IBOutlet weak var right_notes: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        left_normal.selectedSegmentIndex = test.left_normal?.toInt() ?? -1
        left_wax.selectedSegmentIndex = test.left_wax?.toInt() ?? -1
        left_infection.selectedSegmentIndex = test.left_infection?.toInt() ?? -1
        left_perforated.selectedSegmentIndex = test.left_perforated?.toInt() ?? -1
        left_fluid.selectedSegmentIndex = test.left_fluid?.toInt() ?? -1
        left_notes.text = test.left_notes

        right_normal.selectedSegmentIndex = test.right_normal?.toInt() ?? -1
        right_wax.selectedSegmentIndex = test.right_wax?.toInt() ?? -1
        right_infection.selectedSegmentIndex = test.right_infection?.toInt() ?? -1
        right_perforated.selectedSegmentIndex = test.right_perforated?.toInt() ?? -1
        right_fluid.selectedSegmentIndex = test.right_fluid?.toInt() ?? -1
        right_notes.text = test.right_notes

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
