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
    @IBOutlet weak var acceptStartButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    var challenge = Challenge()
    var currentUser = Student()
    var challenger = Student()
    var topic = Topic()
    var questionArray : [String] = []
    var questionSet : [Question] = []
    var previousVC = HomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configButtons()
        getChallengerDetails()
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
                self.getTopic()
            }
        })
    }
    
    func configButtons() {
        if challenge.status == "accepted" {
            acceptStartButton.setTitle("Start", for: .normal)
            declineButton.isHidden = true
        } else if challenge.status == "declined" {
            acceptStartButton.isHidden = true
            declineButton.isHidden = true
        } else {
            acceptStartButton.isHidden = false
            acceptStartButton.setTitle("Accept", for: .normal)
            declineButton.isHidden = false
            declineButton.setTitle("Decline", for: .normal)
        }
    }
    
    func displayStatus() {
        subjectLabel.text = currentUser.subject
        topicLabel.text = challenge.topic
        challengerLabel.text = challenger.firstName + " " + challenger.lastName
        statusLabel.text = challenge.status
    }
    
    func getTopic() {
        FIRDatabase.database().reference().child("topic").child(currentUser.subject).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let topic = Topic()
            topic.topicID = snapshot.key
            topic.topicName = (snapshot.value as! NSDictionary)["topicName"] as! String
            if topic.topicName == self.challenge.topic {
                self.topic = topic
                self.getChallengeQuestions()
                //self.
            }
        })
    }
    
    func getChallengeQuestions() {
        FIRDatabase.database().reference().child("challenges").child(challenge.challengeID).child("questions").observe(FIRDataEventType.value, with: {(snapshot) in
            self.questionArray.append((snapshot.value as! NSDictionary)["question1"] as! String)
            self.questionArray.append((snapshot.value as! NSDictionary)["question2"] as! String)
            self.questionArray.append((snapshot.value as! NSDictionary)["question3"] as! String)
            self.questionArray.append((snapshot.value as! NSDictionary)["question4"] as! String)
            self.questionArray.append((snapshot.value as! NSDictionary)["question5"] as! String)
            //print(self.questionArray.count)
        })
    }

    @IBAction func acceptStartTapped(_ sender: Any) {
        if acceptStartButton.titleLabel?.text == "Accept" {
            accepted()
        } else {
            started()
        }
    }
    
    func accepted() {
        FIRDatabase.database().reference().child("challenges").child(challenge.challengeID).child("status").setValue("Ready")
        FIRDatabase.database().reference().child("studentChallenges").child(currentUser.studentID).child(challenge.challengeID).child("status").setValue("Ready")
        previousVC.viewDidLoad()
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startChallengeSegue" {
            let nextVC = segue.destination as! ChallengeViewController
            nextVC.challenge = challenge
            nextVC.currentUser = currentUser
            nextVC.questionArray = questionArray
            nextVC.topic = topic
        }
    }
    
    func started() {
        performSegue(withIdentifier: "startChallengeSegue", sender: nil)
    }

    @IBAction func declineTapped(_ sender: Any) {
        FIRDatabase.database().reference().child("challenges").child(challenge.challengeID).child("status").setValue("Declined")
        FIRDatabase.database().reference().child("studentChallenges").child(currentUser.studentID).child(challenge.challengeID).child("status").setValue("Declined")
        navigationController?.popToRootViewController(animated: true)
    }
}
