//
//  ChallengeSummaryViewController.swift
//  Multiple Choice Engine
//
//  Created by Ray Paragas on 6/9/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class ChallengeSummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var scoreSummaryTableView: UITableView!
    
    var questionSet : [Question] = []
    var totalScore = 0
    var currentUser = Student()
    var challenge = Challenge()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreSummaryTableView.dataSource = self
        scoreSummaryTableView.delegate = self
        totalScoreLabel.text = String(totalScore)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if (questionSet[indexPath.row].selectedAnswer == questionSet[indexPath.row].answer) {
            cell.textLabel?.text = "Q" + String(indexPath.row + 1) + " " + questionSet[indexPath.row].selectedAnswer + " " + String(questionSet[indexPath.row].timeTaken) + " ✅"
        } else if (questionSet[indexPath.row].selectedAnswer != questionSet[indexPath.row].answer) {
            cell.textLabel?.text = "Q" + String(indexPath.row + 1) + " " + questionSet[indexPath.row].selectedAnswer + " " + String(questionSet[indexPath.row].timeTaken) + " ❌"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
