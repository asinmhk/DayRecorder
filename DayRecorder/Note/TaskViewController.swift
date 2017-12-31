//
//  TaskViewController.swift
//  Note
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import CoreData


var selectTaskCell = 0

class TaskViewController: UITableViewController, UITextFieldDelegate, UITabBarControllerDelegate {

    var delegate: TaskViewControllerDelegate?
    
    @IBOutlet var Addimage: UIImageView!
    @IBOutlet var NoteAddimage: UIImageView!
    @IBOutlet var TaskAddimage: UIImageView!
    @IBOutlet var Shadowview: UIView!
    @IBOutlet var TaskAddview: UIView!
    @IBOutlet weak var TaskAddtextField: UITextField!
    @IBOutlet weak var barTitle: UINavigationItem!
    
    var curFile = "任务箱"
    var task = [NSManagedObject]()
    var disTask = [NSManagedObject]()
    var taskNotFinished = 0
    
    //var num = 0
    var create:Bool = false
    var add:Bool = false
    var saveDate = Date()
    var saveContent = String()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()
        inittableView()
        initShadowview()
        initAddimage()
        initTaskAddimage()
        initNoteAddimage()
        initTaskAddview()
        
        //键盘监听
        let centerDefault = NotificationCenter.default
        centerDefault.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        //setBackgroundImage(, for: UIBarMetrics.default)
        //self.navigationController.navigationBar.setBarTintColor(UIColor orangeColor)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    func inittableView() {
        //消除cell间隔线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //self.navigationController?.hidesBarsOnSwipe
        //tableview backgroung color
        tableView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        let imgback = UIImage(named:"Background2")
        let imgbackV = UIImageView(image: imgback)
        tableView.backgroundView = imgbackV
//        let blurEffect = UIBlurEffect(style: .light)
//        //创建一个承载模糊效果的视图
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height)
//        let label = UILabel(frame: CGRect(x: 10, y: 100, width: view.frame.width, height: view.frame.height))
//        label.text = "bfjnecsjdkcmslc,samosacmsacdfvneaui"
//        label.font = UIFont.boldSystemFont(ofSize: 30)
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.textColor = UIColor.white
//        blurView.contentView.addSubview(label)
//        tableView.backgroundView?.addSubview(blurView)
        
