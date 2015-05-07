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