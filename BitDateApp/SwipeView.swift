//
//  SwipeView.swift
//  BitDateApp
//
//  Created by Adriel Carsete on 6/11/15.
//  Copyright (c) 2015 Adriel Carsete. All rights reserved.
//

import Foundation
import UIKit

class SwipeView: UIView {
    
    enum Direction {
        case None
        case Left
        case Right
    }
    
    weak var delegate: SwipeViewDelegate?
    
    let overlay: UIImageView = UIImageView()
    
    var direction: Direction?
    
    var innerView: UIView? {
        didSet {
            if let v = innerView { // if innerView exists set innerView to v
                
                insertSubview(v, belowSubview: overlay)
                v.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        }
    }
    
    private var originalPoint:  CGPoint?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    init() {
        super.init(frame: CGRectZero)
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.clearColor()
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
        
        overlay.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(overlay)
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        let distance = gestureRecognizer.translationInView(self)
        println("Distance x: \(distance.x) y: \(distance.y)")
        
        switch gestureRecognizer.state {
            case UIGestureRecognizerState.Began:
                originalPoint = center
            
            case UIGestureRecognizerState.Changed:
                
                let rotationPercentage = min(distance.x/(self.superview!.frame.width / 2), 1)
                let rotationAngle = (CGFloat(2 * M_PI / 16) * rotationPercentage)
                transform = CGAffineTransformMakeRotation(rotationAngle)

                center = CGPointMake(originalPoint!.x + distance.x, originalPoint!.y + distance.y)
                
                updateOverlay(distance.x)
            
            
            case UIGestureRecognizerState.Ended:
                
                if abs(distance.x) < frame.width / 4 {
                    resetViewPositionAndTransformations()
                }
                else {
                    swipe(distance.x > 0 ? Direction.Right : Direction.Left)  //Operador Ternario
                }
                
            
            default:
                println("Default trigged for GestureRecognizer")
                break
        }
    }
    
    func swipe(s: Direction) {
        if s == .None {   //Direction.None
            return
        }
        var parentWidth = superview!.frame.size.width
        if s == .Left {
            parentWidth *= -1
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.center.x = self.frame.origin.x + parentWidth
            }, completion: {
                success in
                if let d = self.delegate {
                    s == Direction.Right ? d.swipedRight() : d.swipedLeft()
                }
        })
    }
    
    private func updateOverlay(distance: CGFloat) {
        
        var newDirection: Direction
        newDirection = distance < 0 ? .Left : .Right
        
        if newDirection != direction {
            direction = newDirection
            overlay.image = direction == .Right ? UIImage(named: "yeah-stamp") : UIImage(named: "nah-stamp")
        }
        overlay.alpha = abs(distance) / (superview!.frame.width/2)
        
    }
    
    
    private func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.center = self.originalPoint!
            self.transform = CGAffineTransformMakeRotation(0) //reset rotation
            
            self.overlay.alpha = 0  //set to transparent YEAH or NAH Image
            
        })
        
    }
    
}

// MARK: - SWIPE PROTOCOL
protocol SwipeViewDelegate: class {
    
    func swipedLeft()
    func swipedRight()
}

