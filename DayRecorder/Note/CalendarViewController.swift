//
//  CalendarViewController.swift
//  Note
//
//  Created by apple on 2017/12/2.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var CollectionFrame = CGRect()
    var TableFrame = CGRect()
    
    let DATECELLNUM = 42
    var CurDate = DateComponents()
    var DisDate = DateComponents()
    let dateformatter = DateFormatter()
    var LastClick = IndexPath(row: -1, section: -1)
    var DisMonth = 0
    var CurRow = 0
    
    var PageUpdateClick:Bool = true
    var LastClear:Bool = true
    var ClearIndex = IndexPath(row: -1, section: -1)
    var NeedClear:Bool = false
    
    var task = [NSManagedObject]()
    var disTask = [NSManagedObject]()
    var taskNotFinished = 0
    var selectCell = 0
    
    @IBOutlet weak var CalendarTableView: UITableView!
    @IBOutlet weak var BarTitle: UINavigationItem!
    @IBOutlet weak var CalendarCollectionView: UICollectionView!
    @IBOutlet weak var DateTitle: UIStackView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //绑定delegete
        CalendarTableView.delegate = self
        CalendarTableView.dataSource = self
        //消除cell间隔线
        CalendarTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        TableFrame = CGRect(x:0, y:view.frame.maxY / 2, width:view.frame.maxX, height:view.frame.maxY / 2)
        CalendarTableView.frame = TableFrame
        let imgback = UIImage(named:"Background3")
        let imgbackV = UIImageView(image: imgback)
        CalendarTableView.backgroundView = imgbackV
        //tableview backgroung color
        CalendarTableView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        //button color
        self.navigationController?.navigationBar.tintColor =  UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //background
        self.navigationController?.navigationBar.barTintColor =  UIColor(displayP3Red: 236/256, green: 184/256, blue: 138/256, alpha: 1)
        //text
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
        
    
        //DateTitle
        DateTitle.frame = CGRect(x:0, y:61, width:view.frame.size.width, height:30)
        
        //绑定delegete
        CalendarCollectionView.delegate = self
        CalendarCollectionView.dataSource = self
        //CollectionView
        CollectionFrame = CGRect(x:0, y:90, width:view.frame.size.width, height:view.frame.maxY / 2 - 90)
        CalendarCollectionView.frame = CollectionFrame
        CalendarCollectionView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        //layout
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: CalendarCollectionView.frame.width / 7, height: CalendarCollectionView.frame.height / 6)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        CalendarCollectionView.collectionViewLayout = layout
        CalendarCollectionView.isPagingEnabled = true
        CalendarCollectionView.showsHorizontalScrollIndicator = false
        CalendarCollectionView.showsVerticalScrollIndicator = false
        //Calendar偏移
        CalendarCollectionView.contentOffset.y = CalendarCollectionView.frame.height * 600
        
        
        //date
        dateformatter.dateStyle = .full
        dateformatter.timeStyle = .long
        let dateC = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: Date() )
        CurDate.year = dateC.year
        CurDate.month = dateC.month
        CurDate.day = dateC.day
        DisDate.year = dateC.year
        DisDate.month = dateC.month
        DisDate.day = dateC.day
        
        BarTitle.title = "\(dateC.month!)月"
        
        //DisDate = CurDate
        
        
        /*var currentdate = Date()
        
        var dateString = dateformatter.string(from: currentdate)
        print(dateString)
        
        
        currentdate.addTimeInterval(3600)
        dateString = dateformatter.string(from: currentdate)
        print(dateString)

        
        var components = DateComponents()
        components.year = 2004
        components.day = 1
        components.month = 3
        var newDate1 = calendar.date(from: components)
        newDate1?.addTimeInterval(-3600*24)
        dateString = dateformatter.string(from: newDate1!)
        print(dateString)
        
        let numberOfDays = -3
        let calculatedDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: currentdate)
        dateString = dateformatter.strinFg(from: calculatedDate!)
        print(dateString)
        */
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TaskDetailViewController {
            let destView = segue.destination as! TaskDetailViewController
            destView.disTask = disTask
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return taskNotFinished
        }
        
        return disTask.count - taskNotFinished
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        if section == 0 {
            
            let t = disTask[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            
            cell.titlelabel.text = t.value(forKey: "content") as? String
            
            let date = t.value(forKey: "date") as! Date
            
            let dateC = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: date )
            
            cell.timelabel.text = "\(dateC.month!)月\(dateC.day!)日"
            
            cell.backgroundInit()
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            
            return cell
        }
        
        let t = disTask[indexPath.row + taskNotFinished]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinishCell", for: indexPath) as! TaskCell
        
        cell.titlelabel.text = t.value(forKey: "content") as? String
        
        let date = t.value(forKey: "date") as! Date
        
        let dateC = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: date )
        
        cell.timelabel.text = "\(dateC.month!)月\(dateC.day!)日"
        
        cell.backgroundInit()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectTaskCell = indexPath.row
        }
        else {
            selectTaskCell = indexPath.row + taskNotFinished
        }
    }
    
    @IBAction func taskFinishClick(_ sender: UIButton) {
        let cell = superUITableViewCell(of: sender)!
        let indexpath = CalendarTableView.indexPath(for: cell)
        taskFinishUpdate(indexpath!)
    }
    
    func superUITableViewCell(of: UIButton) -> UITableViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? UITableViewCell {
                return cell
            }
        }
        return nil
    }
    
    //Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 1) {
            
            if (taskNotFinished == disTask.count) {
                return nil
            }
            
            let HeaderCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell2")

            return HeaderCell
        }
        
        let HeaderCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell1") as! TaskCell
        
        HeaderCell.titlelabel.text = "\(DisDate.month!)月\(DisDate.day!)日"
            
        return HeaderCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 1) {
            if (taskNotFinished == disTask.count) {
                return 0
            }
        }
        
        return 25
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if deleteTask(indexPath) {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //100year
        return DATECELLNUM * 1200
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        
        var newDate = Date()
        let numberOfMonths = Int(indexPath.row/42) - 600
        var calculatedDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: newDate)
        var dateComponents = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: calculatedDate! )
        //BarTitle.title = "\(dateComponents.month ?? 0)月"
        let month = dateComponents.month!

        var components = DateComponents()
        components.year = dateComponents.year
        components.day = 1
        components.month = dateComponents.month
        newDate = Calendar.current.date(from: components)!
        dateComponents = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: newDate )
        let weekDay:Int = dateComponents.weekday!
        let numberOfDays = indexPath.row % 42 + 1 - weekDay
        calculatedDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: newDate)
        dateComponents = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: calculatedDate! )
        cell.datelabel.text = "\(dateComponents.day ?? 0)"
        
        //cell date info
        cell.year = dateComponents.year!
        cell.month = dateComponents.month!
        cell.day = dateComponents.day!
        
        cell.taskImage.isHidden = true
        
        if (dateComponents.month! != month) {
            cell.datelabel.textColor = UIColor(displayP3Red: 188/256, green: 196/256, blue: 206/256, alpha: 1.0)
        }
        else {
            cell.datelabel.textColor = UIColor(displayP3Red: 193/256, green: 105/256, blue: 60/256, alpha: 1.0)
            for t in task {
                if let date = t.value(forKey: "date") as? Date {
                    let d = Calendar.current.dateComponents([.year,.month, .day], from: date )
                    if d.year == cell.year && d.month == cell.month && d.day == cell.day {
                        cell.taskImage.isHidden = false
                        break
                    }
                }
            }
        }
        cell.backgroundclickimage.isHidden = true
        
        //click and page update
        if (indexPath.row == LastClick.row) {
            //cell.backgroundclickimage.isHidden = false
            clickImageAnimate(cell: cell)
            cell.datelabel.textColor = UIColor.white
            PageUpdateClick = true;
        }
        
        //current date
        if (CurDate.year == dateComponents.year! && CurDate.month == month && CurDate.month == dateComponents.month! && CurDate.day == dateComponents.day!) {
            cell.backgroundimage.isHidden = false
            cell.datelabel.textColor = UIColor.white
            CurRow = indexPath.row
            //cell.festivallabel.textColor = UIColor.white
        }
        else {
            cell.backgroundimage.isHidden = true
        }
        
        
        cell.datelabel.frame = CGRect(x:cell.frame.width/2 - 20, y:5, width:40, height:20)
        cell.backgroundclickimage.frame = CGRect(x:cell.frame.width/2 - 21, y:cell.frame.height/2 - 21, width:42, height:42)
        cell.backgroundimage.frame = CGRect(x:cell.frame.width/2 - 21, y:cell.frame.height/2 - 21, width:42, height:42)
        cell.taskImage.frame = CGRect(x:cell.frame.width/2 - 6, y:cell.frame.height/2 + 2, width:12, height:12)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var clickPath = indexPath
        
        if let cell2 = CalendarCollectionView.cellForItem(at: indexPath) as? DateCell {
            if (cell2.month != DisMonth) {
                var newDate = Date()
                var components = DateComponents()
                components.year = cell2.year
                components.day = 1
                components.month = cell2.month
                newDate = Calendar.current.date(from: components)!
                var dateComponents = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: newDate )
                let weekDay:Int = dateComponents.weekday!

                if (cell2.month == (DisMonth % 12 + 1)) {
                    //next
                    CalendarCollectionView.scrollToItem(at: IndexPath(item: indexPath.row + 62 - indexPath.row % 42, section: 0), at: .centeredVertically, animated: true)
                    CalendarCollectionView.contentOffset.y = CalendarCollectionView.contentOffset.y + CalendarCollectionView.frame.height/12 + 0.1
                    clickPath = IndexPath(item: indexPath.row - indexPath.row % 42 + 40 + weekDay + cell2.day, section: 0)
                }
                else {
                    //last
                    CalendarCollectionView.scrollToItem(at: IndexPath(item: indexPath.row - 21 - indexPath.row % 42, section: 0), at: .centeredVertically, animated: true)
                    CalendarCollectionView.contentOffset.y = CalendarCollectionView.contentOffset.y - CalendarCollectionView.frame.height/12
                    clickPath = IndexPath(item: indexPath.row - indexPath.row % 42 - 44 + weekDay + cell2.day, section: 0)
                }
                
                PageUpdateClick = false;
            }
            else {
                //cell2.backgroundclickimage.isHidden = false
                //clickImageAnimate(cell: cell2)
                cell2.datelabel.textColor = UIColor.white
            }
            
            if clickPath.row != LastClick.row {
            if (LastClick.row != -1) {
                LastClear = false
                if let cell1 = CalendarCollectionView.cellForItem(at: LastClick) as? DateCell {
                    cell1.backgroundclickimage.isHidden = true
                    if LastClick.row == CurRow {
                        cell1.datelabel.textColor = UIColor.white
                    } else {
                        cell1.datelabel.textColor = UIColor(displayP3Red: 193/256, green: 105/256, blue: 60/256, alpha: 1.0)
                    }
                    LastClear = true
                }
                if (!LastClear) {
                    NeedClear = true
                    ClearIndex = LastClick
                }
            }
            }
            
            DisDate.year = cell2.year
            DisDate.month = cell2.month
            DisDate.day = cell2.day

            
            LastClick = clickPath
            
            /*TODO: Table View info update by cell2 date*/
            loadData()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (NeedClear) {
            if let cell1 = CalendarCollectionView.cellForItem(at: ClearIndex) as? DateCell {
                cell1.backgroundclickimage.isHidden = true
                cell1.datelabel.textColor = UIColor(displayP3Red: 193/256, green: 105/256, blue: 60/256, alpha: 1.0)
                LastClear = true
                NeedClear = false
            }
        }
        if (!PageUpdateClick) {
            if let cell = CalendarCollectionView.cellForItem(at: LastClick) as? DateCell {
                cell.backgroundclickimage.isHidden = false
                cell.datelabel.textColor = UIColor.white
                PageUpdateClick = true
            }
        }
        let newDate = Date()
        let numberOfMonths = Int((CalendarCollectionView.contentOffset.y - CalendarCollectionView.frame.height/2)/CalendarCollectionView.frame.height) - 599
        let calculatedDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: newDate)
        let dateComponents = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: calculatedDate! )
        DisMonth = dateComponents.month!
        if (dateComponents.year != CurDate.year) {
            BarTitle.title = "\(dateComponents.year!)年\(DisMonth)月"
        }
        else {
            BarTitle.title = "\(DisMonth)月"
        }
        
    }
    
    func clickImageAnimate(cell:DateCell) {
        cell.backgroundclickimage.frame = CGRect(x:cell.frame.width/2 - 1, y:cell.frame.height/2 - 1, width:2, height:2)
        cell.backgroundclickimage.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            cell.backgroundclickimage.frame = CGRect(x:cell.frame.width/2 - 21, y:cell.frame.height/2 - 21, width:42, height:42)
        }, completion: nil)
        
    }

    // MARK: - Core Data
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                task = results
                fetchDisTask()
                CalendarTableView.reloadData()
                CalendarCollectionView.reloadData()
            }
        } catch  {
            fatalError("获取失败")
        }
    }
    
    func fetchDisTask() {
        taskNotFinished = 0
        disTask.removeAll()
        for t in task {
            if let date = t.value(forKey: "date") as? Date {
                let d = Calendar.current.dateComponents([.year,.month, .day], from: date )
                if d.year == DisDate.year && d.month == DisDate.month && d.day == DisDate.day {
                    if let finished = t.value(forKey: "finish") as? Bool {
                        if finished == false {
                            disTask.append(t)
                            taskNotFinished = taskNotFinished + 1
                        }
                    }
                }
            }
        }
        
        for t in task {
            if let date = t.value(forKey: "date") as? Date {
                let d = Calendar.current.dateComponents([.year,.month, .day], from: date )
                if d.year == DisDate.year && d.month == DisDate.month && d.day == DisDate.day {
                    if let finished = t.value(forKey: "finish") as? Bool {
                        if finished == true {
                            disTask.append(t)
                        }
                    }
                }
            }
        }
    }
    
    func taskFinishUpdate(_ indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = indexPath.section
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedObectContext)
        
        if section == 0 {
            disTask[row].setValue(true, forKey: "finish")
            let t = NSManagedObject(entity: entity!, insertInto: managedObectContext)
            t.setValue(disTask[row].value(forKey: "content"), forKey: "content")
            t.setValue(disTask[row].value(forKey: "finish"), forKey: "finish")
            t.setValue(disTask[row].value(forKey: "date"), forKey: "date")
            t.setValue(disTask[row].value(forKey: "file"), forKey: "file")
            t.setValue(disTask[row].value(forKey: "createDate"), forKey: "createDate")
            managedObectContext.delete(disTask[row])
            taskNotFinished = taskNotFinished - 1
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
            do {
                let file = disTask[row].value(forKey: "file") as! String
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
            disTask[row + taskNotFinished].setValue(false, forKey: "finish")
            let t = NSManagedObject(entity: entity!, insertInto: managedObectContext)
            t.setValue(disTask[row + taskNotFinished].value(forKey: "content"), forKey: "content")
            t.setValue(disTask[row + taskNotFinished].value(forKey: "finish"), forKey: "finish")
            t.setValue(disTask[row + taskNotFinished].value(forKey: "date"), forKey: "date")
            t.setValue(disTask[row + taskNotFinished].value(forKey: "file"), forKey: "file")
            t.setValue(disTask[row + taskNotFinished].value(forKey: "createDate"), forKey: "createDate")
            managedObectContext.delete(disTask[row + taskNotFinished])
            taskNotFinished = taskNotFinished + 1
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
            do {
                let file = disTask[row].value(forKey: "file") as! String
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
        
        loadData()
        CalendarTableView.reloadData()
        
    }
    
    func deleteTask(_ indexPath:IndexPath) -> Bool {
        let createDate = disTask[indexPath.row].value(forKey: "createDate") as! Date
        let file = disTask[indexPath.row].value(forKey: "file") as! String
        let finish = disTask[indexPath.row].value(forKey: "finish") as! Bool
        
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
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                task = results
                fetchDisTask()
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
    
    //Navigation bar 文字颜色
    func preferredStatusBarStyle()->UIStatusBarStyle{
        return UIStatusBarStyle.lightContent;
    }


}
