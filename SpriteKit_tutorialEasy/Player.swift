//
//  Player.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/7/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
   
    convenience init() {
        
        self.init(imageNamed: "player")
        self.name = "player"
        self.size = CGSize(width: self.size.width*2, height: self.size.height*2)  //Temporário
        self.position = CGPoint(x: super.size.width * 0.1, y: super.size.height * 0.5)      //errado
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = false
    }

    
    func shoot(touch: UITouch){
        
        runAction(SKAction.playSoundFileNamed("laser.mp3", waitForCompletion: false))
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = self.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // 3 - Determine offset of location to projectile
        var touchLocation = touch.locationInNode(self)
        var previousLocation = touch.previousLocationInNode(self)
        
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.x < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()     //Convert the offset into a unit vector
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }

    
    
}
