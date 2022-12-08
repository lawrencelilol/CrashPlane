//
//  GameScene.swift
//  CrashPlane
//
//  Created by Lawrence on 11/13/22.
//

import SpriteKit
import GameplayKit

enum GameState {
    case showingLogo
    case playing
    case dead
//    case revive
}



class GameScene: SKScene, SKPhysicsContactDelegate {
  
  // import GameStepSDK
  
  var user = globalUser
//  var coins = user.theCoin
  
  var player: SKSpriteNode!
  var scoreLabel: SKLabelNode!
  var coinLabel: SKLabelNode!
  var backgroundMusic: SKAudioNode!
  
  var logo: SKSpriteNode!
  var gameOver: SKSpriteNode!

  var gameState = GameState.showingLogo

  var score = 0 {
      didSet {
          scoreLabel.text = "SCORE: \(score)"
      }
  }
  
  
  // testing purpose providing user 10 coins for now
  var coin = 0 {
    didSet {
      coinLabel.text = "COIN: \(coin)"
    }
  }
  
  // default cost for revive is 5
  let costToRevive = 5
  
  // cache for creating rock
  
  let rockTexture = SKTexture(imageNamed: "rock")
  var rockPhysics: SKPhysicsBody!
  
  // cache for player's explosion
  let explosion = SKEmitterNode(fileNamed: "PlayerExplosion")
  
  
  func setScore(val: Int) {
    score = val
  }
  
  func setCoin(val: Int) {
    coin = val
  }

  
  override func didMove(to view: SKView) {
    createPlayer()
    createSky()
    createBackground()
    createGround()
    createScore()
    createLogos()
    createCoin()
    
    // add gravity to the game
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    physicsWorld.contactDelegate = self
    
    // add background music
    if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
        backgroundMusic = SKAudioNode(url: musicURL)
        addChild(backgroundMusic)
    }
    
