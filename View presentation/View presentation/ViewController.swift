//
//  ViewController.swift
//  View presentation
//
//  Created by aia on 29/09/2023.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memedImage : UIImage!
    
    override func viewDidLoad() {
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        #if targetEnvironment(simulator)
        cameraButton.isEnabled = false
        #else
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        #endif
        
        setTextFields(textInput: topTextField, defaultText: "TOP")
        setTextFields(textInput: bottomTextField, defaultText: "BOTTOM")
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unSubscribeToKeyboardNotifications()
    }
    
    // MARK: Hidden keyboard when touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Choose camera or library
    func pickImage(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func showCamera(_ sender: Any) {
        pickImage(source: .camera)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        pickImage(source: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func shareAnImage(_ sender: Any) {
        let sharedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed && error == nil {
                self.saveImage()
            }
        }
        present(controller,animated: true, completion: nil)
    }
    
    @IBAction func cancelImage(_ sender: Any) {
        cancelImage() 
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: When a user taps inside a textfield, the default text should clear.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    
    // MARK: Hide keyboard when return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // MARK:  Handle show keyboard for bottom textfiel
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:   UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unSubscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Get keyboard height + Notify keyboard when editing bottom textfield
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let info = notification.userInfo
        let size = info![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return size.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0.0 {
            view.frame.origin.y -= getKeyboardHeight(notification: notification as NSNotification)
        }
    }
     
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    
    func saveImage() -> Meme {
        return Meme(topText: topTextField.text!,
                 bottomText: bottomTextField.text!,
                 memedImage: generateMemedImage())
    }
    
    // MARK: Style textfield
    func setTextFields(textInput:  UITextField!, defaultText: String) {
        let textAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth : -3.0 ] as [NSAttributedString.Key : Any]
        textInput.text = defaultText
        textInput.defaultTextAttributes = textAttributes
        textInput.delegate = self
        textInput.textAlignment = .center
        textInput.autocapitalizationType = .allCharacters
    }
    
    // MARK: Struct MEME
    struct Meme {
           let topText:String
           let bottomText:String
           let memedImage:UIImage
       }

    // MARK: generate meme + save
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        hiddenToolBar(isHidden: false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        hiddenToolBar(isHidden: true)
        
        return memedImage
    }
    
    // MARK: Hidden toolbar + navbar
    func hiddenToolBar(isHidden: Bool){
        if isHidden {
            navBar.isHidden = isHidden
            toolBar.isHidden = isHidden
        } else {
            navBar.isHidden = isHidden
            toolBar.isHidden = isHidden
        }
    }
    
    func cancelImage(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil 
    }
}
