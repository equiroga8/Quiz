//
//  QuizTableViewCell.swift
//  Quiz
//
//  Created by Edu Quibra on 21/11/2018.
//  Copyright © 2018 Edu Quibra. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {

    @IBOutlet weak var favourite: UIButton!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var questionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
