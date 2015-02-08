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
        let expandedFrame = CGRectMake(0, 0, self.frame.width, 20)
    
        UIView.animateWithDuration(1, animations: {
            self.frame = expandedFrame
            self.label.frame = expandedFrame
        })
    }
    
    func collapse() {
        let collapsedFrame = CGRectMake(0, 0, self.frame.width, 0)
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
