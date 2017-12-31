//
//  SettingsViewController.swift
//  Note
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var SettingstableView: UITableView!
    @IBOutlet weak var sun: UIImageView!
    @IBOutlet weak var face1: UIImageView!
    @IBOutlet weak var face2: UIImageView!
    
    var sunAnimate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()
        initView()
        initSettingstableView()
        initImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if sunAnimate {
            sunAnimation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !sunAnimate {
            sunAnimation()
        }
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
    
    func initView() {
        view.backgroundColor = UIColor(patternImage: UIImage(named:"Background4")!)
    }
    
    func initSettingstableView() {
        SettingstableView.separatorStyle = UITableViewCellSeparatorStyle.none
        SettingstableView.showsVerticalScrollIndicator = false
        SettingstableView.frame = CGRect(x:0, y:view.frame.height/2 - 80, width:view.frame.width, height: view.frame.height/2 + 80)
        SettingstableView.delegate = self
        SettingstableView.dataSource = self
        SettingstableView.backgroundColor = UIColor(displayP3Red: 252/256, green: 250/256, blue: 242/256, alpha: 1)
    }
    
    func initImage() {
        sun.frame = CGRect(x:view.frame.width/2 - 60, y:view.frame.height/4 - 60, width:120, height: 120)
        face1.frame = CGRect(x:view.frame.width/2 - 60, y:view.frame.height/4 - 60, width:120, height: 120)
        face2.frame = CGRect(x:view.frame.width/2 - 60, y:view.frame.height/4 - 60, width:120, height: 120)
        //face2.isHidden = true
        
        let sunTap = UITapGestureRecognizer.init(target: self, action: #selector(sunAnimation))
        face2.addGestureRecognizer(sunTap)
        face2.isUserInteractionEnabled = true;
        face1.addGestureRecognizer(sunTap)
        face1.isUserInteractionEnabled = true;
    }
    
    // MARK: - table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Settings\(indexPath.row + 1)", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "反馈无效", message: "不听不听，王八念经", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let titleFont = UIFont.systemFont(ofSize: 18)
            let titleAttribute = NSMutableAttributedString.init(string: alertController.title!)
            titleAttribute.addAttributes([NSAttributedStringKey.font:titleFont,
                                          NSAttributedStringKey.foregroundColor:UIColor.red],
                                         range:NSMakeRange(0, (alertController.title?.characters.count)!))
            alertController.setValue(titleAttribute, forKey: "attributedTitle")
            self.present(alertController, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let sb = UIStoryboard(name: "Main", bundle: nil);
            let vc = sb.instantiateViewController(withIdentifier: "AboutUs");
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let alertController = UIAlertController(title: "不在服务区", message: "收不到感谢我也很绝望啊", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let titleFont = UIFont.systemFont(ofSize: 18)
            let titleAttribute = NSMutableAttributedString.init(string: alertController.title!)
            titleAttribute.addAttributes([NSAttributedStringKey.font:titleFont,
                                          NSAttributedStringKey.foregroundColor:UIColor.red],
                                         range:NSMakeRange(0, (alertController.title?.characters.count)!))
            alertController.setValue(titleAttribute, forKey: "attributedTitle")
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Animate
    
    @objc func sunAnimation() {
        if !sunAnimate {
            UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse], animations: {
                self.sun.transform = CGAffineTransform.identity
                    .rotated(by: CGFloat(Double.pi))
                
                let layer = self.face2.layer
                layer.cornerRadius = 5.0
                
                //2.写剧本
                let keyAnimate = CAKeyframeAnimation(keyPath: "position")
                //3.设定关键帧
                let value0 = NSValue(cgPoint: layer.position)
                let value1 = NSValue(cgPoint: CGPoint(x:layer.position.x + 13, y:layer.position.y))
                let value2 = NSValue(cgPoint: CGPoint(x:layer.position.x + 10, y:layer.position.y))
                let value3 = NSValue(cgPoint: CGPoint(x:layer.position.x + 13, y:layer.position.y))
                let value4 = NSValue(cgPoint: CGPoint(x:layer.position.x - 13, y:layer.position.y))
                let value5 = NSValue(cgPoint: CGPoint(x:layer.position.x - 10, y:layer.position.y))
                let value6 = NSValue(cgPoint: CGPoint(x:layer.position.x - 13, y:layer.position.y))
                let value7 = NSValue(cgPoint: layer.position)
                
                //每段执行的时间
                //keyAnimate.keyTimes = [0.0, 0.5, 0.6, 0.7, 1]
                
                keyAnimate.values = [value0, value1, value2, value3, value4, value5, value6, value7]
                keyAnimate.autoreverses = false
                keyAnimate.repeatCount = MAXFLOAT
                keyAnimate.duration = 6.0
                
                layer.add(keyAnimate, forKey: "keyAnimate")
                
            }, completion: nil)
            sunAnimate = true
            //faceAnimation()
        } else {
            sun.layer.removeAllAnimations()
            sun.layer.transform = CATransform3DIdentity
            face2.layer.removeAllAnimations()
            face2.layer.transform = CATransform3DIdentity
            sunAnimate = false
        }
    }
    
    func faceAnimation() {
//        let queue1 = DispatchQueue(label: "cn.edu.nju.Note.queue1", qos: DispatchQoS.userInitiated)
//        queue1.async {
//            while self.sunAnimate {
//                sleep(3)
//                //self.face1.isHidden = !self.face1.isHidden
//                //self.face2.isHidden = !self.face2.isHidden
//                if self.face1.alpha == 0 {
//                    self.face1.alpha = 1
//                } else {
//                    self.face1.alpha = 0
//                }
//                print("run")
//            }
//        }
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
