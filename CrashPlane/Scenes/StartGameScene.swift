//
//  StartGameScene.swift
//  CrashPlane
//
//  Created by Lawrence on 12/6/22.
//

import UIKit
import SpriteKit

let globalUser = GameStep()

class StartGameScene: SKScene {
  
  var user = globalUser
  
  override func didMove(to view: SKView) {
    backgroundColor = SKColor.black
    
    // button
    let startGameButton = SKSpriteNode(imageNamed: "start_btn")
    startGameButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
    startGameButton.name = "startgame"
    addChild(startGameButton)
    
    // Steps text
    let coinText = SKLabelNode(text: "Coins Earned: \(user.defaults.integer(forKey: "coins"))")
    coinText.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
    addChild(coinText)
    
//    let stepText = SKLabelNode(text: "Steps Walked: \(user.defaults.integer(forKey: "coins"))")
//    stepText.position = CGPoint(x: size.width/2, y: size.height/2)
//    addChild(stepText)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    if touchedNode.name == "startgame" {
//      let gameOverScene = GameScene(size: size)
//      gameOverScene.scaleMode = scaleMode
//      let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
//      view?.presentScene(gameOverScene,transition: transitionType)
      
      if let scene = GameScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFill
        let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
        view?.presentScene(scene, transition: transition)
      }
    }
  }

}
