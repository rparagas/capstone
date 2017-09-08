//
//  Challenge.swift
//  Multiple Choice Engine
//
//  Created by Ray Paragas on 25/8/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import Foundation

class Challenge {
    var challengeID = ""
    var result = ""
    var score = 0
    var status = ""
    var userType = ""
    var challengerID = ""
    var senderID = ""
    var topic = ""
    var questions : [Question] = []
    var isChallengerComplete = false
    var isSenderComplete = false
    var challengerScore = 0
    var senderScore = 0
}
