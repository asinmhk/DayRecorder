//
//  TabBar.swift
//  Note
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit

class TabBar: UITabBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        for item in subviews{
            if item.frame.contains(point){
                if item.isHidden == true {
                    return false
                }
                return true
            }
        }
        return false
    }

}
