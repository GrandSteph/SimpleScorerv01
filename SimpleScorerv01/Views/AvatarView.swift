//
//  CircleImage.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct AvatarView: View {
    
    @Binding var user : Player
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
//    @State private var pickedImage: UIImage?
    
    @ViewBuilder
    var body: some View {
        
        ZStack {
            if user.photoImage?.imageAsset != nil {
                Image(uiImage: user.photoImage!).renderingMode(.original)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
            } else if user.name != "Name ?" {
                Text(user.name.uppercased().prefix(1))
                    .fontWeight(.regular)
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                Image(systemName: "camera")
                    .font(.system(size: 30, weight: .light, design: .default))
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Circle())
            }
        }
        .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
        .onTapGesture {
                self.showingImagePicker = true
        }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        self.user.photoImage = resizeImage(image: inputImage, targetSize: CGSize(width: 200, height: 200))
    }
}



struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            AvatarView(user: .constant(Player(name: "Stephane", photoImage: UIImage(named: "steph"), colorGradient: gradiants[0])))
                .background(Color.orangeEnd)
                .previewLayout(.fixed(width: 200, height: 300))
            
            AvatarView(user: .constant(Player(name: "Stephane", colorGradient: gradiants[0])))
            .background(Color.orangeEnd)
            .previewLayout(.fixed(width: 80*2/3, height: 80*2/3))
            
            AvatarView(user: .constant(Player()))
            .background(Color.orangeEnd)
            .previewLayout(.fixed(width: 200, height: 300))
        }
        
        
    }
}

// Temp while imagepicker is not great

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
   func makeCoordinator() -> Coordinator {
          Coordinator(self)
      }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
