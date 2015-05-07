//
//  HUD.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/7/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import UIKit
import SpriteKit

class HUD: NSObject {
    
//    var enemiesLeft:Int {
//        get { return self.enemiesLeft }
//        set {
//            self.enemiesLeft = newValue
//            atualizarHUD()
//        }
//    }
    var enemiesLeft = 30
    var level = 1
    
    var parentView: SKScene!
    
    var enemiesLabel = SKLabelNode(fontNamed: "Chalkduster")
    var lifeLabel = SKLabelNode(fontNamed: "Chalkduster")
    var levelLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    
    convenience init(view: SKScene){
        self.init()
        parentView = view
        //enemiesLeft = 30
        
        
        enemiesLabel.fontSize = 16
        enemiesLabel.fontColor = SKColor.whiteColor()
        enemiesLabel.position = CGPoint(x: view.size.width/5, y: view.size.height/20)
        parentView.addChild(enemiesLabel)
        
        levelLabel.fontSize = 16
        levelLabel.fontColor = SKColor.whiteColor()
        levelLabel.position = CGPoint(x: view.size.width/10, y: view.size.height-40)
        parentView.addChild(levelLabel)
    }
    
    
    func atualizarHUD(){
        enemiesLabel.text = " Inimigos restantes: \(enemiesLeft) "
        levelLabel.text = " Level \(level) "
    }
    
}
