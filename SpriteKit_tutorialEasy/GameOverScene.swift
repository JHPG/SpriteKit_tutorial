//
//  GameOverScene.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/4/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let singleton = Singleton.sharedInstance
    var message: String!
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.whiteColor()
        
        addRunningBackground("space", filename2: "space")
        
        // 2
        if won {
            message = " Level \(singleton.level)! "
        } else {
            message = "☠ You Lose ☠"
            singleton.level = 1
        }
        
        //var message = won ? " Level \(singleton.level)! " : "☠ You Lose ☠"
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // 4
        runAction(SKAction.sequence([
            SKAction.waitForDuration(1.3),  //Delay de tela
            SKAction.runBlock() {
                // 5
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
        ]))
        
        
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
