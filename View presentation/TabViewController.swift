//
//  TabViewController.swift
//  View presentation
//
//  Created by aia on 16/10/2023.
//

import Foundation
import UIKit

class TabViewController : UITabBarController {
    override func viewDidLoad() {
        customIcon()
    }
    
    func customIcon(){
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(systemName: "plus"), for: .normal)
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem]
        self.navigationItem.title = "Sent Meme"
        rightButton.addTarget(self, action: #selector(addMemeButtonAction), for: .touchUpInside)
    }
    
    @objc func addMemeButtonAction(){
        let editorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editorVC.modalPresentationStyle = .pageSheet
        self.present(editorVC, animated: true)
    }
}
