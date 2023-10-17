//
//  MemeDetailViewController.swift
//  View presentation
//
//  Created by aia on 12/10/2023.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    var meme: Meme?
    
    @IBOutlet weak var memeImageView: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        if let meme = meme {
            memeImageView.image = meme.memedImage
        }
    }
    
    func setupLayout(){
        // Setup background color
        view.backgroundColor = .white

        // Setup navigation bar
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem]
        rightButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
    }
    
    @objc func shareButtonAction(){
        if memeImageView.image != nil {
            let controller = UIActivityViewController(activityItems: [memeImageView.image!], applicationActivities: nil)
            controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                
            }
            present(controller,animated: true, completion: nil)
        }
    }
    
   
}
