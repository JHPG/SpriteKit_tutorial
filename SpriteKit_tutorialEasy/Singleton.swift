//
//  Singleton.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/7/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//

import UIKit

class Singleton: NSObject {
   
    /// Singleton
    static let sharedInstance = Singleton()
    
    var level = 1
    var lives = 3
    var dificulty = 1
}
