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
    
    @IBOutlet weak var heartViewContainer: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let size = heartViewContainer.frame.width
        let heartView = HeartView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        heartViewContainer.addSubview(heartView)
        heartView.pulse(speed: .slow)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
