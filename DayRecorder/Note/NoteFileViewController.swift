//
//  NoteViewController.swift
//  Note
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import CoreData


var selectNoteFileCell = 0

class NoteFileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var noteFile = [NSManagedObject]()
    var newNoteFile = String()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadNoteFileData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()
        initTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - init
    
    func initNavigation() {
        //button color
        self.navigationController?.navigationBar.tintColor =  UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //background
        self.navigationController?.navigationBar.barTintColor =  UIColor(displayP3Red: 236/256, green: 184/256, blue: 138/256, alpha: 1)
        //text
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        let imgback = UIImage(named:"Background5")
        let imgbackV = UIImageView(image: imgback)
        tableView.backgroundView = imgbackV
    }
    
    // MARK: - segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NoteViewController {
            let destView = segue.destination as! NoteViewController
            destView.noteFile = noteFile
        } 
    }
    
    // MARK: - table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteFile.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == noteFile.count) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
            
            let click = UITapGestureRecognizer.init(target: self, action: #selector(addNoteFileClick))
            
            cell.addGestureRecognizer(click)
            
            cell.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! NoteFileCell
        
        cell.noteFile.text = noteFile[indexPath.row].value(forKey: "name") as! String
        
        cell.noteNum.text = "\(noteFile[indexPath.row].value(forKey: "num")!)"
        
        cell.backgroundInit()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectNoteFileCell = indexPath.row
    }
    
    @objc func addNoteFileClick() {
        
        let alertController = UIAlertController(title: "新建文件夹", message: "请为此文件夹输入名称", preferredStyle: .alert)
        
        var nameTextField: UITextField?
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "存储", style: .destructive) { (UIAlertAction) in
            if (nameTextField?.text != "") {
                self.newNoteFile = (nameTextField?.text)!
                self.saveNoteFile()
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
        if indexPath.row == noteFile.count {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if deleteNoteFile(indexPath) { 
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }

    
    // MARK: - Add Note
    
    //    @IBAction func addNote() {
    //        let sb = UIStoryboard(name: "Main", bundle: nil);
    //        let vc = sb.instantiateViewController(withIdentifier: "NoteAdd");
    //        self.present(vc, animated: true, completion: nil)
    //    }
    
    // MARK: - Core Data
    
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
    
    func saveNoteFile() {
        for n in noteFile {
            let name = n.value(forKey: "name") as! String
            if name == newNoteFile {
                let alertController = UIAlertController(title: "创建失败", message: "已存在同名文件夹", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                let titleFont = UIFont.systemFont(ofSize: 18)
                let titleAttribute = NSMutableAttributedString.init(string: alertController.title!)
                titleAttribute.addAttributes([NSAttributedStringKey.font:titleFont,
                                              NSAttributedStringKey.foregroundColor:UIColor.red],
                                             range:NSMakeRange(0, (alertController.title?.characters.count)!))
                alertController.setValue(titleAttribute, forKey: "attributedTitle")
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NoteFile", in: managedObectContext)
        
        let t = NSManagedObject(entity: entity!, insertInto: managedObectContext)
        t.setValue(newNoteFile, forKey: "name")
        t.setValue(Date(), forKey: "date")
        t.setValue(0, forKey: "num")
        
        do {
            try managedObectContext.save()
        } catch  {
            fatalError("无法保存")
        }
        
        loadNoteFileData()
        self.tableView.reloadData()
    }
    
    func deleteNoteFile(_ indexPath:IndexPath) -> Bool {
        let deleteName = noteFile[indexPath.row].value(forKey: "name") as! String
        if deleteName == "默认" {
            let alertController = UIAlertController(title: "删除失败", message: "默认文件夹无法删除", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteFile")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as! [NSManagedObject]
            for f in fetchedResults {
                let fName = f.value(forKey: "name") as! String
                if fName == deleteName {
                    managedObectContext.delete(f)
                    deleteNote(deleteName)
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
                noteFile = results
            }
        } catch {}
        
        return true
    }
    
    func deleteNote(_ name:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

