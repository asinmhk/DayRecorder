//
//  TaskFileCell.swift
//  Note
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 NJU. All rights reserved.
//


import UIKit


class TaskFileCell: UITableViewCell {
    
    @IBOutlet weak var taskNum: UILabel!
    @IBOutlet weak var fileName: UILabel!
    
    func typeInit() {
        self.backgroundColor = UIColor(displayP3Red: 250/256, green: 214/256, blue: 137/256, alpha: 1)
    }
}
