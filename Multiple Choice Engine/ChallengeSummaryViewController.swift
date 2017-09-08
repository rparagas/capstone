//
//  ChallengeSummaryViewController.swift
//  Multiple Choice Engine
//
//  Created by Ray Paragas on 6/9/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChallengeSummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var scoreSummaryTableView: UITableView!
    
    var questionArray : [String] = []
    var questionSet : [Question] = []
    var totalScore = 0
    var currentUser = Student()
    var challenge = Challenge()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreSummaryTableView.dataSource = self
        scoreSummaryTableView.delegate = self
        if questionSet.count == 0 {
            getChallengeResults()
        }
        updateTotal()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if (questionSet[indexPath.row].isCorrect == true) {
            cell.textLabel?.text = "Q" + String(indexPath.row + 1) + " " + questionSet[indexPath.row].selectedAnswer + " " + String(questionSet[indexPath.row].timeTaken) + " ✅"
        } else if (questionSet[indexPath.row].isCorrect == false) {
            cell.textLabel?.text = "Q" + String(indexPath.row + 1) + " " + questionSet[indexPath.row].selectedAnswer + " " + String(questionSet[indexPath.row].timeTaken) + " ❌"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func getChallengeResults() {
        FIRDatabase.database().reference().child("studentChallenges").child(currentUser.studentID).child(challenge.challengeID).child("results").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let question = Question()
            question.questionID = snapshot.key
            question.selectedAnswer = (snapshot.value as! NSDictionary)["answer"] as! String
            question.isCorrect = (snapshot.value as! NSDictionary)["isCorrect"] as! Bool
            question.timeTaken = Double((snapshot.value as! NSDictionary)["time"] as! Float)

            if question.isCorrect == true {
                self.totalScore += Int(1000 * question.timeTaken)
                self.updateTotal()
            }
            self.questionSet.append(question)
            self.scoreSummaryTableView.reloadData()
        })
    }
    
    func updateTotal() {
        totalScoreLabel.text = String(totalScore)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

}
