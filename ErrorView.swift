//
//  ErrorView.swift
//  
//
//  Created by Ryan Newton on 2/7/15.
//
//  This class is for displaying error messages at the top

import UIKit

class ErrorView: UIView {
    
    @IBOutlet weak var label: UILabel!

    func expand() {
        
        // for some reason the frame width was getting overwritten to 0 from the storyboard. Hence I need this first to make the animation look right
        self.frame = CGRectMake(0, 0, 380, 45)
        let expandedFrame = CGRectMake(0, 65, 380, 45)

        
        UIView.animateWithDuration(1, animations: {
            self.frame = expandedFrame
            self.label.frame = CGRectMake(0, 0, 380, 45)
        })
    }
    
    func collapse() {
        let collapsedFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, 0)
        UIView.animateWithDuration(1, animations: {
            self.frame = collapsedFrame
            self.label.frame = collapsedFrame
        })
    }
    
    func expandWithErrorMessage(message: String) {
        self.label.text = message
        self.expand()
    }
}
