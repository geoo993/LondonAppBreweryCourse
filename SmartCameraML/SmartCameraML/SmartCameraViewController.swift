//
//  ViewController.swift
//  SmartCameraML
//
//  Created by GEORGE QUENTIN on 18/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

// https://www.youtube.com/watch?v=p6GA8ODlnX0
// https://www.raywenderlich.com/164213/coreml-and-vision-machine-learning-in-ios-11-tutorial
// http://machinethink.net/blog/ios-11-machine-learning-for-everyone/
// https://github.com/hollance/Inception-CoreML
// https://developer.apple.com/machine-learning/

import UIKit
import AVKit
import Vision
import AppCore

public class SmartCameraViewController: UIViewController {

    let dispatchQueueThread = "videoQueue"
    let model = Resnet50()
    
    @IBOutlet weak var backgroundView : UIView!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var confidenceLabel : UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // run camera session
        let captureSession = AVCaptureSession()
        //captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video), 
              let input = try? AVCaptureDeviceInput(device: captureDevice) else { 
            print(" Could not capture device")
            return 
        }
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        backgroundView.layer.addSublayer(previewLayer)
        
        // analysing the image and passing to CoreML
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: dispatchQueueThread))
        captureSession.addOutput(dataOutput)
        
    }

}

extension SmartCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        guard let coreMLModel : VNCoreMLModel = try? VNCoreMLModel(for: model.model) , 
            let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
         else { return }
        let request = VNCoreMLRequest(model: coreMLModel) { (finishedRequest, error) in
            // check the error 
            if let results = finishedRequest.results as? [VNClassificationObservation],
                let firstResult = results.first {
                
                DispatchQueue.main.async { [unowned self] () in
                    let connfidenceValue = CGFloat(firstResult.confidence).round(to: 3)
                    self.descriptionLabel.text = firstResult.identifier
                    self.confidenceLabel.text = "\(connfidenceValue)"
                }
            }
        }
        
        do {
            _ = try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        } catch {
            print("could not peform request to coreML request: \(error)")
        }
        
        
    }
}

