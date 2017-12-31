//
//  NoteDetailViewController.swift
//  Note
//
//  Created by apple on 2017/12/22.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var disNote = [NSManagedObject]()

    var height = CGFloat()
    
    var animate = false
    
    var dateLabel = UILabel()
    
    let trashButton = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadDetail()
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
        
        dateLabel.frame = CGRect(x:view.frame.width/2 - 100, y:85, width:200, height:20)
        dateLabel.font = UIFont.boldSystemFont(ofSize: 12)
        dateLabel.textColor = UIColor(displayP3Red: 176/256, green: 175/256, blue: 177/256, alpha: 1)
        dateLabel.textAlignment = .center
        self.view.addSubview(dateLabel)
        
        trashButton.frame = CGRect(x:view.frame.width*3/4 + 40, y:view.frame.height - 90, width:30, height:28)
        trashButton.setImage(UIImage(named:"Trash"), for: UIControlState.normal)
        let trashTap = UITapGestureRecognizer.init(target: self, action: #selector(trash))
        trashButton.addGestureRecognizer(trashTap)
        self.view.addSubview(trashButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let content = textView.text!
        let word1 = content.replacingOccurrences(of: " ", with: "")
        let word2 = word1.replacingOccurrences(of: "\n", with: "")
        if word2 != "" {
            disNote[selectNoteCell].setValue(textView.text, forKey: "content")
            saveData()
        } else {
            deleteNote()
        }
        if animate {
            textViewFinishAnimate()
        }
    }
    
    @objc func trash() {
        deleteNote()
        self.navigationController?.popViewController(animated: true)
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
    
    func loadDetail() {  
        textView.text = disNote[selectNoteCell].value(forKey: "content") as! String
        let date = disNote[selectNoteCell].value(forKey: "date") as! Date
        let dateC = Calendar.current.dateComponents([.year,.month, .day, .hour, .minute], from: date)
        dateLabel.text = "创建于 \(dateC.year!)年\(dateC.month!)月\(dateC.day!)日 \(dateC.hour!)时\(dateC.minute!)分"
    }
    
    func deleteNote() -> Bool {
        let createDate = disNote[selectNoteCell].value(forKey: "date") as! Date
        let file = disNote[selectNoteCell].value(forKey: "file") as! String
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as! [NSManagedObject]
            for f in fetchedResults {
                let fDate = f.value(forKey: "date") as! Date
                if fDate == createDate {
                    managedObectContext.delete(f)
                }
            }
        } catch  {
            fatalError("获取失败")
        }
        
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteFile")
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
        
        do {
            try managedObectContext.save()
        } catch  {
            fatalError("无法保存")
        }
        
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NoteDetailViewController: UITextViewDelegate {
    
    func textViewFinishAnimate() {
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.textView.frame
            frame = CGRect(x:frame.minX, y:frame.minY + 40, width:frame.width, height:frame.height + self.height - 120)
            self.textView.frame = frame
            frame = self.dateLabel.frame
            self.dateLabel.frame = CGRect(x:frame.minX, y:frame.minY + 40, width:frame.width, height:frame.height)
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
        }, completion: nil)
        
        animate = true
    }
    
}

