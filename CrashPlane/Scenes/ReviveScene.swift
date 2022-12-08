
//  ReviveScene.swift
//  CrashPlane
//
//  Created by Lawrence on 12/6/22.


import UIKit
import SpriteKit


class ReviveScene: SKScene {
  
  var user = globalUser
  
  override func didMove(to view: SKView) {
    self.backgroundColor = SKColor.black
    
    //revive button
    let reviveButton = SKSpriteNode(imageNamed: "revive_btn")
    reviveButton.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
    reviveButton.name = "revive"
    addChild(reviveButton)
    
    
    // new game button
    let newgameButton = SKSpriteNode(imageNamed: "newgame_btn")
    newgameButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
    newgameButton.name = "newgame"
    addChild(newgameButton)
    
    // cost to revive text
    let reviveCostText = SKLabelNode(text: "Cost 20 coins to revive")
    reviveCostText.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
    reviveCostText.fontName = "AvenirNext-Bold"
    reviveCostText.fontSize = 20
    
    addChild(reviveCostText)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    
    if touchedNode.name == "revive" {
      if let scene = GameScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFill
        let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
        view?.presentScene(scene, transition: transition)
        
        self.user.consumeCoin(coin: costToRevive)
        
        scene.setScore(val: globalScore)
      }
    } else {
      
      if let scene = GameScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFill
        let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
        view?.presentScene(scene, transition: transition)
        globalScore = 0
        scene.setScore(val: globalScore)
      }
    }
  }
}
