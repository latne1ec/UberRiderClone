//
//  SignInViewController.swift
//  Uber Rider
//
//  Created by Evan Latner on 4/17/17.
//  Copyright © 2017 levellabs. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    private let RIDER_SEGUE = "RiderVC"

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        if emailTextField.text != nil && passwordTextField.text != nil {
            AuthProvider.Instance.login(email: emailTextField.text!, password: passwordTextField.text!, loginHandler: {(message) in
                if message != nil {
                    self.AlertUser(title: "Problem", message: message!)
                } else {
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil)
                }
            })
        } else {
            AlertUser(title: "Email and password required.", message: "Enter them now")
        }
    }
    @IBAction func signup(_ sender: Any) {
        if emailTextField.text != nil && passwordTextField.text != nil {
            AuthProvider.Instance.signup(email: emailTextField.text!, password: passwordTextField.text!, loginHandler: {(message) in
                if message != nil {
                    self.AlertUser(title: "Problem clreating account", message: message!)
                } else {
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil)
                }
            })
        }
    }
    
    private func AlertUser (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated:  true, completion:  nil)
    }

    
}
