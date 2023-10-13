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
    
        if let meme = meme {
            memeImageView.image = meme.memedImage
        }
    }
}
