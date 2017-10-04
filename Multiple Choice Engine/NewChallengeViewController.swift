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

class NewChallengeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var topicPickerView: UIPickerView!
    @IBOutlet weak var studentPickerView: UIPickerView!
    
    var currentUser = Student()
    var topics : [Topic] = []
    var selectedTopic = Topic()
    var students : [Student] = []
    var selectedStudent = Student()
    var questionPool : [Question] = []
    var selectedQuestions : [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        topicPickerView.delegate = self
        topicPickerView.dataSource = self
        studentPickerView.delegate = self
        studentPickerView.dataSource = self
        
        getTopics()
        // Do any additional setup after loading the view.
    }
    
    func getTopics(){
        FIRDatabase.database().reference().child("topic").child(currentUser.subject).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let topic = Topic()
            topic.topicID = snapshot.key
            topic.subjectName = self.currentUser.subject
            topic.topicName = (snapshot.value as! NSDictionary)["topicName"] as! String
            if (topic.subjectName == self.currentUser.subject){
                self.topics.append(topic)
                print(topic.topicName)
            }
            self.topicPickerView.reloadAllComponents()
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.topicPickerView {
            return topics.count
        } else {
            return students.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.topicPickerView {
            let topic = topics[row]
            return topic.topicName
        } else {
            let student = students[row]
            let string = student.firstName + " " + student.lastName
            return string
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.topicPickerView {
            selectedTopic = topics[row]
            getStudentsInClass()
        } else {
            selectedStudent = students[row]
            getQuestionsinTopic()
        }
        
    }
    
    func getStudentsInClass() {
        FIRDatabase.database().reference().child("students").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let student = Student()
            student.studentID = snapshot.key
            student.classID = (snapshot.value as! NSDictionary)["classID"] as! String
            student.firstName = (snapshot.value as! NSDictionary)["firstName"] as! String
            student.lastName = (snapshot.value as! NSDictionary)["lastName"] as! String
            student.username = (snapshot.value as! NSDictionary)["username"] as! String
            student.subject = (snapshot.value as! NSDictionary)["subject"] as! String
            if student.studentID != FIRAuth.auth()!.currentUser!.uid {
                self.students.append(student)
                self.studentPickerView.reloadAllComponents()
            }
        })
    }
    
    func getQuestionsinTopic() {
        FIRDatabase.database().reference().child("questions").child(currentUser.subject).child(selectedTopic.topicID).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let question = Question()
            question.questionID = snapshot.key
            question.question = (snapshot.value as! NSDictionary)["question"] as! String
            self.questionPool.append(question)
            print(question.question)
        })
    }
    
    func selectRandomQuestions() {
        var usedIndex : [Int] = []
        while usedIndex.count < 5 {
            let randomIndex = Int(arc4random_uniform(UInt32(questionPool.count)))
            if (!usedIndex.contains(randomIndex)) {
                selectedQuestions.append(questionPool[randomIndex])
                usedIndex.append(randomIndex)
            }
        }
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        selectRandomQuestions()
        let uuid = NSUUID().uuidString
        uploadChallangeInfo(uuid : uuid)
        uploadChallangeChallenger(uuid: uuid)
        uploadChallengeSender(uuid : uuid)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadChallangeInfo(uuid : String) {
        let newQuestions = ["question1" : selectedQuestions[0].questionID,
                            "question2" : selectedQuestions[1].questionID,
                            "question3" : selectedQuestions[2].questionID,
                            "question4" : selectedQuestions[3].questionID,
                            "question5" : selectedQuestions[4].questionID] as [String : String]
        
        let newChallenge = ["challengerID" : selectedStudent.studentID,
                            "challengerScore" : 0,
                            "isChallengerComplete" : false,
                            "senderID" : currentUser.studentID,
                            "senderScore" : 0,
                            "questions" : newQuestions,
                            "isSenderComplete" : false,
                            "status" : "Pending",
                            "topic" : selectedTopic.topicName,
                            "winner" : "nil"] as [String : Any]
 
        FIRDatabase.database().reference().child("challenges").child(uuid).setValue(newChallenge)
    }
    
    func uploadChallangeChallenger(uuid : String) {
        let studentChallengeChallenger = ["result" : "nil",
                                          "score": 0,
                                          "status" : "pending",
                                          "userType" : "challenger"] as [String : Any]
        FIRDatabase.database().reference().child("studentChallenges").child(selectedStudent.studentID).child(uuid).setValue(studentChallengeChallenger)
    }
    
    func uploadChallengeSender(uuid : String) {
        let studentChallengeSender = ["result" : "nil",
                                      "score" : 0,
                                      "status" : "pending",
                                      "userType" : "sender"] as [String : Any]
        FIRDatabase.database().reference().child("studentChallenges").child(currentUser.studentID).child(uuid).setValue(studentChallengeSender)
    }
}
