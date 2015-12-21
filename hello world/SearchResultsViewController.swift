//
//  ViewController.swift
//  hello world
//
//  Created by ئ‍ارسلان ئابلىكىم on 12/20/15.
//  Copyright © 2015 ئ‍ارسان ئابلىكىم. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,iTunesAPIProtocol {
    
    @IBOutlet weak var tablewiiu: UITableView!
    
    var data: NSMutableData = NSMutableData()
    var tableData: NSArray = NSArray()
    let api = iTunesAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
        api.searchItunesFor("Angry Birds");
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.tablewiiu!.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        let rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
        
        cell.textLabel!.text = (rowData["trackName"] as! String)
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString: NSString = rowData["artworkUrl60"] as! NSString
        let imgURL: NSURL = NSURL(string: urlString as String)!
        
        // Download an NSData representation of the image at the URL
        let imgData: NSData = NSData(contentsOfURL: imgURL)!
        cell.imageView?.image = UIImage(data: imgData)
        
        // Get the formatted price string for display in the subtitle
        let formattedPrice: NSString = rowData["formattedPrice"] as! NSString
        
        cell.detailTextLabel!.text = formattedPrice as String
        
        return cell
    }
}