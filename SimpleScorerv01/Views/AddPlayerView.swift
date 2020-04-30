//
//  AddPlayerView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/27/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI



struct AddPlayerView: View {
    
    @Binding var game : Game
    
    enum Stage {
        case
            collapsed ,
            atNameEntry ,
            atPictureChoice
    }
    
    @State private var stage = Stage.atPictureChoice
    @State private var username: String = "Steph"
    
    @State private var showImagePicker = false
    @State private var imagePicked = UIImage()
    
    
    let frameHeight = CGFloat(135)
    
    var body: some View {
        ZStack {

                if stage == .collapsed {
                    Button(action: {
                        self.stage = .atNameEntry
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .padding(15)
                            .contentShape(Rectangle())
                            .background(Color.orangeStart)
                            .clipShape(Rectangle()).cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                } else if stage == .atNameEntry {
                    
                    LinearGradient(Color.orangeStart, Color.orangeEnd)
                    
                    TextField("name", text: $username, onCommit: {self.stage = .atPictureChoice})
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.default)
                    
                    
                } else if stage == .atPictureChoice {
                    
                    LinearGradient(Color.orangeStart, Color.orangeEnd)
                    
                    HStack () {
                        Button(action: {
                            self.showImagePicker.toggle()
//                            self.game.addPlayer(player: Player(name: self.username, shortName: self.username, photoURL: "steph", color: .orange, colorStart: .orangeStart, colorEnd: .orangeEnd))
//                            self.stage = .collapsed
                        }) {
                            AvatarView(image: Image(uiImage: self.imagePicked))
                                .padding(10)
                                .frame(width: frameHeight, height: frameHeight*2/3)
                        }
                        .sheet(isPresented: self.$showImagePicker, content: {
                            ImagePickerView(isPresented: self.$showImagePicker, selectedImage: self.$imagePicked)
                        })
                        
                        

                        Text(self.username)
                            .fontWeight(.semibold)
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(Color .offWhite)
                        
                        Spacer()
                        
                        Button(action: {
                            //                            self.game.addPlayer(player: Player(name: self.username, shortName: self.username, photoURL: "steph", color: .orange, colorStart: .orangeStart, colorEnd: .orangeEnd))
                            //                            self.stage = .collapsed
                        }) {
                            Image(systemName: "checkmark")
                            .font(.system(size: 30, weight: .light, design: .default))
                            .foregroundColor(Color.white)
                            .padding()
                            .contentShape(Circle())
                            //                        .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
                            .padding()
                        }
                        
                        
                      
                    }
                    
                }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 135)
        .clipShape(Rectangle()).cornerRadius(14)
        .opacity(1)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct AddPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayerView(game: .constant(Game()))
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented : Bool
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImageFromPicker = info[.originalImage] as? UIImage {
                self.parent.selectedImage = selectedImageFromPicker
            }
            self.parent.isPresented = false
        }
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        
    }
}

struct DummyView : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<DummyView>) -> UIButton {
        let button = UIButton()
        button.setTitle("DUMMY", for: .normal)
        button.backgroundColor = .red
        return button
    }
    
    func  updateUIView(_ uiView: DummyView.UIViewType, context: UIViewRepresentableContext<DummyView>) {
        
    }
}
