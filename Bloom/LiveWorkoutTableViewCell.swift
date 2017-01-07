//
//  LiveWorkoutTableViewCell.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-01-02.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class LiveWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var excerciseLabel: UILabel!
    @IBOutlet weak var excerciseTextField: UITextField!
    @IBOutlet weak var excerciseSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
