//
//  DateCell.swift
//  Note
//
//  Created by apple on 2017/12/3.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit

protocol DateCellDelegate {
    //func pauseTapped(_ cell: TaskCell)
    
}

class DateCell: UICollectionViewCell {
    
    //date info
    var year = 0
    var month = 0
    var day = 0
    
    var delegate:  DateCellDelegate?
    
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var backgroundimage: UIImageView!
    @IBOutlet weak var backgroundclickimage: UIImageView!
    @IBOutlet weak var taskImage: UIImageView!
    
    
}

