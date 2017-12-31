//
//  LaunchScreenViewController.swift
//  Note
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("??")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(patternImage: UIImage(named:"LaunchImage")!)
        backgroundView.backgroundColor = UIColor.blue
        backgroundView.frame = CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height)
        self.view.addSubview(backgroundView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
