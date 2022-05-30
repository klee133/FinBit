//
//  ViewControllerTableViewCell.swift
//  CoreToDo
//
//  Created by Victor Kenzo Nawa on 9/29/17.
//  Copyright © 2017 Victor Kenzo Nawa. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var task: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var notificationTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(task: String, time: Date) {
        taskName.text = task
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        var dateString = dateFormatter.string(from: time)
        if dateString.hasPrefix("0") {
            dateString.remove(at: dateString.startIndex)
        }
        notificationTime.text = dateString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }

}
