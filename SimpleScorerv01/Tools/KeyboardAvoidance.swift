//
//  KeyboardAvoidance.swift
//  SimpleScorerv01
//
//  Created by Vadim Bulavin
//


// --------------------------------------------------
// From https://www.vadimbulavin.com/how-to-move-swiftui-view-when-keyboard-covers-text-field/
// --------------------------------------------------

import Foundation
import SwiftUI
import Combine
import UIKit

// Propagating Keyboard Height Changes
extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}


// Extracting Keyboard Avoidance Behavior into SwiftUI ViewModifier
struct KeyboardAdaptive: ViewModifier {
    
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {

//        GeometryReader { geometry in
            content
                .offset(x: 0, y: -self.offset+20)
                
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in

//                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    
                    var screenOrientation: UIInterfaceOrientation? {
                        get {
                            guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
                                #if DEBUG
                                fatalError("Could not obtain UIInterfaceOrientation from a valid windowScene")
                                #else
                                return nil
                                #endif
                            }
                            return orientation
                        }
                    }
                    
                    let screenHeight = UIScreen.main.bounds.height
                    
                    let keyboardTop = screenHeight - keyboardHeight
                    
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0

                    self.offset = max(0, focusedTextInputBottom - keyboardTop )
                    
            }
            .animation(.easeOut(duration: 0.16))
//        }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}


// Avoiding Over-scroll
extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
    
    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}

struct ContentView_AK: View {
    @State private var text = ""
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        VStack {
            Spacer()
            
            TextField("Enter something", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.keyboardAdaptive()
//        .padding()
//        .padding(.bottom, keyboardHeight)
//        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

struct ContentView_AK_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_AK()
    }
}
