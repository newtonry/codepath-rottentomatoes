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
        
        let imageLoadSuccess = {
            (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.backgroundPosterImageView.image = image
            MBProgressHUD.hideHUDForView(self.backgroundPosterImageView, animated: true)

        }
        
        let thumbnailRequest = NSURLRequest(URL: movie.posterUrl!)
        backgroundPosterImageView.setImageWithURLRequest(thumbnailRequest, placeholderImage: nil, success: imageLoadSuccess, failure: nil)
    }
    
    @IBAction func moveScreenTextUp(sender: AnyObject) {
        // Moves the text box up
        let newFrame = CGRectMake(0, 155, synopsisView.frame.width, synopsisView.frame.height)

        UIView.animateWithDuration(0.5, animations: {
            self.synopsisView.frame = newFrame
        })
    }
}
