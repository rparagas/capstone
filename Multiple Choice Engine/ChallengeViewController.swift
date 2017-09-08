//
//  ChallengeViewController.swift
//  Multiple Choice Engine
//
//  Created by Ray Paragas on 27/8/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChallengeViewController: UIViewController {

    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!

    
    var challenge = Challenge()
    var topic = Topic()
    var currentUser = Student()
    var questionArray : [String] = []
    var questionSet : [Question] = []
    var questionCounter = 0
    var timer = Timer()
    var currentTimeInSeconds = 0.00
    var totalScore = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestionSet()
        // Do any additional setup after loading the view.
    }
    
    func getQuestionSet() {
        FIRDatabase.database().reference().child("questions").child(currentUser.subject).child(topic.topicID).observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let question = Question()
            question.questionID = snapshot.key
            question.answer = (snapshot.value as! NSDictionary)["answer"] as! String
            question.question = (snapshot.value as! NSDictionary)["question"] as! String
            question.option1 = (snapshot.value as! NSDictionary)["option1"] as! String
            question.option2 = (snapshot.value as! NSDictionary)["option2"] as! String
            question.option3 = (snapshot.value as! NSDictionary)["option3"] as! String
            question.option4 = (snapshot.value as! NSDictionary)["option4"] as! String
            if self.questionArray.contains(question.questionID)  {
                self.questionSet.append(question)
                print(question.questionID)
            }
        })
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        setTime()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.displayTime), userInfo: nil, repeats: true)
        displayQuestion()
    }
    
    func setTime() {
        currentTimeInSeconds = 20
    }
    
    func displayTime() {
        if currentTimeInSeconds <= 0 {
            saveTimeUsed()
            noAnswer()
            incrementQuestionCounter()
            setTime()
            displayQuestion()
        } else {
            currentTimeInSeconds -= 0.01
            timerLabel.text = String(currentTimeInSeconds)
        }
    }
    
    func displayQuestion() {
        if questionCounter < 5 {
            questionNumberLabel.text = "Question " + String(questionCounter+1)
            questionLabel.text = questionSet[questionCounter].question
            option1Button.setTitle(questionSet[questionCounter].option1, for: .normal)
            option2Button.setTitle(questionSet[questionCounter].option2, for: .normal)
            option3Button.setTitle(questionSet[questionCounter].option3, for: .normal)
            option4Button.setTitle(questionSet[questionCounter].option4, for: .normal)
        } else {
            for question in questionSet {
                print(question.selectedAnswer)
                print(question.timeTaken)
            }
            calculateAnswer()
            uploadAnswers()
            performSegue(withIdentifier: "challengeCompleteSegue", sender: nil)
        }
    }
    
    @IBAction func option1Tapped(_ sender: Any) {
        saveAnswer(option: 1)
        saveTimeUsed()
        setTime()
        incrementQuestionCounter()
        displayQuestion()
    }
    
    @IBAction func option2Tapped(_ sender: Any) {
        saveAnswer(option: 2)
        saveTimeUsed()
        setTime()
        incrementQuestionCounter()
        displayQuestion()
    }
    
    @IBAction func option3Tapped(_ sender: Any) {
        saveAnswer(option: 3)
        saveTimeUsed()
        setTime()
        incrementQuestionCounter()
        displayQuestion()
    }
    
    @IBAction func option4Tapped(_ sender: Any) {
        saveAnswer(option: 4)
        saveTimeUsed()
        setTime()
        incrementQuestionCounter()
        displayQuestion()
    }
    
    func noAnswer() {
        questionSet[questionCounter].selectedAnswer = "null"
    }
    
    func incrementQuestionCounter() {
        questionCounter += 1
    }
    
    func saveTimeUsed() {
        if currentTimeInSeconds <= 0 {
            questionSet[questionCounter].timeTaken = currentTimeInSeconds
        } else {
            questionSet[questionCounter].timeTaken = currentTimeInSeconds
        }
    }

    func saveAnswer(option: Int) {
        if (option == 1) {
            questionSet[questionCounter].selectedAnswer = "option1"
        } else if (option == 2) {
            questionSet[questionCounter].selectedAnswer = "option2"
        } else if (option == 3) {
            questionSet[questionCounter].selectedAnswer = "option3"
        } else if (option == 4) {
            questionSet[questionCounter].selectedAnswer = "option4"
        }
    }
    
    func calculateAnswer() {
        timer.invalidate()
        for question in questionSet {
            checkAnwers(question: question)
            if question.answer == question.selectedAnswer {
                totalScore += 1000 * question.timeTaken
            } else {
                question.timeTaken = 0.0
            }
        }
        print(Int(totalScore))
    }
    
    func checkAnwers(question: Question) {
        if (question.answer == question.selectedAnswer) {
            question.isCorrect = true
        } else if (question.answer != question.selectedAnswer) {
            question.isCorrect = false
        }
    }
    
    func uploadAnswers() {
        let questionZero = ["answer": questionSet[0].selectedAnswer,
                            "time": questionSet[0].timeTaken,
                            "isCorrect":questionSet[0].isCorrect
        ] as [String : Any]
        
        let questionOne = ["answer": questionSet[1].selectedAnswer,
                           "time": questionSet[1].timeTaken,
                           "isCorrect":questionSet[1].isCorrect
        ] as [String : Any]
        
        let questionTwo = ["answer": questionSet[2].selectedAnswer,
                           "time": questionSet[2].timeTaken,
                           "isCorrect":questionSet[2].isCorrect
        ] as [String : Any]
        
        let questionThree = ["answer": questionSet[3].selectedAnswer,
                             "time": questionSet[3].timeTaken,
                             "isCorrect":questionSet[3].isCorrect
        ] as [String : Any]
        
        let questionFour = ["answer": questionSet[4].selectedAnswer,
                            "time": questionSet[4].timeTaken,
                            "isCorrect":questionSet[4].isCorrect
        ] as [String : Any]
        
        let results = [questionSet[0].questionID : questionZero,
                       questionSet[1].questionID : questionOne,
                       questionSet[2].questionID : questionTwo,
                       questionSet[3].questionID : questionThree,
                       questionSet[4].questionID : questionFour
        ] as [String : Any]
        
        FIRDatabase.database().reference().child("studentChallenges").child(currentUser.studentID).child(challenge.challengeID).child("score").setValue(Int(totalScore))
        
        FIRDatabase.database().reference().child("studentChallenges").child(currentUser.studentID).child(challenge.challengeID).child("results").setValue(results)
    
        FIRDatabase.database().reference().child("studentChallenges").child(currentUser.studentID).child(challenge.challengeID).child("status").setValue("completed")
        
        if currentUser.studentID == challenge.challengerID {
            FIRDatabase.database().reference().child("challenges").child(challenge.challengeID).child("isChallengerComplete").setValue(true)
        } else {
            FIRDatabase.database().reference().child("challenges").child(challenge.challengeID).child("isSenderComplete").setValue(true)
        }
        
        if currentUser.studentID == challenge.challengerID {
            FIRDatabase.database().reference().child("challenges").child(challenge.challengeID).child("challengerScore").setValue(Int(totalScore))
        } else {
            FIRDatabase.database().reference().child("challenges").child(challenge.challengeID).child("senderScore").setValue(Int(totalScore))
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! ChallengeSummaryViewController
        nextVC.challenge = challenge
        nextVC.currentUser = currentUser
        nextVC.questionSet = questionSet
        nextVC.totalScore = Int(totalScore)
    }
    
}
