//
//  GameCenterManager.swift
//  SpriteKit_tutorialEasy
//
//  Created by Jorge Henrique P. Garcia on 5/8/15.
//  Copyright (c) 2015 Jorge Henrique P. Garcia. All rights reserved.
//






//----------------------
//
//      Sem uso
//
//----------------------






import GameKit

class GameCenterManager: NSObject {
    
    var gameCenterEnabled = false
    var leaderboardIdentifier = "highScore"
   
    
    
    
    
    
    
    func addLeaderboardScore(score:Int64) {
     var newGCScore = GKScore(leaderboardIdentifier:"MySecondGameLeaderboard")
     newGCScore.value = score
     GKScore.reportScores([newGCScore], withCompletionHandler: {(error) -> Void in
       if error != nil{
         println("Score not submitted")
         // Continue
         //self.gameOver=false
       } else {
             // Notify the delegate to show the game center leaderboard:
             // Not implemented yet
               }
        })
    }


    
    
    
    func initGameCenter() {
       
     // Check if user is already authenticated in game center
     if GKLocalPlayer.localPlayer().authenticated == false {
    
       // Show the Login Prompt for Game Center
       GKLocalPlayer.localPlayer().authenticateHandler = {(viewController, error) ->Void in
         if viewController != nil{
           //self.scene!.gamePaused = true
           //self.presentViewController(viewController, animated:true, completion:nil)
    
           // Add an observer which calls 'gameCenterStateChanged' to handle a changed game center state
           let notificationCenter = NSNotificationCenter.defaultCenter()
           notificationCenter.addObserver(self, selector:"gameCenterStateChanged", name:"GKPlayerAuthenticationDidChangeNotificationName", object:nil)
         }
       }
     }
        
//    func gameCenterStateChanged() {
//     self.scene!.gamePaused = false
//        
//    }


}

    
    
    
    
    
    
    
    
}
