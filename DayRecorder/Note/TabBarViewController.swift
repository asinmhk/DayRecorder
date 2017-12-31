//
//  TabBarViewController.swift
//  Note
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController, UITabBarControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var taskFileView: UITableView!
    @IBOutlet var dateView: UICollectionView!
    
    var isAdd:Bool = false
    var newTaskContent = String()
    var newTaskFile = String()
    var taskNeedSave:Bool = false
    var newTaskDate = Date()
    var taskFile = [NSManagedObject]()
    
    let addView = UIView()
    let addTaskButton = UIButton()
    let addNoteButton = UIButton()
    let taskView = UIView()
    let shadowView = UIView()
    let taskAddTextField = UITextField()
    let taskFileSelectButton = UIButton()
    let dateSelectButton = UIButton()
    let dateBackView = UIView()
    let dateCancelButton = UIButton()
    let dateFinishButton = UIButton()
    let dateLabel = UILabel()
    let selectFile = UILabel()
    let selectDate = UILabel()
    
    let DATECELLNUM = 42
    var CurDate = DateComponents()
    var DisDate = DateComponents()
    let dateformatter = DateFormatter()
    var LastClick = IndexPath(row: -1, section: -1)
    var DisMonth = 0
    
    var PageUpdateClick:Bool = true
    var LastClear:Bool = true
    var ClearIndex = IndexPath(row: -1, section: -1)
    var NeedClear:Bool = false
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Thread.sleep(forTimeInterval: 3.0)
        firstLoad()
        
        self.tabBar.barTintColor = UIColor(displayP3Red: 255/256, green: 255/256, blue: 251/256, alpha: 1)
        self.tabBar.isTranslucent = false
        self.tabBar.barStyle = UIBarStyle.black
        self.tabBar.tintColor = UIColor(displayP3Red: 255/256, green: 177/256, blue: 27/256, alpha: 1)
        initSubviews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

    private func initSubviews()
    {
        
        let buttonWidth = self.tabBar.frame.size.width / 5
        let buttonHeight = self.tabBar.frame.size.height
        let button = UIButton()
        button.frame = CGRect(x: buttonWidth * 2, y: 0, width:buttonWidth, height:buttonHeight)
        button.backgroundColor = UIColor(displayP3Red: 255/256, green: 255/256, blue: 251/256, alpha: 1)
        //button.setImage(#imageLiteral(resourceName: "TextAdd"), for: UIControlState.normal)
        //button.setBackgroundImage(#imageLiteral(resourceName: "Image"), for:UIControlState.application)
        button.showsTouchWhenHighlighted = false
        button.layer.removeAllAnimations()
        button.adjustsImageWhenHighlighted = false
        
        //image
        imageView.frame = CGRect(x: self.tabBar.frame.size.width / 2 - buttonHeight / 2 - 10, y: -20, width:buttonHeight + 20, height:buttonHeight + 20)
        imageView.layer.shadowOpacity = 0.4
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0.4, height: 0.4)
        imageView.layer.shadowRadius = 1
        let imgClick = UITapGestureRecognizer(target: self, action: #selector(imageClick));
        imageView.addGestureRecognizer(imgClick);
        imageView.isUserInteractionEnabled = true;
        
        addView.frame = CGRect(x:0, y:buttonHeight, width:view.frame.width, height:buttonHeight + 30)
        addView.layer.cornerRadius = 20.0
        addView.backgroundColor = UIColor(displayP3Red: 255/256, green: 255/256, blue: 251/256, alpha: 1)
        
        addTaskButton.frame = CGRect(x:0, y:buttonHeight, width:buttonWidth * 2, height:buttonHeight)
        let addTaskText = UILabel()
        addTaskText.text = "提醒\n事项"
        addTaskText.textAlignment = .center
        addTaskText.numberOfLines = 2
        addTaskText.font = UIFont.boldSystemFont(ofSize: 14)
        addTaskText.textColor = UIColor(displayP3Red: 252/256, green: 240/256, blue: 242/256, alpha: 1)
        addTaskText.frame = CGRect(x:buttonWidth - 40, y:0, width:80, height:buttonHeight)
        addTaskButton.addSubview(addTaskText)
        addTaskButton.setImage(UIImage(named:"Circle1"), for: UIControlState.normal)
        let addTaskClick = UITapGestureRecognizer.init(target: self, action: #selector(addTask))
        addTaskButton.addGestureRecognizer(addTaskClick)
        
        addNoteButton.frame = CGRect(x:buttonWidth * 3, y:buttonHeight, width:buttonWidth * 2, height: buttonHeight)
        //addNoteButton.backgroundColor = UIColor.lightGray
        let addNoteText = UILabel()
        addNoteText.text = "备忘录"
        addNoteText.textAlignment = .center
        addNoteText.font = UIFont.boldSystemFont(ofSize: 14)
        addNoteText.textColor = UIColor(displayP3Red: 252/256, green: 240/256, blue: 242/256, alpha: 1)
        addNoteText.frame = CGRect(x:buttonWidth - 40, y:0, width:80, height:buttonHeight)
        addNoteButton.addSubview(addNoteText)
        addNoteButton.setImage(UIImage(named:"Circle2"), for: UIControlState.normal)
        let addNoteClick = UITapGestureRecognizer.init(target: self, action: #selector(addNote))
        addNoteButton.addGestureRecognizer(addNoteClick)
        
        
        //button.addTarget(self, action:#selector(buttonClick(_:)), for: UIControlEvents.touchUpInside)
        self.tabBar.addSubview(button)
        self.tabBar.addSubview(addView)
        self.tabBar.addSubview(addTaskButton)
        self.tabBar.addSubview(addNoteButton)
        self.tabBar.addSubview(imageView)
        
        shadowView.frame = CGRect(x:0, y:-view.frame.height, width:view.frame.width, height:view.frame.height + 60)
        shadowView.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        shadowView.isHidden = true
        let viewTap = UITapGestureRecognizer.init(target: self, action: #selector(keyboardDismiss))
        shadowView.addGestureRecognizer(viewTap)
        self.tabBar.addSubview(shadowView)
        
        //taskFileView.frame = CGRect(x:0, y:-view.frame.height/2 - 80, width:view.frame.width, height: 80)
        taskFileView.frame = CGRect(x:0, y:-view.frame.height/2, width:view.frame.width, height: 90)
        taskFileView.isHidden = true;
        taskFileView.delegate = self
        taskFileView.dataSource = self
        taskFileView.layer.cornerRadius = 10.0
        self.tabBar.addSubview(taskFileView)
        
        taskView.frame = CGRect(x:0, y:-view.frame.height/2, width:view.frame.width, height:view.frame.height)
        taskView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        self.tabBar.addSubview(taskView)
        taskView.isHidden = true
        
        taskAddTextField.delegate = self
        taskAddTextField.borderStyle = UITextBorderStyle.roundedRect
        taskAddTextField.frame = CGRect(x:20, y:-view.frame.height/2 + 20, width:taskView.frame.width - 40, height:50)
        taskAddTextField.isHidden = true
        taskAddTextField.textColor = UIColor(displayP3Red: 255/256, green: 177/256, blue: 27/256, alpha: 1)
        self.tabBar.addSubview(taskAddTextField)
        
        taskFileSelectButton.frame = CGRect(x:20, y:-view.frame.height/2 + 90, width:30, height:30)
        taskFileSelectButton.isHidden = true
        taskFileSelectButton.setImage(UIImage(named:"smallFile"), for: UIControlState.normal)
        let fileTap = UITapGestureRecognizer.init(target: self, action: #selector(taskFileSelect))
        taskFileSelectButton.addGestureRecognizer(fileTap)
        self.tabBar.addSubview(taskFileSelectButton)
        
        dateSelectButton.frame = CGRect(x:view.frame.width/2 + 20, y:-view.frame.height/2 + 91, width:28, height:26)
        dateSelectButton.isHidden = true
        dateSelectButton.setImage(UIImage(named:"smallDate"), for: UIControlState.normal)
        let dateTap = UITapGestureRecognizer.init(target: self, action: #selector(dateSelect))
        dateSelectButton.addGestureRecognizer(dateTap)
        self.tabBar.addSubview(dateSelectButton)
        
        //dateBackView.frame = CGRect(x:18, y:-view.frame.height/2 - 240, width:view.frame.width - 36, height: 540)
        dateBackView.frame = CGRect(x:20, y:-view.frame.height/2 + 100, width:view.frame.width - 40, height: 540)
        dateBackView.backgroundColor = UIColor.white
        dateBackView.isHidden = true
        dateBackView.layer.cornerRadius = 10.0
        self.tabBar.addSubview(dateBackView)
        
        dateCancelButton.frame = CGRect(x:38, y:-view.frame.height/2 + 110, width:40, height:40)
        dateCancelButton.isHidden = true;
        dateCancelButton.setTitle("取消", for: UIControlState.normal)
        dateCancelButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        let dateCancelTap = UITapGestureRecognizer.init(target: self, action: #selector(datePrepare))
        dateCancelButton.addGestureRecognizer(dateCancelTap)
        self.tabBar.addSubview(dateCancelButton)
        
        dateFinishButton.frame = CGRect(x:view.frame.width - 38 - 40, y:-view.frame.height/2 + 110, width:40, height:40)
        dateFinishButton.isHidden = true;
        dateFinishButton.setTitle("确定", for: UIControlState.normal)
        dateFinishButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        let dateFinishTap = UITapGestureRecognizer.init(target: self, action: #selector(dateUpdate))
        dateFinishButton.addGestureRecognizer(dateFinishTap)
        self.tabBar.addSubview(dateFinishButton)
        
        //dateView.frame = CGRect(x:20, y:-view.frame.height/2 - 160, width:view.frame.width - 40, height: 320)
        dateView.frame = CGRect(x:20, y:-view.frame.height/2 + 210, width:view.frame.width - 40, height: 320)
        dateView.isHidden = true
        dateView.delegate = self
        dateView.dataSource = self
        dateView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        self.tabBar.addSubview(dateView)
        dateViewInit()
        
        dateLabel.frame = CGRect(x:view.frame.width/2 - 100, y:-view.frame.height/2 + 150, width:200, height:40)
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor(displayP3Red: 252/256, green: 159/256, blue: 46/256, alpha: 1)
        self.tabBar.addSubview(dateLabel)
        dateLabel.isHidden = true
        
        selectFile.frame = CGRect(x:80, y:-view.frame.height/2 + 90, width:200, height:30)
        selectFile.textAlignment = .left
        selectFile.textColor = UIColor(displayP3Red: 250/256, green: 214/256, blue: 137/256, alpha: 1)
        selectFile.isHidden = true
        self.tabBar.addSubview(selectFile)
        
        selectDate.frame = CGRect(x:view.frame.width/2 + 80, y:-view.frame.height/2 + 90, width:200, height:30)
        selectDate.textAlignment = .left
        selectDate.textColor = UIColor(displayP3Red: 250/256, green: 214/256, blue: 137/256, alpha: 1)
        selectDate.isHidden = true
        self.tabBar.addSubview(selectDate)
    }

    
    @objc func imageClick() {
        
        if !isAdd {
            
            isAdd = true
            
            let items = self.tabBar.items
            
            for item in items as! [UITabBarItem] {
                item.isEnabled = false
            }
            
            UIView.animate(withDuration: 0.2) {
                self.imageView.transform = CGAffineTransform.identity
                    .rotated(by: CGFloat(Double.pi/4))
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.addView.frame.origin.y = -20
            }, completion: nil)
            
            perform(#selector(addTaskButtonAnimate1), with: nil, afterDelay: 0.1)
            perform(#selector(addTaskButtonAnimate2), with: nil, afterDelay: 0.4)
            perform(#selector(addTaskButtonAnimate3), with: nil, afterDelay: 0.6)
            
            perform(#selector(addNoteButtonAnimate1), with: nil, afterDelay: 0.2)
            perform(#selector(addNoteButtonAnimate2), with: nil, afterDelay: 0.5)
            perform(#selector(addNoteButtonAnimate3), with: nil, afterDelay: 0.7)
            
        }
        else {
            
            isAdd = false
            
            let items = self.tabBar.items
            
            for item in items as! [UITabBarItem] {
                item.isEnabled = true
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                let height = self.tabBar.frame.size.height
                self.addView.frame.origin.y = height
                self.addTaskButton.frame.origin.y = height
                self.addNoteButton.frame.origin.y = height
            }, completion: nil)
            
            UIView.animate(withDuration: 0.2) {
                self.imageView.transform = CGAffineTransform.identity
                    .rotated(by: CGFloat(0))
            }
            
        }
//        (sender as AnyObject).setImage(#imageLiteral(resourceName: "Image-1"), for: UIControlState.normal)

    }
    
    @objc func addTaskButtonAnimate1() {
        if isAdd {
            UIView.animate(withDuration: 0.3, animations: {
                self.addTaskButton.frame.origin.y = -20
            }, completion: nil)
        }
    }
    
    @objc func addTaskButtonAnimate2() {
        if isAdd {
            UIView.animate(withDuration: 0.2, animations: {
                self.addTaskButton.frame.origin.y = -5
            }, completion: nil)
        }
    }
    
    @objc func addTaskButtonAnimate3() {
        if isAdd {
            UIView.animate(withDuration: 0.4, animations: {
                self.addTaskButton.frame.origin.y = -9
            }, completion: nil)
        }
    }
    
    @objc func addNoteButtonAnimate1() {
        if isAdd {
            UIView.animate(withDuration: 0.3, animations: {
                self.addNoteButton.frame.origin.y = -20
            }, completion: nil)
        }
    }
    
    @objc func addNoteButtonAnimate2() {
        if isAdd {
            UIView.animate(withDuration: 0.2, animations: {
                self.addNoteButton.frame.origin.y = -5
            }, completion: nil)
        }
    }
    
    @objc func addNoteButtonAnimate3() {
        if isAdd {
            UIView.animate(withDuration: 0.4, animations: {
                self.addNoteButton.frame.origin.y = -9
            }, completion: nil)
        }
    }
    
    // MARK: - Task
    
    @IBAction func addTask() {
        imageClick()
        shadowView.isHidden = false
        taskView.isHidden = false
        taskAddTextField.isHidden = false
        taskAddTextField.placeholder = "准备做什么？"
        taskFileSelectButton.isHidden = false
        dateSelectButton.isHidden = false
        newTaskFile = "任务箱"
        newTaskDate = Date()
        taskFileView.isHidden = false
        taskAddTextField.becomeFirstResponder()
        LastClick = IndexPath(row: -1, section: -1)
        dateView.reloadData()
        selectFile.text = newTaskFile
        selectFile.isHidden = false
        let dateC = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: newTaskDate)
        selectDate.text = "\(dateC.month!)月\(dateC.day!)日"
        selectDate.isHidden = false
        dateViewInit()
    }
    
    @IBAction func taskFileSelect() {
        loadTaskFileData()
        taskFileView.scrollToRow(at: IndexPath(item: 0 , section: 0), at: UITableViewScrollPosition.top, animated: false)
        //taskFileView.isHidden = !taskFileView.isHidden
        if taskFileView.frame.origin.y == -self.view.frame.height/2 {
            UIView.animate(withDuration: 0.3, animations: {
                self.taskFileView.frame.origin.y = -self.view.frame.height/2 - 80
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.taskFileView.frame.origin.y = -self.view.frame.height/2
            }, completion: nil)
        }
    }
    
    
    @IBAction func dateSelect() {
//        if taskFileView.isHidden == false {
//            taskFileView.isHidden = true
//        }
        if taskFileView.frame.origin.y == -self.view.frame.height/2 - 80 {
            UIView.animate(withDuration: 0.3, animations: {
                self.taskFileView.frame.origin.y = -self.view.frame.height/2
            }, completion: nil)
        }
        datePrepare()
    }
    
    @IBAction func datePrepare() {
        taskView.isHidden = !taskView.isHidden
        taskAddTextField.isHidden = !taskAddTextField.isHidden
        taskFileSelectButton.isHidden = !taskFileSelectButton.isHidden
        taskFileView.isHidden = !taskFileView.isHidden
        dateSelectButton.isHidden = !dateSelectButton.isHidden
        dateBackView.isHidden = !dateBackView.isHidden
        dateCancelButton.isHidden = !dateCancelButton.isHidden
        dateFinishButton.isHidden = !dateFinishButton.isHidden
        dateLabel.isHidden = !dateLabel.isHidden
        selectFile.isHidden = !selectFile.isHidden
        selectDate.isHidden = !selectDate.isHidden
        if dateView.isHidden == true {
            taskAddTextField.resignFirstResponder()
        } else {
            taskAddTextField.becomeFirstResponder()
        }
        dateView.isHidden = !dateView.isHidden
        if dateView.isHidden == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.dateBackView.frame.origin.y = -self.view.frame.height/2 - 240
                self.dateView.frame.origin.y = -self.view.frame.height/2 - 130
                self.dateCancelButton.frame.origin.y = -self.view.frame.height/2 - 230
                self.dateFinishButton.frame.origin.y = -self.view.frame.height/2 - 230
                self.dateLabel.frame.origin.y = -self.view.frame.height/2 - 190
            }, completion: nil)
        } else {
            self.dateBackView.frame.origin.y = -self.view.frame.height/2 + 100
            self.dateView.frame.origin.y = -self.view.frame.height/2 + 210
            self.dateCancelButton.frame.origin.y = -self.view.frame.height/2 + 110
            self.dateFinishButton.frame.origin.y = -self.view.frame.height/2 + 110
            self.dateLabel.frame.origin.y = -self.view.frame.height/2 + 150
        }
    }
    
    @IBAction func dateUpdate() {
        let string = "\(DisDate.year!)-\(DisDate.month!)-\(DisDate.day!)-20"
        dateformatter.dateFormat = "YYYY-MM-dd-HH"
        let newDate = dateformatter.date(from: string)
        newTaskDate = newDate!
        if DisDate.year! != CurDate.year {
            selectDate.text = "\(DisDate.year!)年\(DisDate.month!)月\(DisDate.day!)日"
        } else {
            selectDate.text = "\(DisDate.month!)月\(DisDate.day!)日"
        }
        datePrepare()
    }
    
    // MARK: - Note
    @IBAction func addNote() {
        imageClick()
        let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewController(withIdentifier: "AddNoteNavigation");
        self.present(vc, animated: true, completion: nil)
        curNoteFile = "默认"
    }
    
    
    // MARK: - Keyboard
    
    @objc func keyboardDismiss() {
        if taskFileView.frame.origin.y == -self.view.frame.height/2 - 80 {
            UIView.animate(withDuration: 0.3, animations: {
                self.taskFileView.frame.origin.y = -self.view.frame.height/2
            }, completion: nil)
        } else if dateView.isHidden == false {
            datePrepare()
        } else {
            taskAddTextField.text = ""
            taskAddTextField.resignFirstResponder()
            shadowView.isHidden = true
            taskView.isHidden = true
            taskAddTextField.isHidden = true
            taskFileSelectButton.isHidden = true
            dateSelectButton.isHidden = true
            taskFileView.isHidden = true
            selectFile.isHidden = true
            selectDate.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            if taskAddTextField.text != "" {
                let content = taskAddTextField.text!
                let word = content.replacingOccurrences(of: " ", with: "")
                if word != "" {
                    newTaskContent = taskAddTextField.text!
                    saveTask()
                }
            }
            if taskFileView.frame.origin.y == -self.view.frame.height/2 - 80 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.taskFileView.frame.origin.y = -self.view.frame.height/2
                }, completion: nil)
            }
            keyboardDismiss()
            return false
        }
        return true
    }
    
    func dateViewInit() {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: dateView.frame.width / 7, height: dateView.frame.height / 6)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        dateView.collectionViewLayout = layout
        dateView.isPagingEnabled = true
        dateView.showsHorizontalScrollIndicator = false
        dateView.showsVerticalScrollIndicator = false
        //Calendar偏移
        dateView.contentOffset.y = dateView.frame.height * 600
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
        dateLabel.text = "\(dateC.month!)月"
    }
    
    // MARK: - Core Data
    public func firstLoad() {
        var first = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResults?.count == 0 {
                first = true
            }
        } catch  {
            fatalError("获取失败")
        }
        
        if first {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObectContext = appDelegate.persistentContainer.viewContext
            let entity1 = NSEntityDescription.entity(forEntityName: "NoteFile", in: managedObectContext)
            
            let t1 = NSManagedObject(entity: entity1!, insertInto: managedObectContext)
            t1.setValue("默认", forKey: "name")
            t1.setValue(Date(), forKey: "date")
            t1.setValue(0, forKey: "num")
            
            let entity2 = NSEntityDescription.entity(forEntityName: "TaskFile", in: managedObectContext)
            
            let t2 = NSManagedObject(entity: entity2!, insertInto: managedObectContext)
            t2.setValue("任务箱", forKey: "name")
            t2.setValue(1, forKey: "num")
            
            let explain = "使用说明:\n日迹应用主要提供两个功能，它可以帮助你罗列每天的行程要点，也可以为你提供一个方便的电子备忘录。\n应用分为四个页面，在底部选择栏从左向右依次为任务页面、日历页面、笔记页面和设置页面。底部选择栏中间的加号提供任务或者笔记的添加功能。\n在任务页面，会显示当前任务文件夹中的所有任务，已完成任务显示在未完成任务后面。点击单个任务左侧的圆形图标可以将任务从未完成（已完成）状态切换为已完成（未完成）状态，点击任务栏可以进入详细显示页面并编辑任务信息，向左滑动任务栏可以选择删除任务。点击左上角的文件夹图标或者向右滑动整个屏幕可以进行文件夹的选择或者添加新的任务文件夹，文件夹右侧显示的数字代表当前文件夹内等待完成的任务数量。\n日历页面主要提供一个日历，日期下有太阳图标代表当前日期存在任务。点击日历中的日期，在下方会显示当前日期中等待完成和已经完成的任务。\n笔记页面会显示当前所拥有的所有笔记文件夹，点击屏幕中的“新建文件夹”可以创建全新的笔记文件夹，点击一个文件夹栏可以进入该文件夹并显示文件夹中的所有文件，继续点击文件会显示文件的详细信息并且可以被二次编辑。向左滑动文件夹或文件栏可以选择删除对应项目。\n理论上设置页面提供应用的设置功能，当然，目前该功能近似为零，不过我贴心的提供了一个动画帮助你打发无聊的时间...\n\nPS:这个工程刚开始是随便摸索着写的（本来只是想写个test熟悉语言，没想直接用的），各种写法，功能写完了不用我都注释掉了，因为怕之后会用到不想再去网上查找。后来用习惯了但是时间紧，也就没有花时间重构一遍代码，所以源码很乱...并且刚开始不了解xcode，第一个界面直接用的tableview controller，第二个界面日历与任务的delegate直接写在了一个view controller里，后来复用的时候也是不想改了，只好直接复制代码。而core data部分，好了我不说了QAQ，总之代码可读性几乎为零，且复用极差，请原谅我没时间重构代码了，我还有JAVA要战..."
            
            let entity3 = NSEntityDescription.entity(forEntityName: "Task", in: managedObectContext)
            
            let t3 = NSManagedObject(entity: entity3!, insertInto: managedObectContext)
            t3.setValue(explain, forKey: "content")
            t3.setValue(false, forKey: "finish")
            t3.setValue("任务箱", forKey: "file")
            t3.setValue(Date(), forKey: "date")
            t3.setValue(Date(), forKey: "createDate")
            
            do {
                try managedObectContext.save()
            } catch  {
                fatalError("无法保存")
            }
            first = false
        }
    }
    
    private func saveTask() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedObectContext)
        
        let t = NSManagedObject(entity: entity!, insertInto: managedObectContext)
        t.setValue(newTaskContent, forKey: "content")
        t.setValue(false, forKey: "finish")
        t.setValue(newTaskDate, forKey: "date")
        t.setValue(newTaskFile, forKey: "file")
        t.setValue(Date(), forKey: "createDate")

        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            for f in fetchedResults! {
                let name = f.value(forKey: "name") as! String
                if name == newTaskFile {
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
        
        if let nav = self.selectedViewController as? ContainerViewController {
            nav.centerViewController.loadData()
        }
        else if let nav = self.selectedViewController as? UINavigationController {
            nav.loadView()
        }
        
    }
    
    func loadTaskFileData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskFile")
        
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                taskFile = results
                taskFileView.reloadData()
            }
        } catch  {
            fatalError("获取失败")
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
    
    func preferredStatusBarStyle()->UIStatusBarStyle{
        return UIStatusBarStyle.lightContent;
    }

}

