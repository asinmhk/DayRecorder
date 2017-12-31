//
//  NoteViewController.swift
//  Note
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import CoreData


var selectNoteCell = 0

var curNoteFile = String()

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var noteFile = [NSManagedObject]()
    var note = [NSManagedObject]()
    var disNote = [NSManagedObject]()
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        curNoteFile = noteFile[selectNoteFileCell].value(forKey: "name") as! String
        loadNoteData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
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
        
        let barButtonItem = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationItem.title = curNoteFile
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
        if segue.destination is NoteDetailViewController {
            let destView = segue.destination as! NoteDetailViewController
            destView.disNote = disNote
        } 
    }
    
    // MARK: - table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disNote.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        
        let text = disNote[indexPath.row].value(forKey: "content") as! String
        
        var content = text.split(separator: "\n")
        
        if content.count > 0 {
            cell.firstFile.text = content.first?.description
            content.removeFirst()
            if let c = content.first?.description {
                cell.secondFile.text = c
            }
        }
        
        let date = disNote[indexPath.row].value(forKey: "date") as! Date
        
        let dateC = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: date)
        
        cell.date.text = "\(dateC.year!)/\(dateC.month!)/\(dateC.day!)"
        
        cell.backgroundInit()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectNoteCell = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 54
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if deleteNote(indexPath) {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    // MARK: - Add Note
    
    @IBAction func addNote() {
        let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewController(withIdentifier: "AddNoteNavigation");
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Core Data
    
    func loadNoteData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                note = results
                fetchDisNote()
                tableView.reloadData()
            }
        } catch  {
            fatalError("获取失败")
        }
    }
    
    func fetchDisNote() {
        disNote.removeAll()
        for n in note {
            if let filename = n.value(forKey: "file") as? String {
                if filename == curNoteFile {
                    disNote.append(n)
                }
            }
        }
    }
    
//    func saveNote() {
//
//        noteNeedSave = false
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedObectContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedObectContext)
//
//        let n = NSManagedObject(entity: entity!, insertInto: managedObectContext)
//        n.setValue(newNoteContent, forKey: "content")
//        n.setValue(Date(), forKey: "date")
//        n.setValue(curFile, forKey: "file")
//
//        do {
//            try managedObectContext.save()
//        } catch  {
//            fatalError("无法保存")
//        }
//
//        loadNoteData()
//        self.tableView.reloadData()
//    }
    
    func deleteNote(_ indexPath:IndexPath) -> Bool {
        let createDate = disNote[indexPath.row].value(forKey: "date") as! Date
        let file = disNote[indexPath.row].value(forKey: "file") as! String
        
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
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                note = results
                fetchDisNote()
            }
        } catch {}
        
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
