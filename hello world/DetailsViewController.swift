//
//  DetailsViewController.swift
//  hello world
//
//  Created by ئ‍ارسلان ئابلىكىم on 1/31/16.
//  Copyright © 2016 ئ‍ارسان ئابلىكىم. All rights reserved.
//

import UIKit
import AVFoundation

class DetailsViewController: UIViewController,iTunesAPIProtocol,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var albumCover: UIImageView!
    var album: Album?
    var tracks = [Track]()
    lazy var api : iTunesAPI = iTunesAPI(delegate: self)
    var mediaPlayer: AVPlayer = AVPlayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        albumLabel.text = self.album?.title
        albumLabel.lineBreakMode = .ByWordWrapping
        albumLabel.numberOfLines = 0
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        self.tracksTableView.delegate = self
        self.tracksTableView.dataSource = self
        if self.album != nil {
            api.lookupAlbum(self.album!.collectionId)
        }
    }
    // MARK: APIControllerProtocol
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(results)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TrackCell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
        let track = self.tracks[indexPath.row]
        cell.titleLabel?.text = track.title
        cell.playIcon?.text = "▶︎"
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = tracks[indexPath.row]
        mediaPlayer.pause()
        mediaPlayer.replaceCurrentItemWithPlayerItem(AVPlayerItem(URL: NSURL(string: track.previewUrl)!))
        mediaPlayer.play()
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = "◼︎"
        }
    }
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 44
    }
}