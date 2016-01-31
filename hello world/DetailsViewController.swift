//
//  DetailsViewController.swift
//  hello world
//
//  Created by ئ‍ارسلان ئابلىكىم on 1/31/16.
//  Copyright © 2016 ئ‍ارسان ئابلىكىم. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    var album: Album?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
    }
}