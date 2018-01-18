//
//  ViewController.swift
//  SceneDetector
//
//  Created by GEORGE QUENTIN on 18/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
// https://www.raywenderlich.com/164213/coreml-and-vision-machine-learning-in-ios-11-tutorial

import UIKit
import CoreML
import Vision

public class SceneDetectorViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scene: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    // MARK: - Properties
    let vowels: [Character] = ["a", "e", "i", "o", "u"]
    
    // MARK: - CoreML model
    let coreModel = Resnet50()
    
    // MARK: - View Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "train_night") else {
            fatalError("no starting image")
        }
        
        scene.image = image

        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        
        detectScene(image: ciImage)
        
    }
}

// MARK: - IBActions
extension SceneDetectorViewController: UINavigationControllerDelegate {
    
    @IBAction func pickImage(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        present(pickerController, animated: true)
    }
    
    
}

// MARK: - Methods
extension SceneDetectorViewController {
    
    func detectScene(image: CIImage) {
        answerLabel.text = "detecting scene..."
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: coreModel.model) else {
            fatalError("can't load Places ML model")
        }
        
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let this = self else { return }
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first, 
                let firstIdentifier = topResult.identifier.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            // Update UI on main queue
            let article = this.vowels.contains(firstIdentifier) ? "an" : "a"
            
            DispatchQueue.main.async { [weak self] () in
                self?.answerLabel.text = "\(Int(topResult.confidence * 100))% it's \(article) \(topResult.identifier)"
            }
        }
        
        // Run the Core ML GoogLeNetPlaces classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SceneDetectorViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("couldn't load image from Photos")
        }
        
        scene.image = image
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        
        detectScene(image: ciImage)
    }
}

