//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Ryan Newton on 2/3/15.
//  Copyright (c) 2015 ___rvkn___. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movie: Movie!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    @IBOutlet weak var backgroundPosterImageView: UIImageView!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var synopsisView: UIView!
    
    override func viewDidLoad() {
        self.navigationItem.title = movie.title

        MBProgressHUD.showHUDAddedTo(backgroundPosterImageView, animated: true)

        self.synopsisTextView.text = movie.synopsis
        self.synopsisTextView.textColor = UIColor.whiteColor()
        self.synopsisTextView.font = UIFont(name: "Helvetica", size: 18)
        self.runtimeLabel.text = "\(movie.runtime!) mins"
        self.ratingLabel.text = "\(movie.score!)%"
        
        // This is my own temporary way of caching stuff. Doubt it's the correct way to do this.
        if let moviePoster = movie.posterImage as UIImage! {
            self.backgroundPosterImageView.image = moviePoster
        } else {
            let imageLoadSuccess = {
                (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                MBProgressHUD.hideHUDForView(self.backgroundPosterImageView, animated: true)
                self.backgroundPosterImageView.image = image
                self.movie.posterImage = image

    // No need to animate this anymore since we're loading from the thumbnail, which was already saved by the tableview
    //            UIView.animateWithDuration(1, animations: {
    //                self.backgroundPosterImageView.alpha = 1
    //            })
            }
            
            let thumbnail = movie.thumbnailImage?
            
            let posterRequest = NSURLRequest(URL: movie.posterUrl!)
            backgroundPosterImageView.setImageWithURLRequest(posterRequest, placeholderImage: thumbnail!, success: imageLoadSuccess, failure: nil)   
        }
    }
    
    @IBAction func moveScreenTextUp(sender: AnyObject) {
        // Moves the text box up
        let newFrame = CGRectMake(0, 156, synopsisView.frame.width, synopsisView.frame.height)

        UIView.animateWithDuration(0.6, animations: {
            self.synopsisView.frame = newFrame
        })
    }
}
