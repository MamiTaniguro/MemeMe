//
//  MemesTableViewController.swift
//  MemeMe2.0
//
//  Created by mami taniguro on 2/12/19.
//  Copyright © 2019 mami taniguro. All rights reserved.
//

import Foundation
import UIKit

class MemesTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        cell.cellLabel.text = "\(meme.topText) ... \(meme.bottomText)"
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}

