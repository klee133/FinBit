//
//  PlanCell.swift
//  24do
//
//  Created by Victor Kenzo Nawa on 10/4/17.
//  Copyright © 2017 Victor Kenzo Nawa. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {

    @IBOutlet weak var hour: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setHour(hour: Int) {
        var time = Date(timeIntervalSinceNow: TimeInterval(hour*60*60))
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: time)
        time = time - TimeInterval(minutes*60)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh a"
        let dateString = dateFormatter.string(from: time)
        self.hour.text = dateString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
