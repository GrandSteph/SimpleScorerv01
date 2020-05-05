//
//  Helpers.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 5/1/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct BindingProvider<StateT, Content: View>: View {

    @State private var state: StateT
    private var content: (_ binding: Binding<StateT>) -> Content

    init(_ initialState: StateT, @ViewBuilder content: @escaping (_ binding: Binding<StateT>) -> Content) {
        self.content = content
        self._state = State(initialValue: initialState)
    }

    var body: some View {
        self.content($state)
    }
}


// Keyboard slide
// Courtesy of https://stackoverflow.com/questions/56491881/move-textfield-up-when-thekeyboard-has-appeared-by-using-swiftui-ios
struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                // void the possibility of modifying the state of the view while it is being rendered
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}
final class KeyboardGuardian: ObservableObject {
    
    public var rects: Array<CGRect>
    
    public var keyboardRect: CGRect = CGRect()
    // keyboardWillShow notification may be posted repeatedly,
    // this flag makes sure we only act once per keyboard appearance
    public var keyboardIsHidden = true
    @Published var slide: CGFloat = 0

    var showField: Int = 0 {
        didSet {
            updateSlide()
        }
    }
    
    init(textFieldCount: Int) {
        self.rects = Array<CGRect>(repeating: CGRect(), count: textFieldCount)
        
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @objc func keyBoardWillShow(notification: Notification) {
        if keyboardIsHidden {
            keyboardIsHidden = false
            if let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                keyboardRect = rect
                updateSlide()
            }
        }
    }
    
    @objc func keyBoardDidHide(notification: Notification) {
        keyboardIsHidden = true
        updateSlide()
    }
    
    func updateSlide() {
        if keyboardIsHidden {
            slide = 0
        } else {
            let tfRect = self.rects[self.showField]
            let diff = keyboardRect.minY - tfRect.maxY
            
            if diff > 0 {
                slide += diff
            } else {
                slide += min(diff, 0)
            }
            
        }
    }
}


//--------------- UIview / Image

extension CGRect {
    var uiImage: UIImage? {
        UIApplication.shared.windows
            .filter{ $0.isKeyWindow }
            .first?.rootViewController?.view
            .asImage(rect: self)
    }
}

extension View {
    func getRect(_ rect: Binding<CGRect>) -> some View {
        self.modifier(GetRect(rect: rect))
    }
}

struct GetRect: ViewModifier {

    @Binding var rect: CGRect

    var measureRect: some View {
        GeometryReader { proxy in
            Rectangle().fill(Color.clear)
                .preference(key: RectPreferenceKey.self, value:  proxy.frame(in: .global))
        }
    }

    func body(content: Content) -> some View {
        content
            .background(measureRect)
            .onPreferenceChange(RectPreferenceKey.self) { (rect) in
                if let rect = rect {
                    self.rect = rect
                }
            }
    }
}


extension GetRect {
    struct RectPreferenceKey: PreferenceKey {
        static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
            value = nextValue()
        }

        typealias Value = CGRect?

        static var defaultValue: CGRect? = nil
    }
}
