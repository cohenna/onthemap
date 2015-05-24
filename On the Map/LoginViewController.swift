//
//  ViewController.swift
//  On the Map
//
//  Created by Nick Cohen on 5/18/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import UIKit
import FBSDKLoginKit

// should use i18n in the future, for now, hard-code
var DEFAULT_EMAIL_TEXT = "Email"
var DEFAULT_PASSWORD_TEXT = "Password"

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var fbLoginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        errorText.layer.cornerRadius = 5
        passwordText.delegate = self
        emailText.delegate = self
        
        emailText.text = DEFAULT_EMAIL_TEXT
        passwordText.text = DEFAULT_PASSWORD_TEXT
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
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
        self.view.endEditing(true)
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
    

    @IBAction func loginWithUdacity(sender: UIButton) {
        println("loginWithUdacity start")
        loginButton.enabled = false
        UdacityClient.sharedInstance().login(emailText.text, password: passwordText.text, fbToken: nil, completionHandler: {(result: UdacityUser?, error: NSError?) in
            println("loginWithUdactiy completion handler start")
            dispatch_async(dispatch_get_main_queue(), {
                self.loginButton.enabled = true
            })
            
            if let user = result {
                // success
                println("success")
                (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUser = user
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
    
    func loginWithFacebook(token: String) {
        UdacityClient.sharedInstance().login(nil, password: nil, fbToken: token, completionHandler: {(result: UdacityUser?, error: NSError?) in
            println("loginWithFacebook completion handler start")
            if let user = result {
                // success
                println("success with fb login")
                (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUser = user
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("showHome", sender: self)
                })
            } else {
                self.handleOtherLoginError(error)
            }
        })
    }

    @IBAction func fbLogin(sender: AnyObject) {
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            var tokenString = token.tokenString
            println("already logged in, token=\(tokenString)")
            self.loginWithFacebook(tokenString)
            return
        }
        
        var login = FBSDKLoginManager()
        login.logInWithReadPermissions(["email"], handler: { (result: FBSDKLoginManagerLoginResult!, error) in
            if let error = error {
                UIView.shakeView(self.fbLoginButton)
                self.errorText.hidden = false
                self.errorText.text = "Facebook Login Error"
            } else if result.isCancelled {
                UIView.shakeView(self.fbLoginButton)
                self.errorText.hidden = false
                self.errorText.text = "Facebook Login Error"
            } else {
                var token = result.token.tokenString
                self.loginWithFacebook(token)

            }
        })
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        println("signUp")
        var urlString = "https://www.udacity.com/account/auth#!/signup"
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        } else {
            showErrorAlert("Cannot Sign Up, Invalid URL: \(urlString)")
        }
    }
}

