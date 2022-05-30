//
//  TaskVC.swift
//  CoreToDo
//
//  Created by Victor Kenzo Nawa on 9/28/17.
//  Copyright © 2017 Victor Kenzo Nawa. All rights reserved.
//

import UIKit
import UserNotifications

class TaskVC: UIViewController {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var textFromSegue = String()
    var currentTask: Task?
    var didSelectRow = false
    
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date(timeIntervalSinceNow: 120)
        
        actionButton.layer.cornerRadius = 4
        
        if currentTask == nil {
            //Writing a Task
            taskName.text = textFromSegue
            actionButton.setTitle("Add" , for: .normal)
        } else {
            //Tapping a task
            taskName.text = currentTask?.name
            actionButton.setTitle("Update" , for: .normal)
        }
        
        

        // Do any additional setup after loading the view.
    }

    @IBAction func addTaskPressed(_ sender: Any) {
        
        var task: Task
        
        if actionButton.title(for: .normal) == "Add"{
        
            task = Task(context: context)
            task.name = taskName.text!
        
        } else {
            
            task = currentTask!
        }
        
        let time = datePicker.date
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        var dateString = dateFormatter.string(from: date)
        var alertTitle: String
        var alertMessage: String
        print("--- Starting Time Prep--- ")
        print("Now: " + dateString)
        alertTitle = "Now: "+dateString
        dateString = dateFormatter.string(from: time)
        print("Chosen: " + dateString)
        alertMessage = "Chosen: "+dateString+"\n"
        
        let timeInterval = time.timeIntervalSinceNow
        let str = NSString(format:"Interval: %.0fh %.0fm %.0fs", (timeInterval/3600).rounded(.towardZero), (timeInterval/60).truncatingRemainder(dividingBy: 60), timeInterval.truncatingRemainder(dividingBy: 60))
        print(str)
        alertMessage = alertMessage + (str as String)
        
        task.notificationTime = time
        
        task.shouldAct = false
        
        //Save the data to Core Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        scheduleNotification(taskName: task.name!, inSeconds: timeInterval, completion: {success in
            if success{
                //print("Successfully scheduled notification")
            } else {
                //print("Error schedulign notification")
            }
        })
        
        DataManager.shared.firstVC.getData()
        DataManager.shared.firstVC.tableView.reloadData()
        DataManager.shared.firstVC.clearTextField()

        dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
       // DataManager.shared.firstVC.present(alert, animated: true, completion: nil)
    }
    
    func scheduleNotification(taskName: String, inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        
        let notif = UNMutableNotificationContent()
        
        notif.title = "Reminder"
        notif.body = taskName
        notif.sound = UNNotificationSound.default()
        
        let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: taskName, content: notif, trigger: notifTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print(error)
                completion(false)
            } else {
                completion(true)
            }
        })
        
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        currentTask = nil
        dismiss(animated:true, completion: {
            
        })
    }

}
