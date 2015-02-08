//
//  Movie.swift
//  RottenTomatoes
//
//  Created by Ryan Newton on 2/4/15.
//  Copyright (c) 2015 ___rvkn___. All rights reserved.
//

import Foundation

private let RtApiKey = "mvvztd3waum3d5wuzu8bb2s9"
private let TopRentalsEndpoint = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?"
private let InTheatresEnpoint = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?"
private let SearchEndpoint = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?"

class Movie {
    let title: String?
    let synopsis: String?
    let runtime: Int?
    let score: Int?
    let thumbnailPosterUrl: NSURL?
    let posterUrl: NSURL?
    var thumbnailImage: UIImage?
    var posterImage: UIImage?

    
    init(title: String, synopsis: String, runtime: Int, score: Int, thumbnailPosterUrl: NSURL, posterUrl: NSURL) {
        self.title = title
        self.synopsis = synopsis
        self.runtime = runtime
        self.score = score
        self.thumbnailPosterUrl = thumbnailPosterUrl
        self.posterUrl = posterUrl

        // Setting these later once they're downloaded. Is this a memory risk to store all these images?
        self.thumbnailImage = nil
        self.posterImage = nil
    }
    
    convenience init(jsonMovie: NSDictionary) {
        // Handles the Rotten Tomatoes movie JSON format
        
        let title = jsonMovie["title"] as String
        let synopsis = jsonMovie["synopsis"] as String
        
        // A janky way of getting around the fact that some movies have bad data. Probably a better way to do this
        var runtime: Int = 0
        if let fetchedRuntime = jsonMovie["runtime"] as? Int {
            runtime = fetchedRuntime
        }

        let posters = jsonMovie["posters"] as NSDictionary
        let thumbnailPosterString = posters["thumbnail"] as String
        let posterString = posters["original"] as String

        let ratingsDict = jsonMovie["ratings"] as NSDictionary
        let score = ratingsDict["critics_score"] as Int
        
        let thumbnailPosterUrl = NSURL(string: thumbnailPosterString)
        let posterUrl = NSURL(string: posterString.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg", options: nil, range: nil))

        self.init(title: title, synopsis: synopsis, runtime: runtime, score: score, thumbnailPosterUrl: thumbnailPosterUrl!, posterUrl: posterUrl! )
    }    

    class func getTopMovies(successCallback: (NSArray) -> Void, errorCallback: ((NSError) -> Void)?) {
        // Gets the top rental movies
        Movie.getMoviesFromEndpoint(TopRentalsEndpoint, successCallback: successCallback, errorCallback: errorCallback)
    }
    
    class func getInTheater(successCallback: (NSArray) -> Void, errorCallback: ((NSError) -> Void)?) {
        // Gets the movies currently in the theaters
        Movie.getMoviesFromEndpoint(InTheatresEnpoint, successCallback: successCallback, errorCallback: errorCallback)
    }
    
    class func getBySearchString(searchString: String, successCallback: (NSArray) -> Void, errorCallback: ((NSError) -> Void)?) {
        // Searches for movies based on a string
        
        let escapedString = searchString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        // way better to do with with AFNetworking and params I imagine.
        let fullQueryString = "\(SearchEndpoint)q=\(escapedString!)&"
        getMoviesFromEndpoint(fullQueryString, successCallback: successCallback, errorCallback: errorCallback)
        
    }
  
    class func getMoviesFromEndpoint(endpoint: String! ,successCallback: (NSArray) -> Void, errorCallback: ((NSError) -> Void)?) {
        let requestString = "\(endpoint)apikey=\(RtApiKey)"
        let request = NSMutableURLRequest(URL: NSURL(string:requestString)!)

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
