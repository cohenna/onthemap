//
//  ViewController.swift
//  On the Map
//
//  Created by Nick Cohen on 5/18/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import UIKit

// should use i18n in the future, for now, hard-code
var DEFAULT_EMAIL_TEXT = "Email"
var DEFAULT_PASSWORD_TEXT = "Password"

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    
    var udacityUser : UdacityUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //loginButton.backgroundColor = UIColor.redColor()
        loginButton.layer.cornerRadius = 5
        facebookButton.layer.cornerRadius = 5
        errorText.layer.cornerRadius = 5
        passwordText.delegate = self
        emailText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == passwordText && textField.text == DEFAULT_PASSWORD_TEXT {
            textField.secureTextEntry = true
            textField.text = ""
        } else if textField == emailText && textField.text == DEFAULT_EMAIL_TEXT {
            textField.text = ""
        }
        
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool  {
        errorText.hidden = true
        errorText.text = ""
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            if textField == passwordText {
                textField.text = DEFAULT_PASSWORD_TEXT
                textField.secureTextEntry = false
            } else if textField == emailText {
                textField.text = DEFAULT_EMAIL_TEXT
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passwordText {
            self.loginWithUdacity(loginButton)
            return true
        }
        return false
    }
    
    func handleBadLoginPasswordError() {
        println("handleBadLoginPasswordError")
        dispatch_async(dispatch_get_main_queue(), {
            UIView.shakeView(self.passwordText)
            UIView.shakeView(self.emailText)
            self.errorText.hidden = false
            self.errorText.text = "Invalid Login"
        })
    }
    
    func handleOtherLoginError(error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.shakeView(self.loginButton)
            self.errorText.hidden = false
            self.errorText.text = "Network Error"
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHome" {
            var navigationController = (segue.destinationViewController as! UINavigationController)
            (navigationController.viewControllers[0] as! TabBarController).udacityUser = self.udacityUser
        }
    }
    

    @IBAction func loginWithUdacity(sender: UIButton) {
        println("loginWithUdacity start")
        loginButton.enabled = false
        UdacityClient.sharedInstance().login(emailText.text, password: passwordText.text, completionHandler: {(result: UdacityUser?, error: NSError?) in
            println("loginWithUdactiy completion handler start")
            dispatch_async(dispatch_get_main_queue(), {
                self.loginButton.enabled = true
            })
            
            if let user = result {
                // success
                println("success")
                self.udacityUser = user
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("showHome", sender: self)
                })
            } else if let error = error {
                // error
                if (error.code == ERROR_BAD_LOGIN_PASSWORD_COMBINATION) {
                    // bad login/pw
                    self.handleBadLoginPasswordError()
                } else {
                    // other error
                    self.handleOtherLoginError(error)
                }
            } else {
                self.handleOtherLoginError(error)
            }
        })
    }

}

