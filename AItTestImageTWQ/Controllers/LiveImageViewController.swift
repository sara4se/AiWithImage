//
//  LiveImageViewController.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/15.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI
import Vision

 class LiveImageViewController: UIViewController {
     @StateObject var imageClassfier : ImageClassfier = ImageClassfier()
    var videoPreview: UIView! = {
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 450))
    }()
    
    var videoCapture: VideoCapture!
    
    let estimationModel = FCRN()
    
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(videoPreview)
        
        setupModel()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoCapture.stop()
    }
    
    func setupModel() {
        if let visionModel = try? VNCoreMLModel(for: estimationModel.model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError("Error: Setup Vision Model error")
        }
    }
    
    func setupCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        videoCapture.setup(sessionPreset: .medium) { (success) in
            if success {
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                self.videoCapture.start()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
}

extension LiveImageViewController: VideoCaptureDelegate {
   
    func videoCapture(_ capture: VideoCapture, didCaptureViewFrame pixelBuffer: CVPixelBuffer?) {
        if let pixelBuffer = pixelBuffer {
            imageClassfier.predict(sampleBuffer: pixelBuffer)
            predict(with: pixelBuffer)
//            print("i am pixelBuffer\(pixelBuffer.attachments)")
//            print("i am pixelBuffer\(pixelBuffer)")
            
        }
    }
}


extension LiveImageViewController {
    func predict(with pixelBuffer: CVPixelBuffer) {
        guard let request = request else {
            fatalError("Error: VNCoreMLRequest error")
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
       // print("i am handelr\(handler)")
    }
    
    
    
}
 

struct LiveImageViewControllerView: UIViewControllerRepresentable {
   // public typealias UIViewControllerType = LiveImageViewController
    typealias UIViewControllerType = LiveImageViewController
    
    func makeUIViewController(context: Context) -> LiveImageViewController {
        return LiveImageViewController()
    }
    func updateUIViewController(_ uiViewController: LiveImageViewController, context: Context) {
        
    }
    
   
}
