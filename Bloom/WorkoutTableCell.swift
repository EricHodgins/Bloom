//
//  WorkoutTableCell.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-06-15.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class WorkoutTableCell: UITableViewCell {
    
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutDate: UILabel!
    @IBOutlet weak var workoutDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
