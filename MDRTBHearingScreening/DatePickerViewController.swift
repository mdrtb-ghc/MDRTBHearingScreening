//
//  DatePickerViewController.swift
//  MDRTBHearingScreening
//
//  Created by Laura Greisman on 3/29/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet var datePicker: UIDatePicker!
    
    var viewLoadedCompletion : ((datePicker: UIDatePicker)->Void)!
    var valueChangedCompletion : ((date: NSDate)->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.viewLoadedCompletion != nil) {
            self.viewLoadedCompletion(datePicker: self.datePicker)
        }
    }
    
    @IBAction func valueChanged(sender: UIDatePicker) {
        if (self.valueChangedCompletion != nil) {
            self.valueChangedCompletion(date: sender.date) }
    }
}