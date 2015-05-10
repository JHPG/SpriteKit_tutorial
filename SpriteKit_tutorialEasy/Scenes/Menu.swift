//
//  Menu.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/9/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import SpriteKit

class Menu: SKScene {
    
    var playLabel: SKLabelNode?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        playLabel = childNodeWithName("playLabel") as? SKLabelNode
        
        addRunningBackground("space", filename2: "space")
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        actionWithElement(touches, name: "playLabel") {
            
            let gameScene = GameScene()
            let reveal = SKTransition.flipHorizontalWithDuration(1)
            self.view?.presentScene(gameScene, transition: reveal)
            
        }
        
    }
    
}
