//
//  ContentView.swift
//  AItTestImageTWQ
//
//  Created by Sara Alhumidi on 09/11/1444 AH.
//

import SwiftUI

struct ContentView: View {
    @State private var showPicker : Bool = false
    @State private var selectedImage : UIImage? = .none
    @StateObject private var imageclassefier : ImageClassfier = .init()
    var body: some View {
        VStack {
            if let selectedImage = selectedImage{
                VStack{
                    Image(uiImage: selectedImage).resizable().scaledToFit()
                        //.frame(width: 100,height: 100)
                }
            }
            Button(
                 action: {
                    showPicker.toggle()
                },
            label: {
                Text("Click me")
            })
            ScrollView{
                ForEach(imageclassefier.ArrayOfPredactions){ predications in
                    HStack{
                        Text(predications.label)
                        Text(predications.confidece.description)

                    }
                }
            }
        }
        .sheet(isPresented: $showPicker
               ,onDismiss: {
            guard let selectedImage = selectedImage else {
                return
            }
            imageclassefier.predict(image: selectedImage)
        },
        content: {
            imagePicker(selectedImage: $selectedImage)
          
        
        })
        .padding()
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
