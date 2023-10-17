//
//  MemeEditorViewController.swift
//  View presentation
//
//  Created by aia on 29/09/2023.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate{
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
        setupLayout()
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
                self.saveImage(memedImage: sharedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller,animated: true, completion: nil)
    } 
    
    @IBAction func cancelImage(_ sender: Any) {
        cancelImage() 
        self.dismiss(animated: true, completion: nil) 
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
    
    
    func saveImage(memedImage: UIImage) {
        if imagePickerView.image != nil && topTextField.text != nil && bottomTextField.text != nil {
            let meme = Meme(topText: topTextField.text!,
                            bottomText: bottomTextField.text!,
                            originalImage: imagePickerView.image!,
                            memedImage: memedImage)
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        }
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
            navBar.isHidden = false 
            toolBar.isHidden = false
        } else {
            navBar.isHidden = true 
            toolBar.isHidden = true
        }
    }
    
    func cancelImage(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil 
    }
    
    func setupLayout(){
        // Setup background color
        view.backgroundColor = .white
    }
}
