//
//  ViewController.swift
//  Multiple Choice Engine
//
//  Created by Ray Paragas on 25/8/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChallengeStatusViewController: UIViewController {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var challengerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var challenge = Challenge()
    var currentUser = Student()
    var challenger = Student()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getChallengerDetails()
        // Do any additional setup after loading the view.
    }
    
    func getChallengerDetails() {
        FIRDatabase.database().reference().child("students").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let user = Student()
            user.studentID = snapshot.key
            user.classID = (snapshot.value as! NSDictionary)["classID"] as! String
            user.firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            user.lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            user.username = (snapshot.value as! NSDictionary)["username"] as! String
            user.subject = (snapshot.value as! NSDictionary)["subject"] as! String
            if user.studentID == self.challenge.challengerID || user.studentID == self.challenge.senderID && user.studentID != self.currentUser.studentID {
                self.challenger = user
                self.displayStatus()
            }
        })
    }
    
    func displayStatus() {
        subjectLabel.text = currentUser.subject
        topicLabel.text = challenge.topic
        challengerLabel.text = challenger.firstName + " " + challenger.lastName
        statusLabel.text = challenge.status
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        
    }

    @IBAction func declineTapped(_ sender: Any) {
        
    }
}
