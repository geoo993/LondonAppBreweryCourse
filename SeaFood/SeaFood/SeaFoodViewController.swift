//
//  SeaFoodViewController.swift
//  SeaFood
//
//  Created by GEORGE QUENTIN on 20/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
// https://www.raywenderlich.com/87-ibm-watson-services-for-core-ml-tutorial
// https://www.ibm.com/watson/services/visual-recognition/

import UIKit
import VisualRecognitionV3
import AppCore
import Chameleon
import SVProgressHUD
import Social

public enum MediaType { case photoLibrary, camera, photosAlbum }

public class SeaFoodViewController: UIViewController {

    let apiKey = "dd3c4e8f5225470ec4a358a024b845c8f2a86cf1"
    let version = "2018-01-20" // todays date
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var photosButton : UIBarButtonItem!
    @IBAction func photosButtonTapped (_ sender: UIBarButtonItem) {
        presentImagePicker(of: .photosAlbum)
    }
    
    @IBOutlet weak var cameraButton : UIBarButtonItem!
    @IBAction func cameraButtonTapped (_ sender: UIBarButtonItem) {
        presentImagePicker(of: .camera)
    }
    
    @IBOutlet weak var shareButton : UIButton!
    @IBAction func shareButtonTapped (_ sender: UIButton) {
        shareToTwitter()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imagePicker.delegate = self
        
        descriptionLabel.isHidden = false
        shareButton.isHidden = true
        shareButton.backgroundColor = UIColor(hex: "c1abea")
        updateNavBar(with:"", hexColor: "c1abea")
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
            
            if (text.isEmpty) {
                return 
            }
            
            //Navigation Bar text
            let attributedString = NSAttributedString(string: text, 
                                                      attributes: navController.navigationBar.titleTextAttributes) 
                        
            let textColor : UIColor = .yellow
            let textContrastColor = ContrastColorOf(textColor, returnFlat: true)
            
            navController
                .navigationBar
                .addBorderOnTitle(with: textColor, 
                                  font: attributedString.font,
                                  borderWidth: 6.0, 
                                  borderColor: textContrastColor)
            navController.navigationBar.isTranslucent = false
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
    
    // MARK - share to Twitter, but not working
    func shareToTwitter () {
        let slServiceTwitterType = "Twitter"
        if SLComposeViewController.isAvailable(forServiceType:slServiceTwitterType ) {
            if let vc = SLComposeViewController(forServiceType: slServiceTwitterType),
                let title = navigationItem.title {
                vc.setInitialText("My food is \(title)")
                vc.add(#imageLiteral(resourceName: "hotdogBackground"))
                present(vc, animated: true, completion: nil)
            }
        } else {
            print("No twitter account is associated with iphone")
            navigationItem.title = "Please log in to Twitter"
        }
    }

}

// MARK - Image picker delegate
extension SeaFoodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, 
                                      didFinishPickingMediaWithInfo info: [String : Any]) {
        
        SVProgressHUD.show()
        navigationItem.title = ""
        cameraButton.isEnabled = false
        photosButton.isEnabled = false
        //descriptionLabel.isHidden = true
        //shareButton.isHidden = true
        
        if let usePickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageData = usePickedImage.lowestQualityJPEGNSData,
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            imageView.image = usePickedImage
            
            let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
            try? imageData.write(to: fileURL)
            print(fileURL)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            visualRecognition.classify(imagesFile: fileURL, classifierIDs: ["food"]) { (classifiedImage, error) in
                print(error)
                if (error != nil) {
                    print("classifying Error: \(String(describing: error))")
                    return
                }
                guard
                    let result = classifiedImage?.result,
                    let image = result.images.first,
                    let classes = image.classifiers.first?.classes,
                    let highestClassificationResult = classes
                        .filter({ $0.typeHierarchy != nil && $0.score > 0.5 })
                        .sorted(by: { ($1.score > $0.score) } )
                        .last
                    else {
                        print("Could not get classifier result")
                        return
                }
                print(highestClassificationResult)
                let hotdogResult = SeaFood.isSeaFood(classiffierWithTypeHierachy: highestClassificationResult)
                print(hotdogResult, highestClassificationResult.className)
                let titleText = hotdogResult
                    ? highestClassificationResult.className : "Not Sea Food!"
                let colorHex = hotdogResult ? "00ff00" : "ff0000"
                DispatchQueue.main.async { [unowned self] () in
                    self.navigationItem.title = titleText
                    self.photosButton.isEnabled = true
                    self.cameraButton.isEnabled = true
                    //self.shareButton.isHidden = false
                    self.updateNavBar(with: titleText, hexColor: colorHex)
                }
                
                SVProgressHUD.dismiss()
            }
        }
        dismissImagePicker()
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissImagePicker()
    }
}
