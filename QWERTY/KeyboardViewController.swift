//
//  KeyboardViewController.swift
//  Orthokeys
//
//  Created by Zach Laborde on 7/20/20.
//  Copyright © 2020 Zach Laborde. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var nextKeyboardButtonA: UIButton!
    @IBOutlet var nextKeyboardButtonB: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        self.nextKeyboardButtonA = UIButton(type: .system)
        self.nextKeyboardButtonB = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("~", comment: "Title for 'Next Keyboard' button"), for:.normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        createRows(rows: [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L", ";"],
        ["Z", "X", "C", "V", "B", "N", "M", ",", ".", "/"]])
    }
    
    func createRows(rows: [[String]]) {
        var yVal = 0
        let buttonHeight = 50 // Int(UIScreen.main.bounds.size.width)/4
        for strArr in rows {
            let buttons = self.createButtons(titles: strArr)
            let rowContainer = UIView(frame: CGRect(x: 0, y: yVal, width: Int(UIScreen.main.bounds.size.width), height: buttonHeight))
            for button in buttons {
                rowContainer.addSubview(button)
            }
            self.view.addSubview(rowContainer)
            self.addConstraints(buttons: buttons, containingView: rowContainer)
            yVal += buttonHeight
        }
    }

    func createButtons(titles: [String]) -> [UIButton] {

        var buttons: [UIButton] = []

        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: [])
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.setTitleColor(UIColor.darkGray, for: [])
            button.addTarget(self, action: #selector(self.keyPressed(sender:)), for: .touchUpInside)
            buttons.append(button)
        }

        return buttons
    }
    
    @objc func keyPressed(sender: AnyObject?) {
        print("key pressed")
        let button = sender as! UIButton
        let title = button.title(for: .normal)
        (textDocumentProxy as UIKeyInput).insertText(title!)
    }

    func addConstraints(buttons: [UIButton], containingView: UIView){
            
        for (index, button) in buttons.enumerated() {
                
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: containingView, attribute: .top, multiplier: 1.0, constant: 1)
                
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: containingView, attribute: .bottom, multiplier: 1.0, constant: -1)
                
                var leftConstraint : NSLayoutConstraint!
                
                if index == 0 {
                    
                    leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1.0, constant: 1)
                    
                }else{
                    
                    leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: buttons[index-1], attribute: .right, multiplier: 1.0, constant: 1)
                    
                    let widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
                    
                    containingView.addConstraint(widthConstraint)
                }
                
                var rightConstraint : NSLayoutConstraint!
                
                if index == buttons.count - 1 {
                    
                    rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: containingView, attribute: .right, multiplier: 1.0, constant: -1)
                    
                }else{
                    
                    rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: buttons[index+1], attribute: .left, multiplier: 1.0, constant: -1)
                }
                
                containingView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            }
        }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
