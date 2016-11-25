//
//  ViewController.swift
//  FaceDetection2
//
//  Created by Lucheo Antonio Tombini Filho on 29/10/16.
//  Copyright © 2016 Lucheo Antonio Tombini Filho. All rights reserved.
//

import UIKit
import ProjectOxfordFace
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var person1Image: UIImageView!
    @IBOutlet weak var person2Image: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    
    var image1BeingPicked = false
    var image2BeingPicked = false
    
    var image1Picked = false
    var image2Picked = false
    
    var person1ID: String?
    var person2ID: String?
    
    
    
    var match: Bool = false
    var confidenceLevel: NSNumber!
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if image1BeingPicked {
                person1Image.image = pickedImage
                image1Picked = true
                
            } else if image2BeingPicked {
                person2Image.image = pickedImage
                image2Picked = true
                
            } else {
                print("Error picking image")
            }
            Detect()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func Detect() {
        if image1Picked {
            if let img = person1Image.image, let imgData = UIImageJPEGRepresentation(img, 0.8) {
                FaceService.instance.client?.detect(with: imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces, error) in
                    if error == nil {
                        var faceid: String?
                        for face in faces! {
                            faceid = face.faceId
                            break
                            
                            
                        }
                        self.person1ID = faceid
                    }
                })
            }
        } else if image2Picked {
            if let img = person2Image.image, let imgData = UIImageJPEGRepresentation(img, 0.8) {
                FaceService.instance.client?.detect(with: imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces, error) in
                    if error == nil {
                        var faceid: String?
                        for face in faces! {
                            faceid = face.faceId
                            break
                            
                        }
                        self.person2ID = faceid
                    }
                })
            }
            
        } else {
            print("Error: images not picked")
        }
    }

    
    func loadPicker() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        
        present(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
    func ShowErrorAlert() {
        let alert = UIAlertController(title: "Select Images", message: "Please select two images for checking", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func ShowResults(Match: Bool, Confidence: NSNumber ) {
        let alert = UIAlertController(title: "Results", message: "Identical: \(Match) -- Confidence: \(Confidence) ", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func CheckForMatch(sender: Any) {
        if image1Picked && image2Picked {
                FaceService.instance.client?.verify(withFirstFaceId: self.person1ID, faceId2: self.person2ID, completionBlock: { (result, err) in
                    if err == nil {
                        print(result?.confidence)
                        print(result?.isIdentical)
                        print(result.debugDescription)
                        
                        
                        self.ShowResults(Match: (result?.isIdentical)!, Confidence: (result?.confidence)!)
                        
                        
                    } else {
                        print(err.debugDescription)
                    }
                })
            
            
                
            
            
        } else {
            ShowErrorAlert()
        }
        image1Picked = false
        image2Picked = false
  
    }


    @IBAction func onImage1Selected(_ sender: UIButton) {
        if !image2BeingPicked {
            image1BeingPicked = true
        } else {
            image2BeingPicked = false
            image1BeingPicked = true
        }
        
        loadPicker()
    }

    @IBAction func onImage2Selected(_ sender: UIButton) {
        if !image1BeingPicked {
            image2BeingPicked = true
        } else {
            image1BeingPicked = false
            image2BeingPicked = true
        }

        loadPicker()
    }
    
}

