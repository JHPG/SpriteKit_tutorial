//
//  GameScene.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/4/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import SpriteKit
import AVFoundation

// #MARK: Sem uso
//
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

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
    static let Player    : UInt32 = 0b100     // 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var monstersDestroyed = 0
    var enemiesLeft = 30
    
    //let player = SKSpriteNode(imageNamed: "player")
    var player: Player!
    
    let label = SKLabelNode(fontNamed: "Chalkduster")
    var isFingerOnPlayer = false
    
    //#MARK: Funções padrão
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.whiteColor()
        addRunningBackground("space", filename2: "space")
        
        player = Player(view: self)
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        
        criarHUD()
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence( [ SKAction.runBlock {
                self.addChild(Enemy(view: self))
            }, SKAction.waitForDuration(1.0)] )
        ))
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        playBackgroundMusic("bg_sound1.mp3")
    }
    
    override func update(currentTime: NSTimeInterval) {
        atualizarHUD()
    }
    
    // #MARK: Criar elementos de cena
    
    func criarHUD(){
        label.fontSize = 16
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/5, y: size.height/20)
        addChild(label)
    }
    
    func atualizarHUD(){
        label.text = " Inimigos restantes: \(enemiesLeft) "
    }
    
//    func addPlayer(){
//        player.name = "player"
//        player.size = CGSize(width: player.size.width*2, height: player.size.height*2)  //Temporário
//        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
//        
//        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
//        
//        addChild(player)
//    }
    
//    func addMonster() {
//        
//        let monster = SKSpriteNode(imageNamed: "monster")
//        
//        // physicsBody
//        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size) // 1
//        monster.physicsBody?.dynamic = true // 2    // the physics engine will not control the movement of the monster
//        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
//        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
//        monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
//
//        /// Determine where to spawn the monster along the Y axis (random)
//        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
//        
//        // Position the monster slightly off-screen along the right edge,
//        // and along a random position along the Y axis as calculated above
//        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
//        
//        // Add the monster to the scene
//        addChild(monster)
//        
//        /// Determine speed of the monster
//        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
//        
//        // Create the actions
//        let actionMove = SKAction.moveTo (CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
//        let actionMoveDone = SKAction.removeFromParent()
//        
//        let loseAction = SKAction.runBlock() {
//            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
//            let gameOverScene = GameOverScene(size: self.size, won: false)
//            self.view?.presentScene(gameOverScene, transition: reveal)
//        }
//        // Faz ele ir até o final e dar game Over (jogador não matou durante jogo)
//        monster.runAction(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
//    }
    
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
        enemiesLeft--
        
        monstersDestroyed++
        if (monstersDestroyed >= 30) {
            let reveal = SKTransition.flipHorizontalWithDuration(0.3)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }

    }
    
//    //#MARK: Random functions
//
//    func random() -> CGFloat {
//        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
//    }
//    
//    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
//        return random() * (max - min) + min
//    }
    
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
    
//    func shoot(touch: UITouch){
//        
//        runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
//        
//        // 2 - Set up initial location of projectile
//        let projectile = SKSpriteNode(imageNamed: "projectile")
//        projectile.position = player.position
//        
//        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
//        projectile.physicsBody?.dynamic = true
//        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
//        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
//        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
//        projectile.physicsBody?.usesPreciseCollisionDetection = true
//        
//        // 3 - Determine offset of location to projectile
//        var touchLocation = touch.locationInNode(self)
//        var previousLocation = touch.previousLocationInNode(self)
//        
//        let offset = touchLocation - projectile.position
//        
//        // 4 - Bail out if you are shooting down or backwards
//        if (offset.x < 0) { return }
//        
//        // 5 - OK to add now - you've double checked position
//        addChild(projectile)
//        
//        // 6 - Get the direction of where to shoot
//        let direction = offset.normalized()     //Convert the offset into a unit vector
//        
//        // 7 - Make it shoot far enough to be guaranteed off screen
//        let shootAmount = direction * 1000
//        
//        // 8 - Add the shoot amount to the current position
//        let realDest = shootAmount + projectile.position
//        
//        // 9 - Create the actions
//        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
//        let actionMoveDone = SKAction.removeFromParent()
//        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
//    }
    
    
    
}




