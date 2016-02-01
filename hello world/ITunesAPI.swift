//
//  ITunesAPI.swift
//  hello world
//
//  Created by ئ‍ارسلان ئابلىكىم on 12/21/15.
//  Copyright © 2015 ئ‍ارسان ئابلىكىم. All rights reserved.
//

import Foundation
protocol iTunesAPIProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class iTunesAPI{
    var delegate: iTunesAPIProtocol
    init(delegate: iTunesAPIProtocol) {
        self.delegate = delegate
    }
    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            print("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                print(error!.localizedDescription)
            }
            var jsonResult: NSDictionary
            do{ jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                if jsonResult.count>0 && jsonResult["results"]!.count>0 {
                    let results: NSArray = jsonResult["results"] as! NSArray
                    self.delegate.didReceiveAPIResults(results)
                }
            }
            catch {}
        })
        // The task is just an object with all these properties set
        // In order to actually make the web request, we need to "resume"
        task.resume()
    }
    func searchItunesFor(searchTerm: String) {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()){
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            get(urlPath)
        }
    }
    func lookupAlbum(collectionId: Int) {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
}