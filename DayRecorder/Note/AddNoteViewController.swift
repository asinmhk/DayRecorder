//
//  AddNoteViewController.swift
//  Note
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import CoreData



class AddNoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var tableView: UITableView!
    
    var height = CGFloat()
    var animate = false
    var dateLabel = UILabel()
    let holder = UILabel()
    let fileButton = UIButton()
    let trashButton = UIButton()
    let shadowView = UIView()
    let selectFile = UILabel()
    
    var newNoteContent = String()
    var newNoteFile = String()
    
    var noteFile = [NSManagedObject]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadNoteFileData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
//        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor(displayP3Red: 236/256, green: 184/256, blue: 138/256, alpha: 1)
//        }
        
        newNoteFile = curNoteFile
        
        initNavigation()
        
        initTextView()
        
        initTableView()
        
    }
    
    func initNavigation() {
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 236/256, green: 184/256, blue: 138/256, alpha: 1)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }
    
    func initTextView() {
        textView.delegate = self
        textView.frame = CGRect(x:20, y:60, width:view.frame.width - 40, height:view.frame.height - 120)
        
        backgroundView.frame = CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height)
        backgroundView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        let viewTap = UITapGestureRecognizer.init(target: self, action: #selector(keyboardDismiss))
        backgroundView.addGestureRecognizer(viewTap)
        
        textView.frame = CGRect(x:20, y:120, width:view.frame.width - 40, height:view.frame.height - 210)
        textView.layer.cornerRadius = 10.0
        textView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        textView.showsVerticalScrollIndicator = false
        
        textView.textColor = UIColor(displayP3Red: 242/256, green: 180/256, blue: 90/256, alpha: 1)
        textView.font = UIFont.boldSystemFont(ofSize: 25)
        
        holder.frame = CGRect(x:5, y:14, width:300, height:20)
        holder.font = UIFont.boldSystemFont(ofSize: 20)
        holder.text = "准备记点什么？"
        holder.textColor = UIColor.lightGray
        textView.addSubview(holder)

        let centerDefault = NotificationCenter.default
        centerDefault.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        dateLabel.frame = CGRect(x:view.frame.width/2 - 100, y:85, width:200, height:20)
        dateLabel.font = UIFont.boldSystemFont(ofSize: 12)
        dateLabel.textColor = UIColor(displayP3Red: 176/256, green: 175/256, blue: 177/256, alpha: 1)
        dateLabel.textAlignment = .center
        let dateC = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: Date())
        dateLabel.text = "\(dateC.year!)年\(dateC.month!)月\(dateC.day!)日"
        self.view.addSubview(dateLabel)
        
        trashButton.frame = CGRect(x:view.frame.width*3/4 + 40, y:view.frame.height - 60, width:30, height:28)
        trashButton.setImage(UIImage(named:"Trash"), for: UIControlState.normal)
        let trashTap = UITapGestureRecognizer.init(target: self, action: #selector(trash))
        trashButton.addGestureRecognizer(trashTap)
        self.view.addSubview(trashButton)
        
        fileButton.frame = CGRect(x:view.frame.width*3/4 - 90, y:view.frame.height - 60, width:30, height:30)
        fileButton.setImage(UIImage(named:"smallFile"), for: UIControlState.normal)
        let fileTap = UITapGestureRecognizer.init(target: self, action: #selector(file))
        fileButton.addGestureRecognizer(fileTap)
        self.view.addSubview(fileButton)
        
        selectFile.frame = CGRect(x:view.frame.width*3/4 - 50, y:view.frame.height - 60, width:50, height:30)
        selectFile.textAlignment = .left
        selectFile.textColor = UIColor(displayP3Red: 250/256, green: 214/256, blue: 137/256, alpha: 1)
        selectFile.text = newNoteFile
        self.view.addSubview(selectFile)
        
    }

    func initTableView() {
        shadowView.frame = CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height + 60)
        shadowView.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        shadowView.isHidden = true
        let shadowTap = UITapGestureRecognizer.init(target: self, action: #selector(fileDismiss))
        shadowView.addGestureRecognizer(shadowTap)
        self.view.addSubview(shadowView)
        
        tableView.frame = CGRect(x:0, y:view.frame.height, width:view.frame.width, height: 140)
        //tableView.isHidden = true;
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        self.view.bringSubview(toFront: tableView)
        //self.view.addSubview(tableView)
        
    }
    
    @IBAction func returnButtonclick() {
        let content = textView.text!
        let word1 = content.replacingOccurrences(of: " ", with: "")
        let word2 = word1.replacingOccurrences(of: "\n", with: "")
        if word2 != "" {
            newNoteContent = textView.text!
            saveNote()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonclick() {
        newNoteContent = textView.text!
        textView.resignFirstResponder()
        if animate {
            textViewFinishAnimate()
        }
    }
    
    @objc func trash() {
        textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func file() {
        shadowView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame = CGRect(x:0, y:self.view.frame.height - 125, width:self.view.frame.width, height: 140)
        }, completion: nil)
    }
    
    @objc func fileDismiss() {
        shadowView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame = CGRect(x:0, y:self.view.frame.height, width:self.view.frame.width, height: 140)
        }, completion: nil)
    }
    
    func textViewFinishAnimate() {
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.textView.frame
            frame = CGRect(x:frame.minX, y:frame.minY + 40, width:frame.width, height:frame.height + self.height - 80)
            self.textView.frame = frame
            self.dateLabel.frame = CGRect(x:self.view.frame.width/2 - 100, y:85, width:200, height:20)
//            self.trashButton.frame = CGRect(x:self.view.frame.width*3/4 + 40, y:80, width:30, height:28)
//            self.fileButton.frame = CGRect(x:self.view.frame.width*3/4 - 10, y:80, width:30, height:30)
        }, completion: nil)
    }
    
    @objc func keyboardDismiss(_ sender:Any) {
        textView.resignFirstResponder()
        if animate {
            textViewFinishAnimate()
            animate = false
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userinfo: NSDictionary = notification.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRec = nsValue.cgRectValue
        height = keyboardRec.size.height as CGFloat
        
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.textView.frame
            frame = CGRect(x:frame.minX, y:frame.minY - 40, width:frame.width, height:frame.height - self.height + 80)
            self.textView.frame = frame
            
            self.dateLabel.frame = CGRect(x:self.view.frame.width/2 - 100, y:-25, width:200, height:20)
//            self.trashButton.frame = CGRect(x:self.view.frame.width*3/4 + 40, y:-30, width:30, height:28)
//            self.fileButton.frame = CGRect(x:self.view.frame.width*3/4 - 10, y:-30, width:30, height:30)
        }, completion: nil)
        
        animate = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        holder.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            holder.isHidden = false
        }
    }
    
    func saveNote() {
        
        //noteNeedSave = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedObectContext)
        
        let n = NSManagedObject(entity: entity!, insertInto: managedObectContext)
        n.setValue(newNoteContent, forKey: "content")
        n.setValue(Date(), forKey: "date")
        n.setValue(newNoteFile, forKey: "file")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteFile")
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            for f in fetchedResults! {
                let name = f.value(forKey: "name") as! String
                if name == newNoteFile {
                    var num = f.value(forKey: "num") as! Int
                    num = num + 1
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
        
    }
    
    func loadNoteFileData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteFile")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                noteFile = results
                tableView.reloadData()
            }
        } catch  {
            fatalError("获取失败")
        }
    }

}

extension AddNoteViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteFile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! SelectFileCell
        
        cell.fileName.text = noteFile[indexPath.row].value(forKey: "name") as! String
        
        cell.num.text = "\(noteFile[indexPath.row].value(forKey: "num")!)"
        
        if cell.fileName.text == newNoteFile {
            cell.selectImage.isHidden = false
        } else {
            cell.selectImage.isHidden = true
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = noteFile[indexPath.row].value(forKey: "name") as! String
        newNoteFile = file
        selectFile.text = file
        loadNoteFileData()
        shadowView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame = CGRect(x:0, y:self.view.frame.height, width:self.view.frame.width, height: 140)
        }, completion: nil)
    }

}

