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
    
    var imagePicker1 = UIImagePickerController()
    var imagePicker2 = UIImagePickerController()
    
    var image1BeingPicked = false
    var image2BeingPicked = false
    
    var image1Picked = false
    var image2Picked = false
    
    var person1: Person?
    var person2: Person?
    var match: Bool = false
    var confidenceLevel: NSNumber!
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker1.delegate = self
        imagePicker2.delegate = self
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(loadPicker1(gesture:)))
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(loadPicker2(gesture:)))
        
        tap1.numberOfTapsRequired = 1
        tap2.numberOfTapsRequired = 1
        
        person1Image.addGestureRecognizer(tap1)
        
        
        person2Image.addGestureRecognizer(tap2)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if image1BeingPicked == true {
                person1Image.image = pickedImage
                image1Picked = true
                
                if let img = person1Image.image, let imgData = UIImageJPEGRepresentation(img, 0.8) {
                    FaceService.instance.client?.detect(with: imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces, err) in
                        if err == nil {
                            for face in faces! {
                                self.person1?.faceid = face.faceId
                                print("\(self.person1?.faceid)")
                                break
                            }
                        } else {
                            print(err.debugDescription)
                        }
                    })
                }
                
                
            } else if  image2BeingPicked == true {
                person2Image.image = pickedImage
                image2Picked = true
                
                if let img = person2Image.image, let imgData = UIImageJPEGRepresentation(img, 0.8) {
                    FaceService.instance.client?.detect(with: imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces, err) in
                        if err == nil {
                            for face in faces! {
                                self.person2?.faceid = face.faceId
                                print("\(self.person2?.faceid)")
                            }
                        } else {
                            print(err.debugDescription)
                        }
                            
                    })
                }
            }
            
        }
        image1BeingPicked = false
        image2BeingPicked = false
        
        dismiss(animated: true, completion: nil)
    }
    
    func loadPicker1(gesture: UITapGestureRecognizer) {
        imagePicker1.allowsEditing = false
        imagePicker1.sourceType = .photoLibrary
        image1BeingPicked = true
        
        present(imagePicker1, animated: true, completion: nil)
        
        
        
    }
    
    func loadPicker2(gesture: UITapGestureRecognizer) {
        imagePicker2.allowsEditing = false
        imagePicker2.sourceType = .photoLibrary
        image2BeingPicked = true
        
        present(imagePicker2, animated: true, completion: nil)
    }
    
    func ShowErrorAlert() {
        let alert = UIAlertController(title: "Select Images", message: "Please select two images for checking", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func ShowResults(Match: Bool, Confidence: NSNumber ) {
        let alert = UIAlertController(title: "Results", message: "Identical: \(Match) /n Confidence: \(Confidence) ", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func CheckForMatch(sender: Any) {
        if image1Picked && image2Picked {
            if person1?.faceid != nil && person2?.faceid != nil {
                FaceService.instance.client?.verify(withFirstFaceId: self.person1!.faceid, faceId2: self.person2!.faceid, completionBlock: { (result, err) in
                    if err == nil {
                        print(result?.confidence)
                        print(result?.isIdentical)
                        print(result.debugDescription)
                        
                        
                        self.ShowResults(Match: (result?.isIdentical)!, Confidence: (result?.confidence)!)
                        
                        
                    } else {
                        print(err.debugDescription)
                    }
                })
            }
            
                
            
            
        } else {
            ShowErrorAlert()
        }
        image1Picked = false
        image2Picked = false
  
    }



    
}

