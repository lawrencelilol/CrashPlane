//
//  StartGameScene.swift
//  CrashPlane
//
//  Created by Lawrence on 12/6/22.
//

import UIKit
import SpriteKit

// All the global variables are here

// Initialize GameStepSDK here
var globalUser = GameStep()
// score of the user in the game cycle
var globalScore = 0
// Default cost for revive
let costToRevive = 20

class StartGameScene: SKScene {
  
  override func didMove(to view: SKView) {
    backgroundColor = SKColor.black
    
    
    // button
    let startGameButton = SKSpriteNode(imageNamed: "start_btn")
    startGameButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
    startGameButton.name = "startgame"
    addChild(startGameButton)
    
    let prevSteps = globalUser.defaults.integer(forKey: "steps")
  
    globalUser.updateCoins()
    sleep(1)
    
    var addedCoins = Int(Int(globalUser.currentStep) - prevSteps)/100
    
    addedCoins = max(0, addedCoins)
    
    let totalCoins = SKLabelNode(text: "Total Coins Earned: \(globalUser.getCoins())")
    totalCoins.fontName = "AvenirNext-Bold"
    totalCoins.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
    addChild(totalCoins)
    
    let newCoins = SKLabelNode(text: "Congrats!! You Just earned: \(addedCoins) coins")
    newCoins.fontName = "AvenirNext-Bold"
    newCoins.fontSize = 20
    newCoins.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
    addChild(newCoins)
    
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    if touchedNode.name == "startgame" {
      if let scene = GameScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFill
        let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
        view?.presentScene(scene, transition: transition)
      }
    }
  }

}

