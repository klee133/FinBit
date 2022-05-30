//
//  ViewController.swift
//  CoreToDo
//
//  Created by Victor Kenzo Nawa on 9/26/17.
//  Copyright © 2017 Victor Kenzo Nawa. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var uncertain: UILabel!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var creature: UIImageView!
    @IBOutlet weak var egg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    var currentIndexPath: Int?
    
    @IBOutlet weak var UIProcess: UIProgressView!
    @IBOutlet weak var emptyStateView: UIView!
    var tasks: [Task] = []
    
    let progress = Progress(totalUnitCount: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creature.isHidden = true
        heart.isHidden = true
        egg.isHidden = false
        uncertain.isHidden = false
        //Deleta CoreData data
        //self.deleteAllData(entity: "Task")
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didAddTask), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        self.view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.97, alpha:1.0)
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = emptyStateView
        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 140
        
        // Do any additional setup after loading the view, typically from a nib.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound], completionHandler:{ (granted,error) in
            if granted {
                print("Notification access granted")
            } else{
                print("Notification not granted")
            }
        })
        DataManager.shared.firstVC = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        
        currentIndexPath = nil
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            self.viewBottomConstraint.constant = isKeyboardShowing ? -(keyboardFrame?.height)! : 0
            
            print("Bottom View Constraint: \(self.viewBottomConstraint.constant)")
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    
                })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        textField.endEditing(true)  //if desired
        if textField.text! == "" {
            return true
        } else {
            performSegue(withIdentifier: "modal", sender: nil)
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modal" {
            let DestVC: TaskVC = segue.destination as! TaskVC
            
            DestVC.textFromSegue = textField.text!
            
            if let index = currentIndexPath {
                let task = tasks[index]
                DestVC.currentTask = task
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Get the data from Core Data
        getData()
        
        //Reload the table view
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
        print("Bottom View Constraint: \(self.viewBottomConstraint.constant)")

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentIndexPath = indexPath.row
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "modal", sender: nil)
        
        //print("Pressed on row \(indexPath.row)")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tasks.count == 0 {
            // Empty State
            
            tableView.backgroundView?.isHidden = false
            return 0
        } else {

            tableView.backgroundView?.isHidden = true
        }
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasks[indexPath.row]
        
        if task.notificationTime! <= Date() {
            
            task.shouldAct = true
        }
        
        if task.shouldAct {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actionTask", for: indexPath) as! taskActionVC
            
            cell.snoozeButton.tag = indexPath.row
            cell.doneButton.tag = indexPath.row
            cell.updateUI(task: task.name!, time: task.notificationTime!)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! ViewControllerTableViewCell
            
            cell.updateUI(task: task.name!, time: task.notificationTime!)
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func didAddTask(){
        //print("This is my first DELEGATE")
        getData()
        tableView.reloadData()
        print("Bottom View Constraint: \(self.viewBottomConstraint.constant)")
    }
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            let fec: NSFetchRequest = Task.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "notificationTime", ascending: true)
            fec.sortDescriptors = [sortDescriptor]
            tasks = try context.fetch(fec)
        }
        catch{
            print("Fetching failed.")
        }
    }
    
    func clearTextField() {
        textField.text = ""
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteTask(indexPathRow: indexPath.row)
        }
        tableView.reloadData()
    }
    
    @IBAction func snoozeButtonPressed(_ sender: UIButton) {
        currentIndexPath = sender.tag
        performSegue(withIdentifier: "modal", sender: nil)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        deleteTask(indexPathRow: sender.tag)
        tableView.reloadData()
        self.progress.completedUnitCount += 5
        let progressFloat = Float(self.progress.fractionCompleted)
        self.UIProcess.setProgress(progressFloat, animated: true)
        if self.progress.completedUnitCount == 10{
            creature.isHidden = false
            egg.isHidden = true
            uncertain.isHidden = true
            heart.isHidden = false
        }
    }
    
    func deleteTask(indexPathRow: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let task = tasks[indexPathRow]
        //tableView.beginUpdates()
        
        context.delete(task)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //tableView.deleteRows(at: [indexPath], with: .top)
        
        
        do{
            tasks = try context.fetch(Task.fetchRequest())
        }
        catch{
            print("Fetching failed.")
        }
        //tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func deleteAllData(entity: String)
    {
        let managedContext = context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

}

