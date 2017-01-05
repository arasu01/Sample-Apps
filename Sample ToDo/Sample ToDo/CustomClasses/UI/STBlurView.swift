//
//  STBlurView.swift
//  Sample ToDo
//
//  Created by Arasuvel Theerthapathy on 29/11/16.
//  Copyright © 2016 Arasuvel Theerthapathy. All rights reserved.
//

import UIKit

class STBlurView: UIView {

    var blurImage: UIImage? {
        didSet {
            customize()
        }
    }
    
    var viewColor: UIColor? {
        didSet {
            customize()
        }
    }
    
    
    // MARK: - View life cycle methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) 
    }
    
    
    // MARK: - Custom methods
    
    func customize() {
        let imageView = UIImageView(image: blurImage)
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = imageView.bounds
        blurredEffectView.alpha = 0.75
        blurredEffectView.backgroundColor = viewColor
        addSubview(blurredEffectView)
    }

}
