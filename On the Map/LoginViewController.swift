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

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //loginButton.backgroundColor = UIColor.redColor()
        loginButton.layer.cornerRadius = 5
        facebookButton.layer.cornerRadius = 5
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
    
    func handleBadLoginPasswordError() {
        
    }
    
    func handleOtherLoginError(error: NSError?) {
        
    }

    @IBAction func loginWithUdacity(sender: UIButton) {
        UdacityClient.sharedInstance().login(emailText.text, password: passwordText.text, completionHandler: {(result: UdacityUser?, error: NSError?) in
            if let user = result {
                // success
                println("success")
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

