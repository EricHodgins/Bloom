//
//  ExcerciseTableCell.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class ExcerciseTableCell: UITableViewCell {

    @IBOutlet weak var excerciseName: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
