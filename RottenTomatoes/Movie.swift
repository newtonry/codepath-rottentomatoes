//
//  Movie.swift
//  RottenTomatoes
//
//  Created by Ryan Newton on 2/4/15.
//  Copyright (c) 2015 ___rvkn___. All rights reserved.
//

import Foundation

private let RtApiKey = "mvvztd3waum3d5wuzu8bb2s9"

class Movie {
    let title: String?
    let synopsis: String?
    let runtime: Int?
    let score: Int?
    let thumbnailPosterUrl: NSURL?
    let posterUrl: NSURL?
    var thumbnailImage: UIImage?
    var posterImage: UIImage?

    
    init(title: String, synopsis: String, runtime: Int, thumbnailPosterUrl: NSURL, posterUrl: NSURL) {
        self.title = title
        self.synopsis = synopsis
        self.runtime = runtime
        self.thumbnailPosterUrl = thumbnailPosterUrl
        self.posterUrl = posterUrl

        // Setting these later once they're downloaded. Is this a memory risk to store all these images?
        self.thumbnailImage = nil
        self.posterImage = nil
    }
    
    convenience init(jsonMovie: NSDictionary) {
        let title = jsonMovie["title"] as String
        let synopsis = jsonMovie["synopsis"] as String
        
        let runtime = jsonMovie["runtime"] as Int
        
        
        
        let posters = jsonMovie["posters"] as NSDictionary
        let thumbnailPosterString = posters["thumbnail"] as String
        let posterString = posters["original"] as String
        
        let thumbnailPosterUrl = NSURL(string: thumbnailPosterString)
        let posterUrl = NSURL(string: posterString.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg", options: nil, range: nil))

        self.init(title: title, synopsis: synopsis, runtime: runtime, thumbnailPosterUrl: thumbnailPosterUrl!, posterUrl: posterUrl! )
    }    

    class func getTopMovies(successCallback: (NSArray) -> Void, errorCallback: ((NSError) -> Void)?) {
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=\(RtApiKey)"
        let request = NSMutableURLRequest(URL: NSURL(string:RottenTomatoesURLString)!)

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response, data, error) -> Void in
            if let responseError = error? {
                errorCallback!(responseError)
            } else {
                var mutableMoviesArray: NSMutableArray = []
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                
                for jsonMovie in dictionary["movies"] as NSArray! {
                    mutableMoviesArray.addObject(Movie(jsonMovie: jsonMovie as NSDictionary))

                
                }

                successCallback(mutableMoviesArray as NSArray)
            }
        })
    }
}
