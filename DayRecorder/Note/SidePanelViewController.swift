//
//  SidePanelViewController.swift
//  Note
//
//  Created by apple on 2017/12/23.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import CoreData

class SidePanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskFile = [NSManagedObject]()
    var newTaskFile = String()
    
    var delegate: SidePanelViewControllerDelegate?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTaskFileData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 250/256, green: 214/256, blue: 137/256, alpha: 1)
        initTableView()
        //tableView.reloadData()
    }
    
    func initTableView() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor(displayP3Red: 250/256, green: 214/256, blue: 137/256, alpha: 1)
        tableView.frame = CGRect(x:0, y:100, width:view.frame.width - 50, height:view.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskFile.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == taskFile.count) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
            
            let click = UITapGestureRecognizer.init(target: self, action: #selector(addTaskFileClick))
            
            cell.addGestureRecognizer(click)
            
            cell.backgroundColor = UIColor(displayP3Red: 250/256, green: 214/256, blue: 137/256, alpha: 1)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! TaskFileCell
        
        cell.fileName.text = taskFile[indexPath.row].value(forKey: "name") as? String
        
        cell.taskNum.text = "\(taskFile[indexPath.row].value(forKey: "num")!)"
        
        cell.typeInit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectNoteFileCell = indexPath.row
        if indexPath.row != taskFile.count {
            delegate?.didSelectFile(taskFile[indexPath.row].value(forKey: "name") as! String)
        }
    }
    
    @objc func addTaskFileClick() {
        
        let alertController = UIAlertController(title: "新建文件夹", message: "请为此文件夹输入名称", preferredStyle: .alert)
        
        var nameTextField: UITextField?
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "存储", style: .destructive) { (UIAlertAction) in
            if (nameTextField?.text != "") {
                self.newTaskFile = (nameTextField?.text)!
                self.saveTaskFile()
            }
        }
        
        alertController.addTextField {
            (name) -> Void in
            nameTextField = name
            nameTextField!.placeholder = "名称"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == taskFile.count {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if deleteTaskFile(indexPath) {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    // MARK: - Core Data
    
    func loadTaskFileData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                taskFile = results
                tableView.reloadData()
            }
        } catch  {
            fatalError("获取失败")
        }
    }
    
    func saveTaskFile() {
        for n in taskFile {
            let name = n.value(forKey: "name") as! String
            if name == newTaskFile {
                let alertController = UIAlertController(title: "创建失败", message: "已存在同名文件夹", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TaskFile", in: managedObectContext)
        
        let t = NSManagedObject(entity: entity!, insertInto: managedObectContext)
        t.setValue(newTaskFile, forKey: "name")
        t.setValue(0, forKey: "num")
        
        do {
            try managedObectContext.save()
        } catch  {
            fatalError("无法保存")
        }
        
        loadTaskFileData()
        self.tableView.reloadData()
    }
    
    func deleteTaskFile(_ indexPath:IndexPath) -> Bool {
        let deleteName = taskFile[indexPath.row].value(forKey: "name") as! String
        if deleteName == "任务箱" {
            let alertController = UIAlertController(title: "删除失败", message: "默认文件夹无法删除", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let titleFont = UIFont.systemFont(ofSize: 18)
            let titleAttribute = NSMutableAttributedString.init(string: alertController.title!)
            titleAttribute.addAttributes([NSAttributedStringKey.font:titleFont,
                                          NSAttributedStringKey.foregroundColor:UIColor.red],
                                         range:NSMakeRange(0, (alertController.title?.characters.count)!))
            alertController.setValue(titleAttribute, forKey: "attributedTitle")
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as! [NSManagedObject]
            for f in fetchedResults {
                let fName = f.value(forKey: "name") as! String
                if fName == deleteName {
                    managedObectContext.delete(f)
                    deleteTask(deleteName)
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
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                taskFile = results
            }
        } catch {}
        
        return true
    }
    
    func deleteTask(_ name:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as! [NSManagedObject]
            for f in fetchedResults {
                let fName = f.value(forKey: "file") as! String
                if fName == name {
                    managedObectContext.delete(f)
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
    
}