extension TabBarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskFile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! SelectFileCell
        
        cell.fileName.text = taskFile[indexPath.row].value(forKey: "name") as! String
        
        cell.num.text = "\(taskFile[indexPath.row].value(forKey: "num")!)"
        
        if cell.fileName.text == newTaskFile {
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
        let file = taskFile[indexPath.row].value(forKey: "name") as! String
        newTaskFile = file
        selectFile.text = file
        loadTaskFileData()
        UIView.animate(withDuration: 0.3, animations: {
            self.taskFileView.frame.origin.y = -self.view.frame.height/2
        }, completion: nil)
    }
    
}

extension TabBarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
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
        
        if (dateComponents.month! != month) {
            cell.datelabel.textColor = UIColor(displayP3Red: 188/256, green: 196/256, blue: 206/256, alpha: 1.0)
        }
        else {
            cell.datelabel.textColor = UIColor(displayP3Red: 193/256, green: 105/256, blue: 60/256, alpha: 1)
        }
        cell.backgroundclickimage.isHidden = true
        
        //click and page update
        if (indexPath.row == LastClick.row) {
            clickImageAnimate(cell: cell)
            cell.datelabel.textColor = UIColor.white
            PageUpdateClick = true;
        }
        
        //current date
        if (CurDate.year == dateComponents.year! && CurDate.month == month && CurDate.month == dateComponents.month! && CurDate.day == dateComponents.day!) {
            cell.backgroundimage.isHidden = false
            cell.datelabel.textColor = UIColor.white
            //cell.festivallabel.textColor = UIColor.white
        }
        else {
            cell.backgroundimage.isHidden = true
        }
        
        cell.datelabel.frame = CGRect(x:cell.frame.width/2 - 20, y:cell.frame.height/2 - 10, width:40, height:20)
        cell.datelabel.textAlignment = .center
        cell.backgroundclickimage.frame = CGRect(x:cell.frame.width/2 - 21, y:cell.frame.height/2 - 21, width:42, height:42)
        cell.backgroundimage.frame = CGRect(x:cell.frame.width/2 - 21, y:cell.frame.height/2 - 21, width:42, height:42)
        cell.taskImage.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var clickPath = indexPath
        
        if let cell2 = dateView.cellForItem(at: indexPath) as? DateCell {
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
                    dateView.scrollToItem(at: IndexPath(item: indexPath.row + 62 - indexPath.row % 42, section: 0), at: .centeredVertically, animated: true)
                    dateView.contentOffset.y = dateView.contentOffset.y + dateView.frame.height/12 + 0.1
                    clickPath = IndexPath(item: indexPath.row - indexPath.row % 42 + 40 + weekDay + cell2.day, section: 0)
                }
                else {
                    //last
                    dateView.scrollToItem(at: IndexPath(item: indexPath.row - 21 - indexPath.row % 42, section: 0), at: .centeredVertically, animated: true)
                    dateView.contentOffset.y = dateView.contentOffset.y - dateView.frame.height/12
                    clickPath = IndexPath(item: indexPath.row - indexPath.row % 42 - 44 + weekDay + cell2.day, section: 0)
                }
                
                PageUpdateClick = false;
            }
            else {
                //cell2.backgroundclickimage.isHidden = false
                cell2.datelabel.textColor = UIColor.white
            }
            
            if clickPath.row != LastClick.row {
                if (LastClick.row != -1) {
                    LastClear = false
                    if let cell1 = dateView.cellForItem(at: LastClick) as? DateCell {
                        cell1.backgroundclickimage.isHidden = true
                        cell1.datelabel.textColor = UIColor(displayP3Red: 193/256, green: 105/256, blue: 60/256, alpha: 1)
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
            
            dateView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (NeedClear) {
            if let cell1 = dateView.cellForItem(at: ClearIndex) as? DateCell {
                cell1.backgroundclickimage.isHidden = true
                cell1.datelabel.textColor = UIColor(displayP3Red: 193/256, green: 105/256, blue: 60/256, alpha: 1)
                LastClear = true
                NeedClear = false
            }
        }
        if (!PageUpdateClick) {
            if let cell = dateView.cellForItem(at: LastClick) as? DateCell {
                cell.backgroundclickimage.isHidden = false
                cell.datelabel.textColor = UIColor.white
                PageUpdateClick = true
            }
        }
        let newDate = Date()
        let numberOfMonths = Int((dateView.contentOffset.y - dateView.frame.height/2)/dateView.frame.height) - 599
        let calculatedDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: newDate)
        let dateComponents = Calendar.current.dateComponents([.year,.month, .day, .weekday], from: calculatedDate! )
        DisMonth = dateComponents.month!
        
        if (dateComponents.year != CurDate.year) {
            dateLabel.text = "\(dateComponents.year!)年\(DisMonth)月"
        }
        else {
            dateLabel.text = "\(DisMonth)月"
        }
    }
    
    func clickImageAnimate(cell:DateCell) {
        cell.backgroundclickimage.frame = CGRect(x:cell.frame.width/2 - 1, y:cell.frame.height/2 - 1, width:2, height:2)
        cell.backgroundclickimage.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            cell.backgroundclickimage.frame = CGRect(x:cell.frame.width/2 - 21, y:cell.frame.height/2 - 21, width:42, height:42)
        }, completion: nil)
        
    }
}

