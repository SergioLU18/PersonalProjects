//
//  GameScene.swift
//  Pong2
//
//  Created by Sebastian Jolly on 4/23/18.
//  Copyright © 2018 Jolly. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftUI

class PongGameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    var alreadyWon = false
    var topLbl = SKLabelNode()
    var btmLbl = SKLabelNode()
    var score = [Int]()
    @State var isLoading: Bool = false
    var width = CGFloat()
    var height = CGFloat()
    var started = false
    var points2win = 7
    let playAgain = SKLabelNode(fontNamed: "Squared Display")
    let win = SKLabelNode(fontNamed: "Squared Display")
    let startB = SKLabelNode(fontNamed: "Squared Display")
    let background = SKShapeNode()
    var seconds = 2
    override func didMove(to view: SKView) {
        
        topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
        btmLbl = self.childNode(withName: "btmLabel") as! SKLabelNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        alreadyWon = false
        print(self.view?.bounds.height)
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 100
        
        main = self.childNode(withName: "main") as! SKSpriteNode
        main.position.y = (-self.frame.height / 2) + 100
         
     
        
        startB.text = "Start"
        startB.fontSize = 50
        startB.zRotation = .pi / 2
        startB.position = CGPoint(x: -100, y: 0)
        startB.zPosition = 10
        startB.alpha = 1;
        addChild(startB)
        
        let border  = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
      
      
     
    }
    
    func startGame() {
        startB.removeFromParent()
        score = [0,0]
        topLbl.text = "\(score[1])"
        btmLbl.text = "\(score[0])"
        ball.physicsBody?.applyImpulse(CGVector(dx: 10 , dy: 10))
        
        let wait = SKAction.wait(forDuration: 2)
        let update = SKAction.run(
        {
            let dx = self.ball.physicsBody?.velocity.dx
            let dy = self.ball.physicsBody?.velocity.dy
            let impulse = CGVector(dx: dx!*0.005, dy: dy!*0.005)
            
            
            self.ball.physicsBody?.applyImpulse(impulse)
            self.ball.physicsBody?.applyAngularImpulse(-0.01)
               
        }
        )
        let seq = SKAction.sequence([wait,update])
        run(SKAction.repeatForever(seq))
    }
    
    func addScore(playerWhoWon : SKSpriteNode){
        if !alreadyWon{
            ball.position = CGPoint(x: 0, y: 0)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            if playerWhoWon == main {
                score[0] += 1
                ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
            }
            else if playerWhoWon == enemy {
                score[1] += 1
                ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
            }
            
            topLbl.text = "\(score[1])"
            btmLbl.text = "\(score[0])"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !started{
            for touch in touches {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKLabelNode {
                            if sprite == startB{
                                started = true
                                startGame()
                            }
                        }
                    }
                }
            
            }
        }
        for touch in touches {
            if !alreadyWon{
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    
                }
                
            }
            else{
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
            }else{
        
                    let touchLocation = touch.location(in: self)
                    let touchedWhere = nodes(at: touchLocation)
                    
                    if !touchedWhere.isEmpty {
                        for node in touchedWhere {
                            if let sprite = node as? SKLabelNode {
                                if sprite == playAgain {
                                   
                                        print("ayudaaaaaaa")
                                        score[0] = 0
                                        score[1] = 0
                                        alreadyWon = false
                                    playAgain.removeFromParent()
                                    win.removeFromParent()
                                    ball.position = CGPoint(x: 0, y: 0)
                                    ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                                    ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
                                    topLbl.text = "0"
                                    btmLbl.text = "0"
                                    
                                }
                            }
                        }
                    }
                    
                    
                
            }
            
        }
    }
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            if !alreadyWon{
                for touch in touches {
                    let location = touch.location(in: self)
                    
                    if currentGameType == .player2 {
                        if location.y > 0 {
                            enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                        }
                        if location.y < 0 {
                            
                            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                            
                        }
                        
                    }
                    else{
                        main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                    }
                    
                }
            }
        }
        
        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
            
            if started{
            if !alreadyWon{
                switch currentGameType {
                
                case .player2:
                    
                    break
                }
                
                
                
                if ball.position.y <= main.position.y - 30 {
                    addScore(playerWhoWon: enemy)
                }
                else if ball.position.y >= enemy.position.y + 30 {
                    addScore(playerWhoWon: main)
                }
                if score[0] == points2win || score[1] == points2win{
                    won()
                    alreadyWon = true
                }
            }
            
        }
        }
        func won()  {
            
            if score[0] > score [1]{
                win.text = "Player 1 Wins"
            }else{
                win.text = "Player 2 Wins"
            }
            win.fontSize = 50
            win.zRotation = .pi / 2
            win.position = CGPoint(x: -100, y: 0)
            win.zPosition = 10
            win.alpha = 0;
            addChild(win)
            let out = SKAction.fadeIn(withDuration: 1.5)
            win.run(out)
            
           
            playAgain.text = "Play Again"
            playAgain.fontSize = 40
            playAgain.zRotation = .pi / 2
            playAgain.position = CGPoint(x: 100, y: 0)
            playAgain.zPosition = 10
            playAgain.alpha = 0;
            addChild(playAgain)
            playAgain.run(out)
            
        }
    }








