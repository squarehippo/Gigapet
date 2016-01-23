//
//  Monster.swift
//  Gigapet
//
//  Created by Brian Wilson on 1/11/16.
//  Copyright © 2016 GetRunGo. All rights reserved.
//

import Foundation
import UIKit

class Monster: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation() 
    }
    
    func playIdleAnimation() {
        self.image = UIImage(named: "idle1.png")
        setupAnimation("idle", imgCount: 3, repeatCount: 0)
    }
    
    func playDeathAnimation() {
        self.image = UIImage(named: "dead4.png")
        setupAnimation("dead", imgCount: 4, repeatCount: 1)
    }
    
    func playEatingAnimation() {
        self.image = UIImage(named: "idle1.png")
        setupAnimation("idle", imgCount: 4, repeatCount: 3)
    }
    
    func setupAnimation(prefix: String, imgCount: Int, repeatCount: Int) {
        self.animationImages = nil
        var imageArray = [UIImage]()
        
        for x in 0...imgCount {
            let img = UIImage(named: "\(prefix)\(x).png")
            imageArray.append(img!)
            
            animationImages = imageArray
            animationDuration = 0.8
            animationRepeatCount = repeatCount
            startAnimating()
        }
    }
}
