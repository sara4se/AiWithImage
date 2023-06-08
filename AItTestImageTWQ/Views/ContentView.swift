//
//  ContentView.swift
//  AItTestImageTWQ
//
//  Created by Sara Alhumidi on 09/11/1444 AH.
//

import SwiftUI
extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct ContentView: View {
    @State private var isAnimating = false
    @State private var showPicker : Bool = false
    @State private var selectedImage : UIImage? = .none
    @StateObject private var imageclassefier : ImageClassfier = .init()
    @State private var gradientColors: [Color] = [.init(hex: "ab99fd"), .init(hex: "e59fff"), .init(hex: "87f1fb")]

    var body: some View {
      
        NavigationView {
            ZStack {
                Color.gray // Set the background color to blue
                 VStack(spacing: 0) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: .infinity, height: 600)
                            .edgesIgnoringSafeArea(.top) // Extend image to the top edges
                     
//                        Color.blue
//                            .opacity(0.5)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .edgesIgnoringSafeArea(.top)
//
                        List(imageclassefier.ArrayOfPredactions) { predications in
                            HStack {
                                Text(predications.label) .foregroundColor(.blue) // Set text color to white
                                Text(predications.confidece.description) .foregroundColor(.blue) // Set text color to white
                            }
                        }
                        .listStyle(.plain)
                        .background(Color.blue) // Set list background to blue
                        .cornerRadius(10) // Rounded corners for top corners
                        .shadow(radius: 4)
                        
                        .frame(width: 500)
                       
                    } else {
                        Button(action: {
                            showPicker.toggle()
                        }) {
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                Text("+ Click to add a photo")
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    }
                }
                .ignoresSafeArea(.all)
                .sheet(isPresented: $showPicker, onDismiss: {
                    guard let selectedImage = selectedImage else {
                        return
                    }
                    imageclassefier.predict(image: selectedImage)
                }) {
                    imagePicker(selectedImage: $selectedImage)
                }
            }
            .navigationBarItems(
                trailing: Button(action: {
                    showPicker.toggle()
                }) {
                    Text("Choose Image")
                        .foregroundColor(.white)
                }
            )
            .navigationBarTitle(
                Text("Sign Language Detector")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.white), // Set navigation bar title color to white
                displayMode: .inline)
        }

}
    
    func neonGradient() -> LinearGradient {
        let colors = [
            Color(hex: "#AB99FD"),
            Color(hex: "#87F1FB"),
            Color(hex: "#DBE2EB")
        ]
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
    }
    func updateGradientColors() {
        gradientColors.shuffle()
    }
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