//        let blurEffect = UIBlurEffect(style: .light)
//        //创建一个承载模糊效果的视图
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = CGRect(x: 0, y: Double(viewHeight+64), width: viewWidth+2*space, height: Double(viewHeight))
//        self.view.addSubview(blurView)
//        //创建并添加vibrancy视图
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
//        let vibrancyView = UIVisualEffectView(effect:vibrancyEffect)
////        vibrancyView.frame = self.view.bounds
//        vibrancyView.frame = CGRect(x:20, y:500, width:200, height:200)
//        tableView.backgroundView?.addSubview(vibrancyView)
//        let label = UILabel(frame: CGRect(x: 10, y: viewY, width: viewWidth - 20, height: 100))
//        label.text = "bfjnecsjdkcmslc,samosacmsacdfvneaui"
//        label.font = UIFont.boldSystemFont(ofSize: 30)
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.textColor = UIColor.white
//        vibrancyView.contentView.addSubview(label)
//        blurView.contentView.addSubview(vibrancyView)
//        self.view.addSubview(blurView)
        
    }
    
    func initAddimage() {
        //加入table view
        self.tableView.addSubview(Addimage)
        //点击事件
        let imgClick = UITapGestureRecognizer(target: self, action: #selector(addText));
        Addimage.addGestureRecognizer(imgClick);
        Addimage.isUserInteractionEnabled = true;
        //阴影效果
        Addimage.layer.shadowOpacity = 0.4
        Addimage.layer.shadowColor = UIColor.black.cgColor
        Addimage.layer.shadowOffset = CGSize(width: 0.4, height: 0.4)
        Addimage.layer.shadowRadius = 1
        
        Addimage.isHidden = true
    }
    
    func initTaskAddimage() {
        self.tableView.addSubview(TaskAddimage)
        TaskAddimage.isHidden = true
        //点击事件
        //let imgClick = UITapGestureRecognizer(target: self, action: #selector(addTask));
        //TaskAddimage.addGestureRecognizer(imgClick);
        TaskAddimage.isUserInteractionEnabled = true;
    }
    
    func initNoteAddimage() {
        self.tableView.addSubview(NoteAddimage)
        NoteAddimage.isHidden = true
        //let imgClick = UITapGestureRecognizer(target: self, action: #selector(addNote));
        //NoteAddimage.addGestureRecognizer(imgClick);
        NoteAddimage.isUserInteractionEnabled = true;
    }
    
    func initShadowview() {
        self.tableView.addSubview(Shadowview)
        Shadowview.frame = CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height)
        Shadowview.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        Shadowview.isHidden = true
        let viewTap = UITapGestureRecognizer.init(target: self, action: #selector(keyboardDismiss))
        Shadowview.addGestureRecognizer(viewTap)
    }
    
    func initTaskAddview() {
        self.tableView.addSubview(TaskAddview)
        TaskAddview.frame = CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height)
        TaskAddview.backgroundColor = UIColor(displayP3Red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        //TaskAddview.isHidden = true
        TaskAddtextField.delegate = self
        TaskAddtextField.frame = CGRect(x:20, y:10, width:TaskAddview.frame.width - 40, height:50)
        TaskAddview.isHidden = true
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TaskDetailViewController {
            let destView = segue.destination as! TaskDetailViewController
            destView.disTask = disTask
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return taskNotFinished
        }

        return disTask.count - taskNotFinished
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        if section == 0 {
            
            let t = disTask[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            
            cell.titlelabel.text = t.value(forKey: "content") as? String
            
            let date = t.value(forKey: "date") as! Date
            
            let dateC = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: date )
            
            cell.timelabel.text = "\(dateC.month!)月\(dateC.day!)日"
            
            //cell.backgroundColor = UIColor.clear
            
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
        
        //cell.backgroundColor = UIColor.clear
        
        cell.backgroundInit()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 54
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectTaskCell = indexPath.row
        }
        else {
            selectTaskCell = indexPath.row + taskNotFinished
        }
    }
    
    @IBAction func taskFinishClick(_ sender: UIButton) {
        let cell = superUITableViewCell(of: sender)!
        let indexpath = tableView.indexPath(for: cell)
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
    
    // MARK: - Header
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            
            let HeaderCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
            
            return HeaderCell
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 1) {
     
            return 25
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if deleteTask(indexPath) {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Add
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        //禁止滑动
        //var offset = scrollView.contentOffset
        //offset.y = 0
        //scrollView.contentOffset = offset
        
//        if (add) {
//            TaskAddimage.frame = CGRect(x:TaskAddimage.frame.origin.x, y:view.frame.maxY - TaskAddimage.frame.size.height * 4 + tableView.contentOffset.y, width:TaskAddimage.frame.size.width, height:TaskAddimage.frame.size.height)
//            NoteAddimage.frame = CGRect(x:NoteAddimage.frame.origin.x, y:view.frame.maxY - NoteAddimage.frame.size.height * 4 + tableView.contentOffset.y, width:NoteAddimage.frame.size.width, height:NoteAddimage.frame.size.height)
//        }
//
//        Addimage.transform = CGAffineTransform.identity
//        Addimage.frame = CGRect(x:view.frame.maxX / 2 - Addimage.frame.size.width / 2, y:self.view.frame.maxY - Addimage.frame.size.height * 2 + self.tableView.contentOffset.y, width:Addimage.frame.size.width, height:Addimage.frame.size.height)
        
    }
    
    @objc func transformAddimage(param p: AnyObject?) {
        if (add) {
            Addimage.image = UIImage.init(imageLiteralResourceName: "TextAddTrans")
            TaskAddimage.frame = CGRect(x:view.frame.maxX / 2 - TaskAddimage.frame.size.width * 1.5, y:view.frame.maxY - TaskAddimage.frame.size.height * 4 + tableView.contentOffset.y, width:TaskAddimage.frame.size.width, height:TaskAddimage.frame.size.height)
            NoteAddimage.frame = CGRect(x:view.frame.maxX / 2 + NoteAddimage.frame.size.width * 0.5, y:view.frame.maxY - NoteAddimage.frame.size.height * 4 + tableView.contentOffset.y, width:NoteAddimage.frame.size.width, height:NoteAddimage.frame.size.height)
            TaskAddimage.isHidden = false
            NoteAddimage.isHidden = false
        }
        else {
            Addimage.image = UIImage.init(imageLiteralResourceName: "TextAdd")
            TaskAddimage.isHidden = true
            NoteAddimage.isHidden = true
            if (!create) {
                Shadowview.isHidden = true
                tableView.isScrollEnabled = false
            }
        }
        Addimage.transform = CGAffineTransform.identity
    }
    
    @objc func addText() {
        /*let rotationAnimation  = CABasicAnimation(keyPath: "transform.rotation.z")//旋转动画
        rotationAnimation.duration = 0.2;//旋转周期
        rotationAnimation.toValue = NSNumber(value:  Double.pi * -0.25 )//旋转角度
        rotationAnimation.isCumulative = true;//旋转累加角度
        rotationAnimation.repeatCount = 1;//旋转次数
        Addimage.layer.add(rotationAnimation, forKey: "rotatiomAnimation")
         */
        
        if (!add) {
            add = true;
            Shadowview.isHidden = false
            tableView.isScrollEnabled = false
            UIView.animate(withDuration: 0.2) {
                self.Addimage.transform = CGAffineTransform.identity
                    .rotated(by: CGFloat(Double.pi/4))
            }
        }
        else {
            add = false;
            UIView.animate(withDuration: 0.2) {
                self.Addimage.transform = CGAffineTransform.identity
                    .rotated(by: CGFloat(-Double.pi/4))
            }
        }
        
        perform(#selector(transformAddimage), with: nil, afterDelay: 0.2)//更换成旋转后图像
        
        //加入 AddTask view
        /*let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewController(withIdentifier: "CalendarView");
        vc.view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.08)
        self.view.addSubview((vc.view)!)
        //willRemoveSubview
        //removeFromSuperview
        */
    }
    
    @objc func addTask() {
        create = true
        addText()
        TaskAddtextField.becomeFirstResponder()
    }

    @objc func addNote() {
        //let vc = AddTaskViewController()
        let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewController(withIdentifier: "NoteAdd");
        self.present(vc, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
    }
    // MARK: - keyBoard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (!create) {
            return
        }
        
        let userinfo: NSDictionary = notification.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRec = nsValue.cgRectValue
        let height = keyboardRec.size.height
        
        TaskAddview.frame = CGRect(x:0, y:view.frame.height - 190 - height, width:view.frame.width, height:view.frame.height)
        TaskAddview.isHidden = false
        /*UIView.animate(withDuration: 0.5, animations: {
         var frame = self.textView.frame
         frame.origin.y = height!
         self.textView.frame = frame
        }, completion: nil)*/
        
    }
    
    @objc func keyboardDismiss(_ sender:Any) {
        TaskAddtextField.resignFirstResponder()
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if (string == "\n") {
//            //print(TaskAddtextField.text ?? 0)
//            saveContent = TaskAddtextField.text!
//            saveTask()
//            TaskAddtextField.text = ""
//            TaskAddtextField.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        TaskAddview.isHidden = true
        Shadowview.isHidden = true
        tableView.isScrollEnabled = true
        create = false
        TaskAddtextField.text = ""
        return true
        
    }
    
    
    // MARK: - Allert
    
    @IBAction func selectedMode(_ sender: UIBarButtonItem) {
        let modeSelector = UIAlertController(title: "选择模式", message: "选择模式", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title:"项目1",style:.default){ (action) in
            
        }
        
        let action2 = UIAlertAction(title:"项目2",style:.default){ (action) in
            
        }
        
        let action3 = UIAlertAction(title:"项目3",style:.default){ (action) in
            
        }
        
        let action4 = UIAlertAction(title:"项目4",style:.default){ (action) in
            
        }
        
        let action5 = UIAlertAction(title:"取消",style:.cancel,handler:nil)
        
        modeSelector.addAction(action1)
        modeSelector.addAction(action2)
        modeSelector.addAction(action3)
        modeSelector.addAction(action4)
        modeSelector.addAction(action5)
        self.present(modeSelector, animated: true, completion: nil)
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
                tableView.reloadData()
            }
        } catch  {
            fatalError("获取失败")
        }
    }
    
    func fetchDisTask() {
        taskNotFinished = 0
        disTask.removeAll()
        for t in task {
            if let filename = t.value(forKey: "file") as? String {
                if filename == curFile {
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
            if let filename = t.value(forKey: "file") as? String {
                if filename == curFile {
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
        tableView.reloadData()
        
    }
    
    @IBAction func deleteAll() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as! [NSManagedObject]
            for f in fetchedResults {
                managedObectContext.delete(f)
            }
        } catch  {
            fatalError("获取失败")
        }
        
        do {
            try managedObectContext.save()
        } catch  {
            fatalError("无法保存")
        }
        
        loadData()
        tableView.reloadData()
    }
//
//    private func saveTask() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedObectContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedObectContext)
//
//        let t = NSManagedObject(entity: entity!, insertInto: managedObectContext)
//        t.setValue(saveContent, forKey: "content")
//        t.setValue(false, forKey: "finish")
//        t.setValue(Date(), forKey: "date")
//        t.setValue(curFile, forKey: "file")
//        t.setValue(Date(), forKey: "createDate")
//        
//        do {
//            try managedObectContext.save()
//        } catch  {
//            fatalError("无法保存")
//        }
//
//        loadData()
//        self.tableView.reloadData()
//    }
    
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
    
    // MARK: - Navigation
    
    // MARK - Detail
    
    @IBAction func exitDetail(segue: UIStoryboardSegue) {
        self.navigationController?.navigationBar.isHidden = false
        print("exit")
//        if let nvc =  sender.source as? NewTodoViewController, let content = nvc.todoTextField.text {
//
//            if !content.isEmpty &&  nvc.isSave {
//                let item = TodoItem()
//                item.content = content
//                self.todoItems.append(item)
//                self.tableView.reloadData()
//            }
//
//        }
    }
    
    
    //Navigation bar 文字颜色
    func preferredStatusBarStyle()->UIStatusBarStyle{
        return UIStatusBarStyle.lightContent;
    }
    
    
    // MARK: - Slide
    
    @IBAction func kittiesTapped(_ sender: Any) {
        delegate?.toggleLeftPanel?()
    }
    
    //  @IBAction func puppiesTapped(_ sender: Any) {
    //    delegate?.toggleRightPanel?()
    //  }
    
    
}

// MARK: - SidePanelViewControllerDelegate
extension TaskViewController: SidePanelViewControllerDelegate {
    
    func didSelectFile(_ name: String) {
        //    imageView.image = animal.image
        //    titleLabel.text = animal.title
        //    creatorLabel.text = animal.creator

        delegate?.collapseSidePanels?()
        curFile = name
        barTitle.title = curFile
        loadData()
    }
    

}
