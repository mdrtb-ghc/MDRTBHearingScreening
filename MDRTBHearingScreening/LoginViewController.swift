//
//  LoginViewController.swift
//  MDRTBHearingScreening
//
//  Created by Laura Greisman on 3/28/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData
import Security

class LoginViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var keychain: KeychainWrap?
    var storedPasscode: String?
    
    @IBOutlet weak var passcode_input: UITextField!
    @IBOutlet weak var login_button: UIButton!
    @IBOutlet weak var create_button: UIButton!
    @IBOutlet weak var create_passcode_label: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.keychain = KeychainWrap()
        
        let result : OSStatus = keychain!.readKey("passcode",value: &storedPasscode)!
        if(result == errSecSuccess) {
            // Passcode exists, set up for login
            login_button.hidden = false
            login_button.setTitle("Login", forState: .Normal)
            create_button.hidden = true
            create_passcode_label.hidden = true
        } else {
            // No passcode saved, set up for creating new passcode
            login_button.hidden = false
            login_button.setTitle("Create", forState: .Normal)
            create_button.hidden = true
            create_passcode_label.hidden = false
        }
        
    }
    
    @IBAction func add(sender: AnyObject) {
        
        let result = keychain!.addKey("key1", value: "value1")
        var message = "Result: \(keychain!.keychainErrorToString(result))"
        UIAlertView(title: "Add item", message: message, delegate: self, cancelButtonTitle: "Cancel").show()
    }
    
    @IBAction func query(sender: AnyObject) {
        
        var storedValue: String?
        let result = keychain!.readKey("key1", value : &storedValue)!
        UIAlertView(title: "Query item", message: storedValue, delegate: self, cancelButtonTitle: "Cancel").show()
    }
    
    @IBAction func reset(sender: AnyObject) {
        
        let result = keychain!.resetKeychain()
        var message = "Result: \(result)"
        UIAlertView(title: "Delete item", message: message, delegate: self, cancelButtonTitle: "Cancel").show()
    }
    
    // MARK: - Action for checking username/password
    @IBAction func createAction(sender: AnyObject) {
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        if (passcode_input.text == "") {
            var alert = UIAlertView()
            alert.title = "You must enter passcode!"
            alert.addButtonWithTitle("Oops!")
            alert.show()
            return;
        }
        passcode_input.resignFirstResponder()
        
        if (login_button.titleLabel?.text == "Create" && storedPasscode == nil) {
            // Create passcode key in ley chain
            let result = keychain!.addKey("passcode", value: passcode_input.text)
            if(result == errSecSuccess) {
                // segue to app start view
                println("opening into app")
                self.performSegueWithIdentifier("openAppSegue", sender: self)
            }
            else {
                var alert = UIAlertView()
                alert.title = "Problem creating passcode"
                alert.message = "Error :: \(keychain!.keychainErrorToString(result))"
                alert.addButtonWithTitle("Try Again!")
                alert.show()
            }
        } else {
            // attempt to match enterred passcode top stored passcode
            if (passcode_input.text == storedPasscode) {
                // segue to app start view
                println("opening into app")
                self.performSegueWithIdentifier("openAppSegue", sender: self)
            } else {
                var alert = UIAlertView()
                alert.title = "Problem logging in"
                alert.message = "Passcode did not match"
                alert.addButtonWithTitle("Try Again!")
                alert.show()
            }
        }
        
    }
    
}

