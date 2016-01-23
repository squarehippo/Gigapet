//
//  ViewController.swift
//  Gigapet
//
//  Created by Brian Wilson on 1/11/16.
//  Copyright © 2016 GetRunGo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImage: Monster!
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var food: DragImage!
    @IBOutlet weak var bigHeart: DragImage!

    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var  timer: NSTimer!
    var monsterHappy = false
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heart1.alpha = DIM_ALPHA
        heart2.alpha = DIM_ALPHA
        heart3.alpha = DIM_ALPHA
        
        food.dropTarget = monsterImage
        bigHeart.dropTarget = monsterImage
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        startTimer()
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        print("viewDidLoad")
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.monsterImage.playIdleAnimation()
        })
        monsterImage.playEatingAnimation()
        CATransaction.commit()
        
        monsterHappy = true
        startTimer()
        
        food.alpha = DIM_ALPHA
        food.userInteractionEnabled = false
        
        bigHeart.alpha = DIM_ALPHA
        bigHeart.userInteractionEnabled = false
        
        sfxBite.play()
       
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            
            penalties++
            
            if penalties == 1 {
                heart1.alpha = OPAQUE
                sfxHeart.play()
            } else if penalties == 2 {
                heart2.alpha = OPAQUE
                sfxHeart.play()
            } else if penalties == 3 {
                heart3.alpha = OPAQUE
            } else {
                heart1.alpha = DIM_ALPHA
                heart2.alpha = DIM_ALPHA
                heart3.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2)
        
        if rand == 0 {
            food.alpha = DIM_ALPHA
            food.userInteractionEnabled = false
            
            bigHeart.alpha = OPAQUE
            bigHeart.userInteractionEnabled = true
        } else {
            bigHeart.alpha = DIM_ALPHA
            bigHeart.userInteractionEnabled = false
            
            food.alpha = OPAQUE
            food.userInteractionEnabled = true
        }
        
        monsterHappy = false
    }
    
    func gameOver() {
        musicPlayer.stop()
        sfxDeath.play()
        timer.invalidate()
        monsterImage.playDeathAnimation()
    }



}

