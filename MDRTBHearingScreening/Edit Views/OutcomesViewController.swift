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
    }
    
    func animateViewForKeyboard(up: Bool,userInfo: [NSObject:AnyObject]?) {
        if let userInfo = userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                var movement = (up ? -keyboardSize.height : keyboardSize.height)
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
        //test.saveTestContext()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Outcomes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .Plain, target: self, action: "goToList")
        
        // Do any additional setup after loading the view.
        if test != nil {
            outcome_hearingloss.selectedSegmentIndex = test.outcome_hearingloss?.toInt() ?? UISegmentedControlNoSegment
            outcome_hearingloss_ag.selectedSegmentIndex = test.outcome_hearingloss_ag?.toInt() ?? UISegmentedControlNoSegment
            outcome_plan_1.on = test.outcome_plan == "1"
            outcome_plan_2.on = test.outcome_plan == "2"
            outcome_plan_3.on = test.outcome_plan == "3"
            outcome_plan_4.on = test.outcome_plan == "4"
            outcome_plan_5.on = test.outcome_plan == "5"
            outcome_plan_0.on = test.outcome_plan == "0"
            outcome_comments.text = test.outcome_comments ?? ""
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
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? DetailTableViewController {
                destinationController.test = test
            }
        }
    }

}
