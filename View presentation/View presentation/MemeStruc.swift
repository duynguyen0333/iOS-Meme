////
////  MemeStruc.swift
////  View presentation
////
////  Created by aia on 09/10/2023.
////
//
//import UIKit
//import Foundation
//
//// MARK: Struct MEME
//struct Meme {
//       let topText:String
//       let bottomText:String
//       let memedImage:UIImage
//   }
//
//// MARK: generate meme + save
//func generateMemedImage() -> UIImage {
//    // TODO: Hide toolbar and navbar
//    hiddenToolBar(isHidden: false)
//    
//    UIGraphicsBeginImageContext(self.view.frame.size)
//    view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
//    memedImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    
//    // TODO: Show toolbar and navbar
//    hiddenToolBar(isHidden: true)
//    
//    return memedImage
//}
//
//// MARK: Hidden toolbar + navbar
//func hiddenToolBar(isHidden: Bool){
//    if isHidden {
//        navBar.isHidden = false
//        toolBar.isHidden = false
//    } else {
//        navBar.isHidden = true
//        toolBar.isHidden = true
//    }
//}
//
//func cancelImage(){
//    topTextField.text = "TOP"
//    bottomTextField.text = "BOTTOM"
//    imagePickerView.image = nil
//}
