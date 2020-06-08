//
//  SATextField.swift
//  SimpleScorerv01
//
//  Created by Dev on 6/8/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

class WrappableTextField: UITextField, UITextFieldDelegate {
    var textFieldChangedHandler: ((String)->Void)?
    var onCommitHandler: (()->Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        onCommitHandler?()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let currentValue = textField.text as NSString? {
            let proposedValue = currentValue.replacingCharacters(in: range, with: string)
            textFieldChangedHandler?(proposedValue as String)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

//         onCommitHandler?()
    }
}

struct SATextField: UIViewRepresentable {
    private let tmpView = WrappableTextField()

    //var exposed to SwiftUI object init
    var tag:Int = 0
    var placeholder:String?
    var returnKey : UIReturnKeyType?
    var changeHandler:((String)->Void)?
    var onCommitHandler:(()->Void)?
    
    func makeUIView(context: UIViewRepresentableContext<SATextField>) -> WrappableTextField {
        
        // set rounded font
        let fontSize: CGFloat = 32
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        let roundedFont: UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            roundedFont = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            roundedFont = systemFont
        }
        
        // Specific to this project
        if tag == 0 {
            tmpView.becomeFirstResponder()
        }
        
        tmpView.textColor = UIColor.white
        tmpView.font = roundedFont
        tmpView.tag = tag
        tmpView.delegate = tmpView
        tmpView.placeholder = placeholder
        tmpView.autocorrectionType = .no
        if returnKey != nil {
            tmpView.returnKeyType = returnKey!
        }
        tmpView.onCommitHandler = onCommitHandler
        tmpView.textFieldChangedHandler = changeHandler
        return tmpView
    }
    
    func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<SATextField>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

struct ContentView : View {
    @State var username:String = ""
    @State var email:String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(username)
                Spacer()
                Text(email)
            }
            SATextField(tag: 0, placeholder: "@username", changeHandler: { (newString) in
                self.username = newString
            }, onCommitHandler: {
                print("commitHandler")
            })
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)).background(Color.red)
            
            SATextField(tag: 1, placeholder: "@email", changeHandler: { (newString) in
                self.email = newString
            }, onCommitHandler: {
                print("commitHandler")
            })
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)).background(Color.red)
        }
    }
}
