//
//  Player.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/7/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import SpriteKit

// #MARK: Sem uso

//func + (left: CGPoint, right: CGPoint) -> CGPoint {
//    return CGPoint(x: left.x + right.x, y: left.y + right.y)
//}
//
//func - (left: CGPoint, right: CGPoint) -> CGPoint {
//    return CGPoint(x: left.x - right.x, y: left.y - right.y)
//}
//
//func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
//    return CGPoint(x: point.x * scalar, y: point.y * scalar)
//}
//
//func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
//    return CGPoint(x: point.x / scalar, y: point.y / scalar)
//}
//
//#if !(arch(x86_64) || arch(arm64))
//    func sqrt(a: CGFloat) -> CGFloat {
//    return CGFloat(sqrtf(Float(a)))
//    }
//#endif
//
//extension CGPoint {
//    func length() -> CGFloat {
//        return sqrt(x*x + y*y)  //Hipotenusa
//    }
//    
//    func normalized() -> CGPoint {
//        return self / length()
//    }
//}

class Player: SKSpriteNode {
    
    var parentView: SKScene?
    var shootAvaliable = true
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Monster   : UInt32 = 0b1       // 1
        static let Projectile: UInt32 = 0b10      // 2
        static let Player    : UInt32 = 0b100     // 3
    }
   
    convenience init(view: SKScene) {
        
        self.init(imageNamed: "rocket")
        self.name = "player"
        self.size = CGSize(width: self.size.width, height: self.size.height)
        self.position = CGPoint(x: view.size.width * 0.1, y: view.size.height * 0.5)      //errado
        parentView = view
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = false
        
        // physicsBody
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size) // 1
        self.physicsBody?.dynamic = false // 2    // the physics engine will not control the movement of the self
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player // 3
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Monster // 4
        self.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        self.physicsBody?.usesPreciseCollisionDetection = true
    }

    func shoot(touch: UITouch){
        
        if shootAvaliable {
        // Set up initial location of projectile
            let projectile = SKSpriteNode(imageNamed: "projectile")
            projectile.position = self.position
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.dynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            /// OK to add now - you've double checked position
            parentView!.addChild(projectile)
            
            /// Make it shoot far enough to be guaranteed off screen
            let shootAmount = parentView!.size.width
            
            /// Add the shoot amount to the current position
            let realDest = CGPoint(x: self.size.width + shootAmount, y: self.position.y)
            
            /// Create the actions
            let actionMove = SKAction.moveTo(realDest, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
            
        }
    }

    
    
}
