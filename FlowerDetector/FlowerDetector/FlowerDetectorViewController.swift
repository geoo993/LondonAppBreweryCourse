//
//  FlowerDetectorViewController.swift
//  FlowerDetector
//
//  Created by GEORGE QUENTIN on 20/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
// https://pypi.python.org/pypi/coremltools/0.3.0
// https://pip.pypa.io/en/stable/installing/
// https://apple.github.io/coremltools/generated/coremltools.converters.caffe.convert.html#coremltools.converters.caffe.convert
// https://www.mediawiki.org/wiki/API:Main_page
// https://github.com/BVLC/caffe/wiki/Model-Zoo

/*
 let wikipediaURl = "https://en.wikipedia.org/w/api.php"
 
 let parameters : [String:String] = [
 "format" : "json",
 "action" : "query",
 "prop" : "extracts",
 "exintro" : "",
 "explaintext" : "",
 "titles" : flowerName,
 “indexpageids” : "",
 "redirects" : "1", 
 ]

 */

import UIKit
import AppCore
import Chameleon
import Vision
import CoreML
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage

public enum MediaType { case photoLibrary, camera, photosAlbum }

public class FlowerDetectorViewController: UIViewController {

    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    let mlModel = FlowerClassifier()
        
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var imageViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var flowerDescriptionLabel : UILabel!
    @IBOutlet weak var photosButton : UIBarButtonItem!
    @IBAction func photosButtonTapped (_ sender: UIBarButtonItem) {
        presentImagePicker(of: .photosAlbum)
    }
    
    @IBOutlet weak var cameraButton : UIBarButtonItem!
    @IBAction func cameraButtonTapped (_ sender: UIBarButtonItem) {
        presentImagePicker(of: .camera)
    }
        
    override public func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        if let bgColorHex = (self.view.backgroundColor?.toHexString) {
            updateNavBar(with: "", hexColor: bgColorHex)
        }
    }
    
    // MARK: - Setup Nav Bar
    func updateNavBar (with text: String, hexColor colorHex : String) {
        if let navController = navigationController {
            
            let navBarColor = UIColor(hex:  colorHex) 
            let constrastColor = ContrastColorOf(navBarColor, returnFlat: true)
            
            // Navigation Bar background
            navController.navigationBar.barTintColor = navBarColor
            
            // Navigation Bar items
            navController.navigationBar.tintColor = constrastColor
            
            navigationItem.title = text
            
            if (text.isEmpty) {
                return 
            }
            
            //Navigation Bar text
            navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: constrastColor]
        }
    }
    
    // MARK - present and dismiss imagePicker
    func presentImagePicker(of mediaType: MediaType) {
        switch mediaType {
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
            break
        case .photosAlbum:
            imagePicker.sourceType = .savedPhotosAlbum
            break
        case .camera:
            imagePicker.sourceType = .camera
            break
        }
        imagePicker.allowsEditing = false
        descriptionLabel.isHidden = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func dismissImagePicker() {
        imagePicker.dismiss(animated: true, completion: nil)
    }

    // MARK - Detect image with coreML
    func detect(image : CIImage) {
        guard let model = try? VNCoreMLModel(for: mlModel.model) else {
            fatalError("Could not load CoreML model")
        }
        
        let request = VNCoreMLRequest(model: model) { [unowned self] (request, error) in
            guard let results = request.results as? [VNClassificationObservation], 
                let firstResult = results.first else { return }
            
            let flowerResult = self.isFlower(firstResult)
            let colorHex = flowerResult ? "00ff00" : "ff0000"
            let flowerName = flowerResult ? firstResult.identifier : "Not Flower!"
            self.updateNavBar(with: flowerName.capitalized, hexColor: colorHex)
            self.getFlowerData(flowerName: flowerName, isFlower: flowerResult)
            SVProgressHUD.dismiss()
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    func isFlower(_ result: VNClassificationObservation) -> Bool {
        return CGFloat(result.confidence) > 0.5
    }
}

// MARK - Image picker delegate
extension FlowerDetectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, 
                                      didFinishPickingMediaWithInfo info: [String : Any]) {
        SVProgressHUD.show()
        if let convertedCIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = convertedCIImage
            
            guard let ciImage = CIImage(image: convertedCIImage) else {
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


extension FlowerDetectorViewController {
    
    //MARK: - Network request 
    /***************************************************************/
    
    //Write the getFlowerData method here:
    func getFlowerData(flowerName: String, isFlower: Bool) {
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flowerName,
            "indexpageids" : "",
            "redirects" : "1", 
            "pithumbsize" : "500"
            ]
        
        Alamofire.request(wikipediaURL, method: .get, parameters:parameters )
            .responseJSON { [unowned self] response in
            
            if response.result.isSuccess {
                print("Success, Got the wikipedia data")
                if let json = response.result.value {
                    let flowerJSON : JSON = JSON(json)
                    
                    let constraintMulitiplier : CGFloat = isFlower ? 0.5 : 1.0
                    self.updateFlowerData(json: flowerJSON)
                    self.imageViewHeightConstraint = self
                        .imageViewHeightConstraint
                        .setMultiplier(multiplier: constraintMulitiplier)
                    
                    print("JSON: \(flowerJSON)") 
                }
                
            } else {
                if let error = response.result.error {
                    print("Error", error)
                }
            }
        }
        
    }
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    //Write the updateFlowerData method here:
    func updateFlowerData(json : JSON) {
        if 
            let flowerPageId = json["query"]["pageids"][0].string,
            let flowerExtract = json["query"]["pages"][flowerPageId]["extract"].string,
            let flowerImageURL = json["query"]["pages"][flowerPageId]["thumbnail"]["source"].string {
           
            flowerDescriptionLabel.text = flowerExtract
            imageView.sd_setImage(with: URL(string: flowerImageURL), completed: nil) 
            
        } else {
            print("Flower data unavailable")
        }
    }
    
}
