//
//  UIImagePickerViewController.swift
//  Photo Phabulous
//
//  Created by Alex Richards on 2/21/18.
//  Copyright © 2018 Alex Richards. All rights reserved.
//

import UIKit

class UIImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let NetworkingManager = SharedNetworking.shared
    var pictureArray: Pictures?
    var chosenPhoto: Pic?
    let picker = UIImagePickerController()
    var myImageView: UIImageView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        let alert = UIAlertController(title: "Add A Picture", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Take a Picture", comment: "Default action"), style: .`default`, handler: { _ in self.camera()}))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: "Default action"), style: .`default`, handler: { _ in self.photoFromLibrary()}))
        self.present(alert, animated: true, completion: nil)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        NetworkingManager.uploadPicture(user: "amrichards33", image: image)

        dismiss(animated:true, completion: {if let navController = self.navigationController
            {
                navController.popViewController(animated: true)
            }})
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("did cancel picker")
        dismiss(animated:true, completion: {if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
            }})
    }
    
    func photoFromLibrary() {
            picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
         present(picker, animated: true, completion: nil)
    }
        
    
    func camera()
    {
        picker.sourceType = UIImagePickerControllerSourceType.camera
        present(picker, animated: true, completion: nil)
    }


}
