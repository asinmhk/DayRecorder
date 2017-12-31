//
//  NoteCell.swift
//  Note
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit


class NoteCell: UITableViewCell {

    var inited = false
    
    @IBOutlet weak var firstFile: UILabel!
    @IBOutlet weak var secondFile: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    func backgroundInit() {
        if !inited {
            background.frame = CGRect(x:0, y:0, width:10, height:54)
            background.backgroundColor = UIColor(displayP3Red: 252/256, green: 159/256, blue: 77/256, alpha: 1)
            self.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
            
            inited = true
        }
    }
    
}
