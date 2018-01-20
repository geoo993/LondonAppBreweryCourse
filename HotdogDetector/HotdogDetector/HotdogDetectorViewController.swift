//
//  HotdogDetectorViewController.swift
//  HotdogDetector
//
//  Created by GEORGE QUENTIN on 19/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import Vision
import CoreML
import Chameleon

public enum MediaType { case photo, camera }

public class HotdogDetectorViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    let mlModel = Inceptionv3()

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBAction func photosButtonTapped (_ sender: UIBarButtonItem) {
        use(mediaType: .photo)
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped (_ sender: UIBarButtonItem) {
        use(mediaType: .camera)
        present(imagePicker, animated: true, completion: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        descriptionLabel.isHidden = false
        updateNavBar(withHexColor: "fdbe59")
    }
    
    // MARK: - Setup Nav Bar
    func updateNavBar (withHexColor colorHex : String) {
        if let navController = navigationController, 
            let navBarColor = UIColor(hexString:  colorHex) {
            let constrastColor = ContrastColorOf(navBarColor, returnFlat: true)
            
            // Navigation Bar background
            navController.navigationBar.barTintColor = navBarColor
            
            // Navigation Bar items
            navController.navigationBar.tintColor = constrastColor
            
            //Navigation Bar text
            navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: constrastColor]
        }
    }

    func use(mediaType: MediaType) {
        switch mediaType {
        case .photo:
            imagePicker.sourceType = .photoLibrary
            break
        case .camera:
            imagePicker.sourceType = .camera
            break
        }
        imagePicker.allowsEditing = false
        descriptionLabel.isHidden = true
    }
    
    func detect(image : CIImage) {
        guard let model = try? VNCoreMLModel(for: mlModel.model) else {
            fatalError("Could not load CoreML model")
        }
        
        let request = VNCoreMLRequest(model: model) { [unowned self] (request, error) in
            guard let results = request.results as? [VNClassificationObservation], 
                let firstResult = results.first else { return }
            
            let hotdogResult = self.isHotDog(firstResult)
            self.title = hotdogResult ? "Hotdog" : "Not Hotdog"
            
            let colorHex = hotdogResult ? "00ff00" : "ff0000"
            self.updateNavBar(withHexColor: colorHex)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    func isHotDog(_ result: VNClassificationObservation) -> Bool {
        return result.identifier.contains("hotdog") 
    }
    
    func dismissImagePicker() {
        imagePicker.dismiss(animated: true, completion: { [unowned self] () in
            self.descriptionLabel.isHidden = self.imageView.image != nil
        })
    }

}

// MARK - Image picker delegate
extension HotdogDetectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, 
                                      didFinishPickingMediaWithInfo info: [String : Any]) {
        if let usePickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = usePickedImage
            
            guard let ciImage = CIImage(image: usePickedImage) else {
                fatalError("Could not covert to ciimage")
            }
            
            detect(image: ciImage)
        }
        
        dismissImagePicker()
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissImagePicker()
    }
    
}
