//
//  MovieTableViewCell.swift
//  RottenTomatoes
//
//  Created by Ryan Newton on 2/3/15.
//  Copyright (c) 2015 ___rvkn___. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieTitleThumb: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
