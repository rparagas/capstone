//
//  TableViewCell.swift
//  Multiple Choice Engine
//
//  Created by Ray Paragas on 4/10/17.
//  Copyright © 2017 Ray Paragas. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setText(challenge: Challenge, userID: String) {
        self.topicLabel.text = challenge.topic
        if challenge.isSenderComplete == true && challenge.isChallengerComplete == true {
            if challenge.winner == userID {
                self.statusLabel.text = "Win"
            } else {
                self.statusLabel.text = "Lost"
            }
        } else {
            self.statusLabel.text = challenge.status
        }
    }
    
}
