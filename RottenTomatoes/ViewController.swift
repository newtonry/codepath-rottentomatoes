//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Ryan Newton on 2/2/15.
//  Copyright (c) 2015 ___rvkn___. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UISearchBarDelegate  {

    
    var moviesArray: NSArray?

    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var barItemDvd: UITabBarItem!
    @IBOutlet weak var barItemBoxOffice: UITabBarItem!
    var refreshControl: UIRefreshControl!

    let barItemDict: NSDictionary = [0: "DVD", 1: "Box Office"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        self.searchBar.showsCancelButton = true
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl!, atIndex: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        
        let successCallback = {
            (moviesArray: NSArray) -> Void in
                self.moviesArray = moviesArray
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.searchBar.hidden = false
                self.tableView.reloadData()
        }
        Movie.getTopMovies(successCallback, errorHandler)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    // Tab Bar functionality
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        let selectedTab: String = barItemDict[item.tag] as String

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let successCallback = {
            (moviesArray: NSArray) -> Void in
            self.moviesArray = moviesArray
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.searchBar.hidden = false
            self.tableView.reloadData()
        }
        
        if (selectedTab == "DVD") {
            Movie.getTopMovies(successCallback, errorCallback: nil)
        } else if (selectedTab == "Box Office") {
            Movie.getInTheater(successCallback, errorCallback: nil)
        }
    }
    
    // Search Bar functionality
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let searchString = searchBar.text
        
        let successCallback = {
            (moviesArray: NSArray) -> Void in
            self.moviesArray = moviesArray
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.searchBar.hidden = false
            self.tableView.reloadData()
        }
        
        self.view.endEditing(true)
        Movie.getBySearchString(searchString, successCallback: successCallback, errorCallback: nil)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    
    // Table View functionality
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = moviesArray![indexPath.row] as Movie
        let cell = tableView.dequeueReusableCellWithIdentifier("topCell") as MovieTableViewCell
        cell.movieTitleLabel.text = movie.title
        cell.movieRating.text = "\(movie.score!)"
        let thumbnailUrl = movie.thumbnailPosterUrl

        // Adjusts the color of the cells background upon selection
        let selectedColorView = UIView()
        selectedColorView.backgroundColor = UIColor.grayColor()
        cell.selectedBackgroundView = selectedColorView
        
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MovieDetailsViewController") as MovieDetailsViewController
        let movie = moviesArray![indexPath.row] as Movie
        detailsViewController.movie = movie
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }   
}



