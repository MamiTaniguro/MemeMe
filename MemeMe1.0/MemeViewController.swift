//
//  MemeViewController.swift
//  MemeMe2.0
//
//  Created by mami taniguro on 2/12/19.
//  Copyright © 2019 mami taniguro. All rights reserved.
//

import Foundation
import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memedImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextAttribute(bottomText, str : " BOTTOM ")
        setTextAttribute(topText, str: " TOP ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Mark: Keyboard
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        if (sender == cameraButton) {
            presentPickerController(sourceType: .camera)
        }
        else {
            presentPickerController(sourceType: .photoLibrary)
        }
    }
    
    func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func save() {
        //Create the meme
        let meme = Meme (topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
   
    func generateMemedImage() -> UIImage {
        toolBarVisible(false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBarVisible(true)
        
        return memedImage
    }
    
    @IBAction func shareButton(_ sender: AnyObject) {
        let memeToShare = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.safelySaveMeme(memeToShare)
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func safelySaveMeme(_ memedImage: UIImage) {
        if imagePickerView.image != nil && topText.text != nil && bottomText.text != nil
        {
            let top = self.topText.text!
            let bottom = self.bottomText.text!
            let image = self.imagePickerView.image!
            
            let meme = Meme (topText: top, bottomText: bottom, originalImage: image, memedImage: memedImage)
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        }
        
    }
    
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    func setTextAttribute(_ textField : UITextField, str : String) {
        textField.text = str
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.autocapitalizationType = .allCharacters
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == topText && topText.text == " TOP ") {
            topText.text = ""
        } else if (textField == bottomText && bottomText.text == " BOTTOM ") {
            bottomText.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        topText.isHidden = true
        bottomText.isHidden = true
        imagePickerView.isHidden = true
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        dismiss(animated: true, completion: nil)
    }
    
    func toolBarVisible(_ visible: Bool) {
        if !visible {
            navBar.isHidden = true
            toolBar.isHidden = true
        } else {
            navBar.isHidden = false
            toolBar.isHidden = false
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
