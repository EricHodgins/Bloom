//
//  LiveExcerciseCell.swift
//  Bloom
//
//  Created by Eric Hodgins on 2018-02-28.
//  Copyright © 2018 Eric Hodgins. All rights reserved.
//

import UIKit

class LiveExcerciseCell: UITableViewCell {

    @IBOutlet weak var excerciseName: UILabel!
    
    @IBOutlet weak var excerciseDetails: UILabel!
    
    @IBOutlet weak var timeCompleteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
