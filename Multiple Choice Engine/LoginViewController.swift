//
//  ViewController.swift
//  Multiple Choice Engine
//
//  Created by Ray Paragas on 16/8/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginTapped(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                print(error.debugDescription.description)
            } else {
                print("Successful Signin")
                self.performSegue(withIdentifier: "successLoginSegue", sender: nil)
            }
        })
    }
}

