//
//  ImagePicker.swift
//  AItTestImageTWQ
//
//  Created by Sara Alhumidi on 09/11/1444 AH.
//

import Foundation
import SwiftUI
import UIKit
import PhotosUI

struct imagePicker: UIViewControllerRepresentable {
     
    @Binding var selectedImage : UIImage?
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    func makeUIViewController(context: Context) -> PHPickerViewController  {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    class Coordinator : PHPickerViewControllerDelegate{
        let parent : imagePicker
        init(_ parent: imagePicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let item = results.first?.itemProvider else{
                return
            }
            guard item.canLoadObject(ofClass: UIImage.self) else{
                return
            }
            item.loadObject(ofClass: UIImage.self , completionHandler: { originalImage, error in
                if let error = error {
                    print(error.localizedDescription)
                }
           
            guard let uiImage = originalImage as? UIImage else {
                return
            }
            self.parent.selectedImage = uiImage
            })
            picker.dismiss(animated: true)
           
        }
        
    }
}
