//
//  SentMemeTableViewController.swift
//  View presentation
//
//  Created by aia on 11/10/2023.
//

import Foundation
import UIKit

class SentMemeTableViewController : UITableViewController, UIViewControllerTransitioningDelegate {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var tableViewA: UITableView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      self.tableView.rowHeight = 110
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      NotificationCenter.default.addObserver(self, selector: #selector(refreshTable),
                                             name: NSNotification.Name(rawValue: "refreshMemeData"), object: nil)
    }

    // MARK: Helper function to refresh data in table
    @objc func refreshTable() {
      self.tableViewA.reloadData()
    }
    
    // MARK: For Data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        if let topText = meme.topText, let bottomText = meme.bottomText {
            cell.textLabel?.text = topText + " - " + bottomText
        }
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
