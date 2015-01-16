//
//  ViewController.swift
//  HelloWorld
//
//  Created by Rommel Rico on 1/14/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit
import QuartzCore

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    var api: APIController?
    var albums = [Album]()
    @IBOutlet var appsTableView: UITableView?
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchItunesFor("Little Dragon")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let album = self.albums[indexPath.row]
        
        //Add a check to make sure this exists
        cell.textLabel?.text = album.title
        cell.imageView?.image = UIImage(named: "Blank52")
        
        //Get the formatted price string for display in the subtitle
        let formattedPrice = album.price
        
        //Jump in to the background thread to get the image for this item
        
        //Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString = album.thumbnailImageURL
        
        //Check our image cache for the existing key. This is just a dictionary of UIImages
        var image = self.imageCache[urlString]
        
        if(image==nil) {
            //If the image does not exist, we need to download it.
            var imgURL: NSURL = NSURL(string: urlString)!
            
            //Download an NSData representation of the image URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if error==nil {
                    image = UIImage(data: data)
                    
                    //Store the image in our cache
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView?.image = image
                }
            })
        }
        
        cell.detailTextLabel?.text = formattedPrice
        
        return cell
        
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
        var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
        var selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
}

