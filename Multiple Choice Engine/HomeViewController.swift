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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user = Student()
    var userChallenges : [Challenge] = []
    var selectedChallenge = Challenge()
    
    @IBOutlet weak var challengesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentDetails()
        challengesTableView.delegate = self
        challengesTableView.dataSource = self
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
        if segue.identifier == "statusSegue" {
            let nextVC = segue.destination as! ChallengeStatusViewController
            nextVC.challenge = selectedChallenge
            nextVC.currentUser = user
            nextVC.previousVC = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userChallenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = userChallenges[indexPath.row].topic
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChallenge = userChallenges[indexPath.row]
        
        performSegue(withIdentifier: "statusSegue", sender: nil)
    }
    
    
    func getStudentDetails() {
        user = Student()
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
                self.getStudentChallenges()
            }
        })
    }
    
    func getStudentChallenges() {
        userChallenges = []
        FIRDatabase.database().reference().child("challenges").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let challenge = Challenge()
            challenge.challengeID = snapshot.key
            challenge.status = (snapshot.value as! NSDictionary)["status"] as! String
            challenge.challengerID = (snapshot.value as! NSDictionary)["challengerID"] as! String
            challenge.senderID = (snapshot.value as! NSDictionary)["senderID"] as! String
            challenge.topic = (snapshot.value as! NSDictionary)["topic"] as! String
            if challenge.challengerID == self.user.studentID || challenge.senderID == self.user.studentID {
                self.userChallenges.append(challenge)
                print(challenge.challengeID)
            }
            self.challengesTableView.reloadData()
        })
    }
 
}
