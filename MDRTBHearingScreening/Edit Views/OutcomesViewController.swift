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
    @IBOutlet weak var outcome_comments : UITextView!
    
    @IBAction func outcome_hearingloss_changed(sender: UISegmentedControl) {
        
        let isTrue = sender.selectedSegmentIndex == 0
        
        outcome_hearingloss_ag.selectedSegmentIndex = UISegmentedControlNoSegment
        outcome_hearingloss_ag.enabled = !isTrue
        outcome_plan_1.on = false
        outcome_plan_1.enabled = !isTrue
        outcome_plan_2.on = false
        outcome_plan_2.enabled = !isTrue
        outcome_plan_3.on = false
        outcome_plan_3.enabled = !isTrue
        outcome_plan_4.on = false
        outcome_plan_4.enabled = !isTrue
        outcome_plan_5.on = false
        outcome_plan_5.enabled = !isTrue
    }
    
    @IBAction func outcome_plan_changed(sender: UISwitch) {
        if sender.on {
            outcome_plan_1.on = false
            outcome_plan_2.on = false
            outcome_plan_3.on = false
            outcome_plan_4.on = false
            outcome_plan_5.on = false
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if test != nil {
            outcome_hearingloss.selectedSegmentIndex = test.outcome_hearingloss?.toInt() ?? UISegmentedControlNoSegment
            outcome_hearingloss_ag.selectedSegmentIndex = test.outcome_hearingloss_ag?.toInt() ?? UISegmentedControlNoSegment
            outcome_plan_1.on = test.outcome_plan == "1"
            outcome_plan_2.on = test.outcome_plan == "2"
            outcome_plan_3.on = test.outcome_plan == "3"
            outcome_plan_4.on = test.outcome_plan == "4"
            outcome_plan_5.on = test.outcome_plan == "5"
            outcome_comments.text = test.outcome_comments ?? ""
        }
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