    // cache the rock
    rockPhysics = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())

  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    switch gameState {
      case .showingLogo:
        
        setCoin(val: user.theCoin)
        
        gameState = .playing
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let wait = SKAction.wait(forDuration: 0.5)
        let activatePlayer = SKAction.run { [unowned self] in
          self.player.physicsBody?.isDynamic = true
          self.startRocks()
        }
        
        let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
        logo.run(sequence)
        
      case .playing:
        
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        
      case .dead:
        
        if let scene = GameScene(fileNamed: "GameScene") {
          scene.scaleMode = .aspectFill
          let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
          view?.presentScene(scene, transition: transition)
        }
        
        
        
        // we don't need revive anymore
        //      case .revive:
        
        
        //        self.user.consumeCoin(coin: costToRevive)
        //        let scoreWhenDead = score
        //        let coinAfterRevive = coin - costToRevive
        
        //        revive()
        
        
        //        if let scene = GameScene(fileNamed: "GameScene") {
        //          scene.scaleMode = .aspectFill
        //          let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
        //          view?.presentScene(scene, transition: transition)
        //          scene.setScore(val: scoreWhenDead)
        ////          scene.setCoin(val: coinAfterRevive)
        //        }
    }
        
 
  }
  
  override func update(_ currentTime: TimeInterval) {
    
      guard player != nil else { return }

      let value = player.physicsBody!.velocity.dy * 0.001
      let rotate = SKAction.rotate(toAngle: value, duration: 0.1)

      player.run(rotate)
  }
  
  
  // collision of the plane and rocks work in here
  func didBegin(_ contact: SKPhysicsContact) {
    
    // if user toches the red rectangle
    if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
      if contact.bodyA.node == player {
        contact.bodyB.node?.removeFromParent()
      } else {
        contact.bodyA.node?.removeFromParent()
      }
      
      let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
      run(sound)
      
      score += 1
      
      return
    }
    
    guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
      return
    }
    
    
    // if user touches rock and ground
    if contact.bodyA.node == player || contact.bodyB.node == player {
      if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
        explosion.position = player.position
        addChild(explosion)
      }
      
      let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
      run(sound)
      
      // change states when the user is dead
      if coin >= costToRevive {
        
        globalScore = score
        
//        gameState = .revive
//        player.removeFromParent()
        speed = 0
        
        revive()
      
        
        
      } else {
        gameOver.alpha = 1
        gameState = .dead
        
        if backgroundMusic != nil {
          backgroundMusic.run(SKAction.stop())
        }
        
        player.removeFromParent()
        speed = 0
      }
    }
    
  }
  
  // MARK: Game Management Methods
  func revive() {
    
    let reviveScene = ReviveScene(size: size)
    reviveScene.scaleMode = scaleMode
    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
    view?.presentScene(reviveScene,transition: transitionType)
    
  }
  
  // create the start scene and end scene for the game
  func createLogos() {
      logo = SKSpriteNode(imageNamed: "logo")
      logo.position = CGPoint(x: frame.midX, y: frame.midY)
      addChild(logo)

      gameOver = SKSpriteNode(imageNamed: "gameover")
      gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
      gameOver.alpha = 0
      addChild(gameOver)
    
  }
  
  
  
  // create the player
  func createPlayer() {
    
      let playerTexture = SKTexture(imageNamed: "player-1")
      player = SKSpriteNode(texture: playerTexture)
      player.zPosition = 10
      player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)

      addChild(player)
    
      player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
      player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
      player.physicsBody?.isDynamic = false
      
      player.physicsBody?.collisionBitMask = 0


      let frame2 = SKTexture(imageNamed: "player-2")
      let frame3 = SKTexture(imageNamed: "player-3")
      let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame2], timePerFrame: 0.01)
      let runForever = SKAction.repeatForever(animation)

      player.run(runForever)
  }
  
  func createSky() {
    
      let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
      topSky.anchorPoint = CGPoint(x: 0.5, y: 1)

      let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
      bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)

      topSky.position = CGPoint(x: frame.midX, y: frame.height)
      bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)

      addChild(topSky)
      addChild(bottomSky)

      bottomSky.zPosition = -40
      topSky.zPosition = -40
  }
  
  func createBackground() {
      let backgroundTexture = SKTexture(imageNamed: "background")

      for i in 0 ... 1 {
          let background = SKSpriteNode(texture: backgroundTexture)
          background.zPosition = -30
          background.anchorPoint = CGPoint.zero
          background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
          
          addChild(background)
        
        let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
        let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        background.run(moveForever)
      }
  }
  
  func createGround() {
      let groundTexture = SKTexture(imageNamed: "ground")

      for i in 0 ... 1 {
          let ground = SKSpriteNode(texture: groundTexture)
          ground.zPosition = -10
          ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
        
          ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
          ground.physicsBody?.isDynamic = false

          addChild(ground)

          let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
          let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
          let moveLoop = SKAction.sequence([moveLeft, moveReset])
          let moveForever = SKAction.repeatForever(moveLoop)

          ground.run(moveForever)
      }
  }
  
  // MARK: Creat Rocks Here
  func createRocks() {
    
      // 1
      let rockTexture = SKTexture(imageNamed: "rock")

      let topRock = SKSpriteNode(texture: rockTexture)
    
      topRock.physicsBody = rockPhysics.copy() as? SKPhysicsBody
      topRock.physicsBody?.isDynamic = false

      topRock.zRotation = .pi
      topRock.xScale = -1.0

      let bottomRock = SKSpriteNode(texture: rockTexture)
    
      bottomRock.physicsBody = rockPhysics.copy() as? SKPhysicsBody
      bottomRock.physicsBody?.isDynamic = false

      topRock.zPosition = -20
      bottomRock.zPosition = -20

      // 2
      let rockCollision = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 32, height: frame.height))
    
      rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
      rockCollision.physicsBody?.isDynamic = false
    
      rockCollision.name = "scoreDetect"

      addChild(topRock)
      addChild(bottomRock)
      addChild(rockCollision)
    
      // 3
      let xPosition = frame.width + topRock.frame.width

      let max = CGFloat(frame.height / 3)
      let yPosition = CGFloat.random(in: -50...max)

      // this next value affects the width of the gap between rocks
      // make it smaller to make your game harder – if you're feeling evil!
      let rockDistance: CGFloat = 70

      // 4
      topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
      bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
      rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y:frame.midY)

      let endPosition = frame.width + (topRock.frame.width * 2)

      let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
      let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
      topRock.run(moveSequence)
      bottomRock.run(moveSequence)
      rockCollision.run(moveSequence)
  }
  
  // generate rocks infinitely and randomly
  func startRocks() {
      let create = SKAction.run { [unowned self] in
          self.createRocks()
      }

      let wait = SKAction.wait(forDuration: 3)
      let sequence = SKAction.sequence([create, wait])
      let repeatForever = SKAction.repeatForever(sequence)

      run(repeatForever)
  }
  
  func createScore() {
      scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
      scoreLabel.fontSize = 20

      scoreLabel.position = CGPoint(x: frame.midX - 65, y: frame.maxY - 70)
      scoreLabel.text = "SCORE: 0"
      scoreLabel.fontColor = UIColor.black

      addChild(scoreLabel)
  }
  
  func createCoin() {
      coinLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
      coinLabel.fontSize = 20

      coinLabel.position = CGPoint(x: frame.midX + 65, y: frame.maxY - 70)
      coinLabel.text = "COIN: \(user.defaults.integer(forKey: "coins"))"
      coinLabel.fontColor = UIColor.black

      addChild(coinLabel)
  }
  
  
}


