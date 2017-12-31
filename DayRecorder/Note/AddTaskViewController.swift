//
//  AddTaskViewController.swift
//  Note
//
//  Created by apple on 2017/12/1.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    

    var Returnbutton = UIButton()
    var TextInputview = UITextView()
    
    var textField = UITextField()
    var keyHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
        

//
//    @objc func doneButtonAction() {
//        //收起键盘
//        self.textField.resignFirstResponder()
//    }
//
//    @IBAction func buttonclick(_ sender:Any) {
//        self.dismiss(animated: true, completion: nil)
//        //TextInputview.resignFirstResponder()
//    }
//
//    @objc func keyboardDismiss(_ sender:Any) {
//        TextInputview.resignFirstResponder()
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        print(3)
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        print(4)
//    }
    
    /*func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            TextInputview.resignFirstResponder()
            return false
        }
        return true
        
    }*/
    
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(2)
        TextInputview.resignFirstResponder()
        return true
    }
    */
}

    //        //textField.delegate = self
    //        textField = UITextField(frame: CGRect(x:20,y:400,width:200,height:30))
    //        //设置边框样式为圆角矩形
    //        textField.borderStyle = UITextBorderStyle.roundedRect
    //        //带小数点的数字键盘
    //        textField.keyboardType = UIKeyboardType.decimalPad
    //        //在键盘上添加“完成“按钮
    //        addDoneButtonOnKeyboard()
    //        self.view.addSubview(textField)
    //


//    func addDoneButtonOnKeyboard() {
//        print("zhiuxing")
//        let doneToolbar = UIToolbar()
//
//        //左侧的空隙
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
//                                        target: nil, action: nil)
//        //右侧的完成按钮
//        let done: UIBarButtonItem = UIBarButtonItem(title: "完成", style: .done,
//                                                    target: self,
//                                                    action: #selector(doneButtonAction))
//
//        var items:[UIBarButtonItem] = []
//        items.append(flexSpace)
//        items.append(done)
//
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        textField.inputAccessoryView = doneToolbar
//    }
