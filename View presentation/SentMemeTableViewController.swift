//
//  SentMemeTableViewController.swift
//  View presentation
//
//  Created by aia on 11/10/2023.
//

import Foundation
import UIKit

class SentMemeTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet var tableViewMeme: UITableView!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableViewMeme?.reloadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.tableViewMeme?.reloadData()
//    }

    // MARK: For Data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        if let topText = meme.topText, let bottomText = meme.bottomText {
            cell.textLabel?.text = topText + " - " + bottomText
        }
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
