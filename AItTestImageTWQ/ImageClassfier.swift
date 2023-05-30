//
//  ImageClassfier.swift
//  AItTestImageTWQ
//
//  Created by Sara Alhumidi on 09/11/1444 AH.
//

import Foundation
import Vision
import UIKit

struct Prediaction : Identifiable{
    let id = UUID()
    let label : String
    let confidece : Float
}

class ImageClassfier : ObservableObject{
    private var model : Optional<VNCoreMLModel> = .none
    @Published var ArrayOfPredactions : Array<Prediaction> = .init()
    init() {
        guard let _model = try? Resnet50(configuration: MLModelConfiguration()) else{
            return
        }
        guard let coreMlModel = try? VNCoreMLModel(for: _model.model) else{
            return
        }
        self.model = coreMlModel
    }
    func predict(image : UIImage){
        ArrayOfPredactions = []
        guard let image = image.cgImage else {
            return
        }
        guard let model = model else {
            return
        }
        let requset = VNCoreMLRequest(model: model) { requests, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                return
            }
            guard let reqobserve = requests.results as? [VNClassificationObservation] else{
                return
            }
            for obser in reqobserve[...2] { // [0..<3]
               let predact = Prediaction(
                label: obser.identifier,
                confidece: obser.confidence * 100)
               self.ArrayOfPredactions.append(predact)
            }
        }
        let requsestHandelr = VNImageRequestHandler(cgImage: image)
        try? requsestHandelr.perform([requset])
    }
}
