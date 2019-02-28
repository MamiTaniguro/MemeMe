//
//  MemesDetailViewController.swift
//  MemeMe2.0
//
//  Created by mami taniguro on 2/12/19.
//  Copyright © 2019 mami taniguro. All rights reserved.
//

import Foundation
import UIKit

class MemesDetailViewController: UIViewController {
    
    var meme: Meme! = nil
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var editButton: UINavigationBar!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)  // added per instructor
        memeImageView.image = meme.memedImage
    }
    
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true     // status bar should be hidden
    }
    
}
