//
//  VideoClassfier.swift
//  AItTestImageTWQ
//
//  Created by Sara Alhumidi on 19/11/1444 AH.
//

import Foundation
import Vision
import UIKit

class ImageClassfierVid : ObservableObject{
    private var model : Optional<VNCoreMLModel> = .none
    @Published var ArrayOfPredactions : Array<Prediaction> = .init()
    init() {
        guard let _model = try? FCRN(configuration: MLModelConfiguration()) else{
            return
        }
        guard let coreMlModel = try? VNCoreMLModel(for: _model.model) else{
            return
        }
        self.model = coreMlModel
    }
    func predict(sampleBuffer : CVImageBuffer){
        ArrayOfPredactions = []
//        guard let model = model else {
//            return
//        }
        guard let model = model else {
            return
        }
        let requset = VNCoreMLRequest(model: model) { requests, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                return
            }
            guard let reqobserve = requests.results as? [VNRecognizedObjectObservation] else{
                return
            }
            for obser in reqobserve { // [0..<3]
                guard let label = obser.labels.first else {
                    return
                }
                
                let predact = Prediaction(
                    label: label.identifier,
                    confidece: obser.confidence * 100)
//                obser.labels.first.customMirror.
                
                self.ArrayOfPredactions.append(predact)
                print("identifier \(obser.labels.first?.identifier)")
                print("identifier \(obser.labels.first?.identifier)")
                print("confidence\(obser.labels.first?.confidence)")
                //                print(obser.boundingBox)
            }
        }
        
        let requsestHandelr = VNImageRequestHandler(cvPixelBuffer: sampleBuffer)
        try? requsestHandelr.perform([requset])
    
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
