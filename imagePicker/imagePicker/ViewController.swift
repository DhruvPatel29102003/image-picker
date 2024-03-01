//
//  ViewController.swift
//  imagePicker
//
//  Created by Droadmin on 6/23/23.
//

import UIKit

import Photos

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var imagePicker: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ImageBtn(_ sender: Any) {
        
        let alertBox = UIAlertController(title: "Please Select Image", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camara", style: .default){(_)in
            self.setImage(selectedSource: .camera)
        }
        let galaryAction = UIAlertAction(title: "Gallery", style: .default){(_)in
            self.checkGalleryPermission() /*{
                                           self.setImage(selectedSource: .photoLibrary)
                                           }*/
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        
        alertBox.addAction(cameraAction)
        alertBox.addAction(galaryAction)
        alertBox.addAction(cancelAction)
        self.present(alertBox, animated: true)
    }
    func setImage(selectedSource:UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource)else{
            print("not found")
            return
        }
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = selectedSource
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        }
       
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectImage = info[.originalImage] as? UIImage{
            imagePicker.image = selectImage
        }else{
            print("Image not found")
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func checkGalleryPermission() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .denied:
            print("Gallery permission denied")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (authStatus)-> Void in
                if authStatus == .authorized {
                    
                    //self.setImage(selectedSource: .photoLibrary)
                } else {
                    print("Gallery permission denied")
                }
            }
        case .restricted:
            print("Gallery permission restricted")
        case .authorized:
            print("Gallery permission  authorized")
            self.setImage(selectedSource: .photoLibrary)
        case .limited:
            break
       
        }
        
    }
    
}
