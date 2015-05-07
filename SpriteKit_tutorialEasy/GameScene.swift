//
//  GameScene.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/4/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import SpriteKit
import AVFoundation

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
    static let Player    : UInt32 = 0b100     // 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    var hud: HUD!
    var isFingerOnPlayer = false
    var monstersDestroyed = 0
    
    //#MARK: Funções padrão
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.whiteColor()
        addRunningBackground("space", filename2: "space")
        
        player = Player(view: self)
        
        /// Criar hud
        hud = HUD(view: self)
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence( [ SKAction.runBlock {
                self.addChild(Enemy(view: self))
            }, SKAction.waitForDuration(1.0)] )
        ))
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        //playBackgroundMusic("bg_sound1.mp3")
    }
    
    override func update(currentTime: NSTimeInterval) {
        hud.atualizarHUD()
    }
    
    // #MARK: Colision functions
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
                projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
        }
    }
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        print("Hit - ")
        projectile.removeFromParent()
        monster.removeFromParent()
        hud.enemiesLeft--
        
        monstersDestroyed++
        if (monstersDestroyed >= 30) {
            let reveal = SKTransition.flipHorizontalWithDuration(0.3)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }

    }
    
    // #MARK: Touch
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        actionWithElement(touches, name: "player") {
//            self.isFingerOnPlayer = true
//        }
        
        player.shoot(touches.first as! UITouch)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        //if isFingerOnPlayer {
            // 2. Get touch location
            var touch = touches.first as! UITouch
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            // 3. Get node for player
            var player = childNodeWithName("player") as! SKSpriteNode   //erro aqui (colisao com inimigo)
            
            // 4. Calculate new position along x for paddle
            var playerY = player.position.y + (touchLocation.y - previousLocation.y)
            
            // 5. Limit x so that paddle won't leave screen to left or right
            playerY = max(player.size.width/2, playerY)
            playerY = min(size.width - player.size.width/2, playerY)
            
            // 6. Update player position
            player.position = CGPointMake(player.position.x, playerY)
        //}
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // 1 - Choose one of the touches to work with
        let touch = touches.first as! UITouch
        
        isFingerOnPlayer = false
    }
    
    // #MARK: Custom functions
    
    /// Reduz o código para identificar um toque em um elemento
    func actionWithElement(touches: Set<NSObject>, name: String, function: ()->() ) {
        
        for  obj in touches {
            let touch = obj as! UITouch
            //var touch = touches.first as! UITouch
            var touchLocation = touch.locationInNode(self)
            var touchedNode = self.nodeAtPoint(touchLocation)
            
            if touchedNode.name == name {
                if let mainView = view {
                    function()
                }
            }
        }
    }

    
    
    
    
    
    
    
    
}




