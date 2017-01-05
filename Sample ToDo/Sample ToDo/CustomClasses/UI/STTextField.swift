//
//  STTextField.swift
//  Sample ToDo
//
//  Created by Arasuvel Theerthapathy on 15/12/16.
//  Copyright © 2016 Arasuvel Theerthapathy. All rights reserved.
//

import UIKit

@IBDesignable

class STTextField: UITextField {

    // MARK: - CornerDesignable
    @IBInspectable open var cornerRadius: CGFloat = CGFloat.nan {
        didSet {
            configureCornerRadius()
        }
    }
    
    // MARK: - FillDesignable
    @IBInspectable open var fillColor: UIColor? {
        didSet {
            configureFillColor()
        }
    }
    
    // MARK: - BorderDesignable
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            configureBorder()
        }
    }
    @IBInspectable open var borderWidth: CGFloat = CGFloat.nan {
        didSet {
            configureBorder()
        }
    }

    // MARK: - ShadowDesignable
    @IBInspectable open var shadowColor: UIColor? {
        didSet {
            configureShadowColor()
        }
    }
    @IBInspectable open var shadowRadius: CGFloat = CGFloat.nan
    @IBInspectable open var shadowOpacity: CGFloat = CGFloat.nan
    @IBInspectable open var shadowOffset: CGPoint = CGPoint(x: CGFloat.nan, y: CGFloat.nan)
}

extension STTextField {
    
    public func configureCornerRadius() {
        if !cornerRadius.isNaN && cornerRadius > 0 {
            layer.cornerRadius = cornerRadius
        }
    }
    
    public func configureFillColor() {
        if let fillColor = fillColor {
            backgroundColor = fillColor
        }
    }
    
    public func configureBorder() {
        if !borderWidth.isNaN && borderWidth > 0 {
            layer.borderWidth = borderWidth
        }
        
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    public func configureShadowColor() {
        if let shadowColor = shadowColor {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
}

