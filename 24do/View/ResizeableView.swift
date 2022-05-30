//
//  ResizeableView.swift
//  24do
//
//  Created by Victor Kenzo Nawa on 10/4/17.
//  Copyright © 2017 Victor Kenzo Nawa. All rights reserved.
//

import UIKit

class ResizeableView: UIView {

    static var kResizeThumbSize:CGFloat = 20
    
    var originY: CGFloat!
    var originHeight: CGFloat!
    var offsetY: CGFloat!
    
    var isResizingTopEdge:Bool = false
    var isResizingBottomEdge:Bool = false
    var isMoving:Bool = false
    
    //Define your initialisers here

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches Began")
        print("\(self.frame)")
        originY = self.frame.minY
        originHeight = self.frame.height
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            offsetY = currentPoint.y
            isResizingTopEdge = (currentPoint.y < ResizeableView.kResizeThumbSize)
            isResizingBottomEdge = (self.bounds.size.height - currentPoint.y < ResizeableView.kResizeThumbSize)
            if (!isResizingBottomEdge && !isResizingTopEdge) {
                print("Is Moving")
                isMoving = true
            }
            isResizingTopEdge ? print("Top Edge") : nil
            isResizingBottomEdge ? print("Bottom Edge") : nil
            // do something with your currentPoint
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches Moved")
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let currentPointScreen = touch.location(in: nil)
            // do something with your currentPoint
            if isResizingTopEdge {
                self.frame = CGRect(x: self.frame.minX,y: (currentPointScreen.y),width: self.frame.width,height: (originHeight + (originY - currentPointScreen.y)) )
            }
            if isResizingBottomEdge {
                self.frame = CGRect(x: self.frame.minX,y: self.frame.minY,width: self.frame.width,height: (currentPoint.y))
            }
            if isMoving {
                self.frame = CGRect(x: self.frame.minX,y: (currentPointScreen.y - offsetY),width: self.frame.width,height: self.frame.height)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches Ended")
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            // do something with your currentPoint
            
            isResizingTopEdge = false
            isResizingBottomEdge = false
            isMoving = false
        }
    }
}
