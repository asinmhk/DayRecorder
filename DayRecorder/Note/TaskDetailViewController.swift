//
//  TaskDetailViewController.swift
//  Note
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    let dateLabel = UILabel()
    let trashButton = UIButton()
    let finishButton = UIButton()
    
    var disTask = [NSManagedObject]()
    
    var finish = false
    
    var height = CGFloat()
    
    var animate = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadDetailData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        
        textView.frame = CGRect(x:20, y:120, width:view.frame.width - 40, height:view.frame.height - 230)
        textView.layer.cornerRadius = 10.0
        textView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        textView.showsVerticalScrollIndicator = false
        let viewTap = UITapGestureRecognizer.init(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(viewTap)
        textView.textColor = UIColor(displayP3Red: 242/256, green: 180/256, blue: 90/256, alpha: 1)
        textView.font = UIFont.boldSystemFont(ofSize: 25)
        
        let centerDefault = NotificationCenter.default
        centerDefault.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        dateLabel.frame = CGRect(x:view.frame.width*2/3 + 40, y:85, width:100, height:20)
        dateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        dateLabel.textColor = UIColor(displayP3Red: 240/256, green: 94/256, blue: 28/256, alpha: 1)
        self.view.addSubview(dateLabel)
    
        trashButton.frame = CGRect(x:view.frame.width*3/4 + 40, y:view.frame.height - 90, width:30, height:28)
        trashButton.setImage(UIImage(named:"Trash"), for: UIControlState.normal)
        let trashTap = UITapGestureRecognizer.init(target: self, action: #selector(trash))
        trashButton.addGestureRecognizer(trashTap)
        self.view.addSubview(trashButton)
        
        finishButton.frame = CGRect(x:view.frame.width/3 - 80, y:82, width:20, height:20)
        finish = disTask[selectTaskCell].value(forKey: "finish") as! Bool
        if finish {
            finishButton.setImage(UIImage(named:"FinishTaskClick"), for: UIControlState.normal)
        } else {
            finishButton.setImage(UIImage(named:"TaskClick"), for: UIControlState.normal)
        }
        finishButton.layer.removeAllAnimations()
        let finishTap = UITapGestureRecognizer.init(target: self, action: #selector(finishFunc))
        finishButton.addGestureRecognizer(finishTap)
        self.view.addSubview(finishButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Init
    
    

    override func viewWillDisappear(_ animated: Bool) {
        let content = textView.text!
        let word1 = content.replacingOccurrences(of: " ", with: "")
        let word2 = word1.replacingOccurrences(of: "\n", with: "")
        if word2 != "" {
            disTask[selectTaskCell].setValue(textView.text, forKey: "content")
            saveData()
        } else {
            deleteTask()
        }
        if animate {
            textViewFinishAnimate()
        }
    }
    
    @objc func trash() {
        deleteTask()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func finishFunc() {
        taskFinishUpdate()
        if finish {
            finishButton.setImage(UIImage(named:"FinishTaskClick"), for: UIControlState.normal)
        } else {
            finishButton.setImage(UIImage(named:"TaskClick"), for: UIControlState.normal)
        }
        view.updateConstraints()
    }
    
    
    // MARK: - Core Data
    
    func saveData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedObectContext.save()
        } catch  {
            fatalError("无法保存")
        }
    }
    
    func loadDetailData() {
        textView.text = disTask[selectTaskCell].value(forKey: "content") as! String
        let date = disTask[selectTaskCell].value(forKey: "date") as! Date
        let dateC = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: date)
        dateLabel.text = "\(dateC.month!)月\(dateC.day!)日"
    }
    
    func deleteTask() -> Bool {
        let createDate = disTask[selectTaskCell].value(forKey: "createDate") as! Date
        let file = disTask[selectTaskCell].value(forKey: "file") as! String
        let finish = disTask[selectTaskCell].value(forKey: "finish") as! Bool
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as! [NSManagedObject]
            for f in fetchedResults {
                let fDate = f.value(forKey: "createDate") as! Date
                if fDate == createDate {
                    managedObectContext.delete(f)
                }
            }
        } catch  {
            fatalError("获取失败")
        }
        
        if !finish {
            let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
            do {
                let fetchedResults2 = try managedObectContext.fetch(fetchRequest2) as? [NSManagedObject]
                for f in fetchedResults2! {
                    let name = f.value(forKey: "name") as! String
                    if name == file {
                        var num = f.value(forKey: "num") as! Int
                        num = num - 1
                        f.setValue(num, forKey: "num")
                        break
                    }
                }
            } catch  {
                fatalError("获取失败")
            }
        }
        
        do {
            try managedObectContext.save()
        } catch  {
            fatalError("无法保存")
        }
        
        return true
    }
    
    func taskFinishUpdate() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedObectContext)
        
        if !finish {
            disTask[selectTaskCell].setValue(true, forKey: "finish")
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
            do {
                let file = disTask[selectTaskCell].value(forKey: "file") as! String
                let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
                for f in fetchedResults! {
                    let name = f.value(forKey: "name") as! String
                    if name == file {
                        var num = f.value(forKey: "num") as! Int
                        num = num - 1
                        f.setValue(num, forKey: "num")
                        break
                    }
                }
            } catch  {
                fatalError("获取失败")
            }
        }
        else {
            disTask[selectTaskCell].setValue(false, forKey: "finish")
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
            do {
                let file = disTask[selectTaskCell].value(forKey: "file") as! String
                let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
                for f in fetchedResults! {
                    let name = f.value(forKey: "name") as! String
                    if name == file {
                        var num = f.value(forKey: "num") as! Int
                        num = num + 1
                        f.setValue(num, forKey: "num")
                        break
                    }
                }
            } catch  {
                fatalError("获取失败")
            }
        }
        
        do {
            try managedObectContext.save()
        } catch  {
            fatalError("无法保存")
        }
        
        finish = !finish
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func preferredStatusBarStyle()->UIStatusBarStyle{
        return UIStatusBarStyle.lightContent;
    }
    

}

extension TaskDetailViewController: UITextViewDelegate {
    
    func textViewFinishAnimate() {
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.textView.frame
            frame = CGRect(x:frame.minX, y:frame.minY + 40, width:frame.width, height:frame.height + self.height - 120)
            self.textView.frame = frame
            frame = self.dateLabel.frame
            self.dateLabel.frame = CGRect(x:frame.minX, y:frame.minY + 40, width:frame.width, height:frame.height)
            frame = self.finishButton.frame
            self.finishButton.frame = CGRect(x:frame.minX, y:frame.minY + 40, width:frame.width, height:frame.height)
        }, completion: nil)
    }
    
    @objc func keyboardDismiss(_ sender:Any) {
        textView.resignFirstResponder()
        if animate {
            textViewFinishAnimate()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userinfo: NSDictionary = notification.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRec = nsValue.cgRectValue
        height = keyboardRec.size.height as CGFloat
        
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.textView.frame
            frame = CGRect(x:frame.minX, y:frame.minY - 40, width:frame.width, height:frame.height - self.height + 120)
            self.textView.frame = frame
            frame = self.dateLabel.frame
            self.dateLabel.frame = CGRect(x:frame.minX, y:frame.minY - 40, width:frame.width, height:frame.height)
            frame = self.finishButton.frame
            self.finishButton.frame = CGRect(x:frame.minX, y:frame.minY - 40, width:frame.width, height:frame.height)
         }, completion: nil)
        
        animate = true
    }
    
}
