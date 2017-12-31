//
//  TaskCell.swift
//  Note
//
//  Created by apple on 2017/11/30.
//  Copyright © 2017年 NJU. All rights reserved.
//


import UIKit

protocol TaskCellDelegate {
    //func pauseTapped(_ cell: TaskCell)

}

class TaskCell: UITableViewCell {
    
    var delegate: TaskCellDelegate?
    
    var inited = false
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var finishimage: UIButton!
    @IBOutlet weak var background: UIView!
    
    func backgroundInit() {
        if !inited {
            
            //background.backgroundColor = UIColor(patternImage: UIImage(named:"CellBackground")!)
            background.frame = CGRect(x:0, y:0, width:10, height:54)
            //background.layer.cornerRadius = 10.0
            //self.sendSubview(toBack: background)
            background.backgroundColor = UIColor(displayP3Red: 252/256, green: 159/256, blue: 77/256, alpha: 1)
            //titlelabel.textColor = UIColor(displayP3Red: 208/256, green: 16/256, blue: 76/256, alpha: 1)
            self.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
        
            inited = true
        }
    }
    //    @IBAction func finishTapped(_ sender: AnyObject) {
//        if (finishimage.image == #imageLiteral(resourceName: "FinishTaskClick")) {
//            print("finish")
//        } else {
//            print("not")
//        }
//    }
    
}

