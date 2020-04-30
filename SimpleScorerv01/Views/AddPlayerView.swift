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
    
    @State private var stage = Stage.atNameEntry
    @State private var username: String = ""
    
    @State private var showImagePicker = false
    @State private var imagePicked = UIImage()
    @ObservedObject private var keyboard = KeyboardResponder()
    
    
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
                
               
                GeometryReader { geometry in
                    
                    VStack (alignment: .center) {
                        TextField("Enter name", text: self.$username, onCommit: {self.stage = .atPictureChoice})
                            .font(.system(size: 30))
                            .font(.system(.largeTitle, design: .rounded))
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.offWhite).opacity(0.8)
                            .cornerRadius(10.0)
                            .padding(.horizontal, self.frameHeight/2)
                            .keyboardType(.default)
                            .offset(x: 0, y: -self.keyboard.currentHeight)
                            .edgesIgnoringSafeArea(.bottom)
                            .animation(.easeOut(duration: 0.16))
                        
                        Text("\(geometry.frame(in: .global).origin.y + geometry.frame(in: .global).height)")
                        Text("\(geometry.frame(in: .named("Custom")).height)")
                    }
                }
                
                
                
                
            } else if stage == .atPictureChoice {
                
                LinearGradient(Color.orangeStart, Color.orangeEnd)
                
                HStack () {
                    Button(action: {
                        self.showImagePicker.toggle()
                    }) {
                        AvatarView(image: self.imagePicked)
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
                        self.game.addPlayer(player: Player(name: self.username, photoImage: self.imagePicked, colorStart: .orangeStart, colorEnd: .orangeEnd))
                        self.stage = .collapsed
                        self.username = ""
                        self.imagePicked = UIImage()
                    }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 30, weight: .light, design: .default))
                            .foregroundColor(Color.white)
                            .padding()
                            .contentShape(Circle())
                            //                        .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
                            .padding()
                    }
                    
                    
                    
                } // End of HStack
                
            }
            
            
        } // End of ZStack
        .frame(height: stage == .collapsed ? 70 : frameHeight)
        .frame(maxWidth: .infinity)
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


