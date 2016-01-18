//
//  OutcomesViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 5/5/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class OutcomesViewController: UIViewController {

    var test: Test!
    
    @IBOutlet weak var outcome_hearingloss : UISegmentedControl!
    @IBOutlet weak var outcome_hearingloss_ag : UISegmentedControl!
    @IBOutlet weak var outcome_plan_1 : UISwitch!
    @IBOutlet weak var outcome_plan_2 : UISwitch!
    @IBOutlet weak var outcome_plan_3 : UISwitch!
    @IBOutlet weak var outcome_plan_4 : UISwitch!
    @IBOutlet weak var outcome_plan_5 : UISwitch!
    @IBOutlet weak var outcome_plan_0 : UISwitch!
    @IBOutlet weak var outcome_comments : UITextView!
    
    var test_visitnext = UIDatePicker()
    @IBOutlet weak var test_visitnext_button: DesignableButton!
    @IBAction func test_visitnext_button_tapped(sender: DesignableButton) {
        test_visitnext.datePickerMode = UIDatePickerMode.Date
        test_visitnext.addTarget(self, action: "test_visitnext_changed", forControlEvents: UIControlEvents.ValueChanged)
        
        let picker_view = UIView()
        let picker_controller = UIViewController()
        picker_view.addSubview(test_visitnext)
        picker_controller.view = picker_view
        
        let popover_controller = UIPopoverController(contentViewController: picker_controller)
        popover_controller.setPopoverContentSize(CGSize(width: 320, height: 216), animated: true)
        popover_controller.presentPopoverFromRect(CGRect(x: test_visitnext_button.frame.width/2, y: 0, width: 0, height: 0), inView: test_visitnext_button, permittedArrowDirections: UIPopoverArrowDirection.Down, animated: true)
    }
    func test_visitnext_changed() {
        // when date picker is changed, update button text and field on Test object
        let df = NSDateFormatter()
        df.dateFormat = "EEE, MMM d y"
        test_visitnext_button.setTitle(df.stringFromDate(test_visitnext.date), forState: .Normal)
        test.test_visitnext = Test.getStringFromDate(test_visitnext.date, includeTime: false)
    }
    
    @IBAction func clearDate(sender: UIButton) {
        // clear next visit date on Test object and set button text to prompt
        test_visitnext_button.setTitle("Tap to select date", forState: .Normal)
        test.test_visitnext = nil
    }
    
    @IBAction func outcome_hearingloss_changed(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // if NO then force outcome_hearingloss_ag to be NO also and disabled
            outcome_hearingloss_ag.selectedSegmentIndex = 0
            outcome_hearingloss_ag.enabled = false
        } else {
            outcome_hearingloss_ag.enabled = true
        }
    }
    @IBAction func outcome_plan_changed(sender: UISwitch) {
        if sender.on {
            outcome_plan_1.on = false
            outcome_plan_2.on = false
            outcome_plan_3.on = false
            outcome_plan_4.on = false
            outcome_plan_5.on = false
            outcome_plan_0.on = false
            sender.on = true
        }
        
        var followUpWeeks: Int?
        if outcome_plan_1.on {
            test.outcome_plan = "1"
            followUpWeeks = 2
        } else if outcome_plan_2.on {
            test.outcome_plan = "2"
            followUpWeeks = 2
        } else if outcome_plan_3.on {
            test.outcome_plan = "3"
            followUpWeeks = 2
        } else if outcome_plan_4.on {
            test.outcome_plan = "4"
            followUpWeeks = 4
        } else if outcome_plan_5.on {
            test.outcome_plan = "5"
        } else if outcome_plan_0.on {
            test.outcome_plan = "0"
            followUpWeeks = 4
        } else {
            test.outcome_plan = ""
        }
        
        if followUpWeeks != nil {
            let calendar = NSCalendar.currentCalendar()
            let components = NSDateComponents()
            components.weekOfYear = followUpWeeks ?? 0
            if let testdate = test.getDate("test_date") {
                if let nextdate = calendar.dateByAddingComponents(components, toDate: testdate, options:.MatchFirst) {
                    // update datepicker to default followup date, then update button text and Test object fields
                    test_visitnext.date = nextdate
                    test_visitnext_changed()
                }
            }
        } else {
            // clear next visit date on Test object and set button text to prompt
            test_visitnext_button.setTitle("Tap to select date", forState: .Normal)
            test.test_visitnext = nil
        }

    
    }
    
    func animateViewForKeyboard(up: Bool,userInfo: [NSObject:AnyObject]?) {
        if let userInfo = userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                let movement = (up ? -keyboardSize.height : keyboardSize.height)
                UIView.animateWithDuration(0.3, animations: {
                    self.view.frame = CGRectOffset(self.view.frame, 0, movement)
                })
                
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.animateViewForKeyboard(true,userInfo:notification.userInfo)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateViewForKeyboard(false,userInfo:notification.userInfo)
    }
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }
    
    func goToList() {
        if navigationController != nil {
            navigationController!.popToRootViewControllerAnimated(true)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        // update test
        updateTest()
        test.saveTestContext()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(test.test_id ?? "") - Outcomes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .Plain, target: self, action: "goToList")
        
        // Do any additional setup after loading the view.
        if test != nil {
            outcome_hearingloss.selectedSegmentIndex = Int(test.outcome_hearingloss ?? "") ?? UISegmentedControlNoSegment
            
            if outcome_hearingloss.selectedSegmentIndex == 0 {
                // if NO then force outcome_hearingloss_ag to be NO also and disabled
                outcome_hearingloss_ag.selectedSegmentIndex = 0
                outcome_hearingloss_ag.enabled = false
            } else {
                outcome_hearingloss_ag.selectedSegmentIndex = Int(test.outcome_hearingloss_ag ?? "") ?? UISegmentedControlNoSegment
            }
            
            outcome_plan_1.on = test.outcome_plan == "1"
            outcome_plan_2.on = test.outcome_plan == "2"
            outcome_plan_3.on = test.outcome_plan == "3"
            outcome_plan_4.on = test.outcome_plan == "4"
            outcome_plan_5.on = test.outcome_plan == "5"
            outcome_plan_0.on = test.outcome_plan == "0"
            outcome_comments.text = test.outcome_comments ?? ""
            
            if let date = test.getDate("test_visitnext") {
                let df = NSDateFormatter()
                df.dateFormat = "EEE, MMM d y"
                test_visitnext.date = date
                test_visitnext_button.setTitle(df.stringFromDate(date), forState: .Normal)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTest() {
        test.date_modified = Test.getStringFromDate(NSDate(), includeTime: true)
        
        test.outcome_hearingloss = "\(outcome_hearingloss.selectedSegmentIndex)"
        test.outcome_hearingloss_ag = "\(outcome_hearingloss_ag.selectedSegmentIndex)"
        if outcome_plan_1.on {
            test.outcome_plan = "1"
        } else if outcome_plan_2.on {
            test.outcome_plan = "2"
        } else if outcome_plan_3.on {
            test.outcome_plan = "3"
        } else if outcome_plan_4.on {
            test.outcome_plan = "4"
        } else if outcome_plan_5.on {
            test.outcome_plan = "5"
        } else if outcome_plan_0.on {
            test.outcome_plan = "0"
        } else {
            test.outcome_plan = ""
        }
        test.outcome_comments = outcome_comments.text
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        updateTest()
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? DetailTableViewController {
                destinationController.test = test
            }
        }
    }

}
