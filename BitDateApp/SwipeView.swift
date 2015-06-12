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
    
    private let card: CardView = CardView()
   
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
        self.backgroundColor = UIColor.redColor()
        addSubview(card)
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
        
        card.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
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
            
            case UIGestureRecognizerState.Ended:
                
                if abs(distance.x) < frame.width / 4 {
                    resetViewPositionAndTransformations()
                }
                else {
                    swipe(distance.x > 0 ? .Right : .Left)  //Operador Ternario
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
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.center.x = self.frame.origin.x + parentWidth
        })
    }
    
    private func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.center = self.originalPoint!
            self.transform = CGAffineTransformMakeRotation(0) //reset rotation
        })
        
    }
    
}

// MARK: - SWIPE PROTOCOL
protocol SwipeViewDelegate: class {
    
    func swipedLeft()
    func swipedRight()
}

