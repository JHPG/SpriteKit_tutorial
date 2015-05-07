//
//  SKScene_extension.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/7/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import SpriteKit
import AVFoundation
import UIKit

var backgroundMusicPlayer: AVAudioPlayer!
var bg1, bg2: SKSpriteNode!

extension SKScene: SKPhysicsContactDelegate {
    
    func playBackgroundMusic(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(
            filename, withExtension: nil)
        if (url == nil) {
            println("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        backgroundMusicPlayer =
            AVAudioPlayer(contentsOfURL: url, error: &error)
        if backgroundMusicPlayer == nil {
            println("Could not create audio player: \(error!)")
            return
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
    func addRunningBackground(filename1: String, filename2: String){
        // create 2 background sprites
        bg1 = SKSpriteNode(imageNamed: filename1)
        bg1.anchorPoint = CGPointZero
        bg1.position = CGPointMake(0, 0)
        bg1.size = CGSize(width: self.size.width, height: self.size.height)
        addChild(bg1)
        
        bg2 = SKSpriteNode(imageNamed: filename2)
        bg2.anchorPoint = CGPointZero;
        bg2.position = CGPointMake(bg1.size.width-1, 0);
        bg2.size = CGSize(width: self.size.width, height: self.size.height)
        self.addChild(bg2)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence( [ SKAction.runBlock {
                self.updateBackground()
                }, SKAction.waitForDuration(0.02)] )
            ))
    }
    
    func updateBackground() {
        bg1.position = CGPointMake(bg1.position.x-4, bg1.position.y);
        bg2.position = CGPointMake(bg2.position.x-4, bg2.position.y);
        
        if (bg1.position.x < -bg1.size.width){
            bg1.position = CGPointMake(bg2.position.x + bg2.size.width, bg1.position.y);
        }
        
        if (bg2.position.x < -bg2.size.width) {
            bg2.position = CGPointMake(bg1.position.x + bg1.size.width, bg2.position.y);
        }
    }
    
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(Double(red) / 255.0)
        let newGreen = CGFloat(Double(green) / 255.0)
        let newBlue = CGFloat(Double(blue) / 255.0)
    
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: CGFloat(1.0))
    }
}

extension Int {
    var toString: String {
        get { return "\(self)" }
    }
}