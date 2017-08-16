//
//  NewChallengeViewController.swift
//  Multiple Choice Engine
//
//  Created by Ray Paragas on 16/8/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewChallengeTopicViewController: UIViewController {
    
    var currentUser = Student()
    var topics : [Topic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //getStudentDetails()
        getTopic()
        // Do any additional setup after loading the view.
    }
  
    func getStudentDetails() {
        print(FIRAuth.auth()!.currentUser!.uid)
        FIRDatabase.database().reference().child("students").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let user = Student()
            user.studentID = snapshot.key
            user.classID = (snapshot.value as! NSDictionary)["classID"] as! String
            user.firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            user.lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            user.username = (snapshot.value as! NSDictionary)["username"] as! String
            user.subject = (snapshot.value as! NSDictionary)["subject"] as! String
            if (user.studentID == FIRAuth.auth()!.currentUser!.uid) {
                self.currentUser = user
                self.getTopic()
            }
            // add a reload pickerview
        })
    }
    
    func getTopic() {
        FIRDatabase.database().reference().child("topic").child(currentUser.subject).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let topic = Topic()
            topic.topicID = snapshot.key
            topic.subjectName = self.currentUser.subject
            topic.topicName = (snapshot.value as! NSDictionary)["topicName"] as! String
            if (topic.subjectName == self.currentUser.subject){
                self.topics.append(topic)
                print(topic.topicName)
            }
        })
    }
}
