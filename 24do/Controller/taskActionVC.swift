//
//  taskActionVC.swift
//  24do
//
//  Created by Victor Kenzo Nawa on 10/5/17.
//  Copyright © 2017 Victor Kenzo Nawa. All rights reserved.
//

import UIKit

class taskActionVC: UITableViewCell {

    @IBOutlet weak var snoozeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var task: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var notificationTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        snoozeButton.layer.cornerRadius = 4
        doneButton.layer.cornerRadius = 4
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


    @IBAction func snoozeButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
