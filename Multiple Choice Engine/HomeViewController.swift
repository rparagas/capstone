//
//  HomeViewController.swift
//  Multiple Choice Engine
//
//  Created by Ray Paragas on 16/8/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    var user = Student()

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentDetails()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func newChallengeTapped(_ sender: Any) {
        performSegue(withIdentifier: "newChallengeSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newChallengeSegue" {
            let nextVC = segue.destination as! NewChallengeViewController
            nextVC.currentUser = user
            print(user.subject)
        }
    }
    
    func getStudentDetails() {
        FIRDatabase.database().reference().child("students").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let user = Student()
            user.studentID = snapshot.key
            user.classID = (snapshot.value as! NSDictionary)["classID"] as! String
            user.firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            user.lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            user.username = (snapshot.value as! NSDictionary)["username"] as! String
            user.subject = (snapshot.value as! NSDictionary)["subject"] as! String
            if user.studentID == FIRAuth.auth()!.currentUser!.uid {
                self.user = user
            }
        })
    }
 
}
