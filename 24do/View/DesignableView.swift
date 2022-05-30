//
//  DesignableView.swift
//  CoreToDo
//
//  Created by Victor Kenzo Nawa on 9/28/17.
//  Copyright © 2017 Victor Kenzo Nawa. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
