//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Ryan Newton on 2/2/15.
//  Copyright (c) 2015 ___rvkn___. All rights reserved.
//

import UIKit

class ViewController: UITableViewController  {
    
    var moviesArray: NSArray?
    
    @IBOutlet weak var errorView: ErrorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        if let moviesArray = moviesArray {
            self.tableView.insertSubview(self.refreshControl!, atIndex: moviesArray.count)
        } else {
            self.tableView.insertSubview(self.refreshControl!, atIndex: 0)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let successCallback = {
            (moviesArray: NSArray) -> Void in
                self.moviesArray = moviesArray
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.tableView.reloadData()
        }

        Movie.getTopMovies(successCallback, errorHandler)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = moviesArray {
            return array.count
        } else {
            return 0
        }
    }

    func errorHandler(error: NSError) -> Void {
        self.errorView.expandWithErrorMessage(error.localizedDescription)
    }

    func onRefresh() {
        println("Loading more movies")
        let successCallback = {
            (moviesArray: NSArray) -> Void in
            
            self.moviesArray = moviesArray
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
        
        Movie.getTopMovies(successCallback, errorCallback: self.errorHandler)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = moviesArray![indexPath.row] as Movie
        let cell = tableView.dequeueReusableCellWithIdentifier("topCell") as MovieTableViewCell
        cell.movieTitleLabel.text = movie.title
        let thumbnailUrl = movie.thumbnailPosterUrl
        
        
        
        
        let imageLoadSuccess = {
            (request: NSURLRequest!, reponse: NSHTTPURLResponse!, image: UIImage!) -> Void in
            movie.thumbnailImage = image
            cell.movieTitleThumb.image = image
            UIView.animateWithDuration(2, animations: {
                cell.movieTitleThumb.alpha = 1
            })
        }
        
        let imageLoadFail = {
            (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
            self.errorView.expandWithErrorMessage(error.localizedDescription)
        }

        let thumbnailUrlRequest = NSURLRequest(URL: thumbnailUrl!)
        cell.movieTitleThumb.setImageWithURLRequest(thumbnailUrlRequest, placeholderImage: nil, success: imageLoadSuccess, failure: imageLoadFail)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MovieDetailsViewController") as MovieDetailsViewController
        let movie = moviesArray![indexPath.row] as Movie
        detailsViewController.movie = movie
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }   
}



