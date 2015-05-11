//
//  self.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/7/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Monster   : UInt32 = 0b1       // 1
        static let Projectile: UInt32 = 0b10      // 2
        static let Player    : UInt32 = 0b100     // 3
    }
    
//    let loseAction = SKAction.runBlock() {
//        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
//        let gameOverScene = GameOverScene(size: self.size, won: false)
//        scene.view?.presentScene(gameOverScene, transition: reveal)
//    }
    
    convenience init(view: SKScene) {
        self.init(imageNamed: "alien-spaceship")
        self.name = "Enemy"
        
        // physicsBody
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size) // 1
        self.physicsBody?.dynamic = true // 2    // the physics engine will not control the movement of the self
        self.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        self.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        /// Determine where to spawn the self along the Y axis (random)
        let actualY = random(min: self.size.height/2, max: view.size.height - self.size.height/2)
        
        // Position the self slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        self.position = CGPoint(x: view.size.width + self.size.width/2, y: actualY)
        
        /// Determine speed of the self
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo (CGPoint(x: -self.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        // Faz ele ir até o final e dar game Over (jogador não matou durante jogo)
        //self.runAction(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        self.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    


    //#MARK: Random functions
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
}