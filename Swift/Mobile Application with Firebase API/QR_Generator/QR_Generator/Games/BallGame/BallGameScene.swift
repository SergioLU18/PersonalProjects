//
//  GameScene.swift
//  App09-Game
//
//  Created by Alumno on 01/11/21.
//


import SwiftUI
import SpriteKit
import GameplayKit

class BallGameScene: SKScene, SKPhysicsContactDelegate {
    // var window = UIWindow(frame: UIScreen.main.bounds)
    let ball = SKSpriteNode(imageNamed: "balon")
    let basket = SKSpriteNode(imageNamed: "canasta")
    let aro = SKSpriteNode(imageNamed: "aro")
    let restart =  SKSpriteNode(imageNamed: "restart")
    var planeTouched = false
    var started = false
    var remainingTime = 0
    var hasGone = false
    var isGamerunning = true
    var pointed = false
    var tiempoExtra = false
    var tiempoMas = 15
    var startTime = 0.0
    let timeLabel = SKLabelNode(fontNamed: "Open 24 Display St")
    var gameStartTime: TimeInterval?
    var originalBallPos: CGPoint!
    var width = CGFloat()
    var height = CGFloat()
    @Binding var currentScore: Int
    
    
    
    init(_ score: Binding<Int>) {
        _currentScore = score
        super.init(size: CGSize(width: MyVariables.height, height: MyVariables.width))
        self.scaleMode = .fill
    }
    
    required init?(coder aDecoder: NSCoder) {
        _currentScore = .constant(0)
        super.init(coder: aDecoder)
    }
    
    
    override func didMove(to view: SKView) {
        
        self.removeAllActions()
        self.removeAllChildren()
        //        let background = SKSpriteNode(imageNamed: "sky")
        //        background.size = CGSize(width: 926, height: 444)
        //        background.zPosition = 0
        //        addChild(background)
        
        //---------------------Declaración canasta------------------------
        
        width    = MyVariables.height
        height   = MyVariables.width
        
        basket.zPosition = 5
        basket.position = CGPoint(x: 0.36*width, y: -0.0221 * height)
        basket.scale(to: CGSize(width: 0.30 * width, height: 0.30 * width))
        basket.name = "basket"
        addChild(basket)
        print (width)
        print(height)
        //--------------------Declaración aro---------------------------
        aro.zPosition = 5
        aro.position = CGPoint(x: 0.316*width, y: 0.0199*height) // 286 9
        aro.scale(to: CGSize(width: 0.291*width, height: 0.30*width))
        addChild(aro)
        aro.physicsBody = SKPhysicsBody(texture: aro.texture!, size: CGSize(width: 0.291*width, height: 0.30*width))
        aro.physicsBody?.isDynamic = false
        aro.physicsBody?.contactTestBitMask = 1
        aro.physicsBody?.linearDamping = 0
        aro.name = "aro"
        
        //-------------------Declaración balón-----------------------
        ball.zPosition = 5
        ball.position = CGPoint(x: -0.37 * width, y: -0.22 * height)
        ball.scale(to: CGSize(width: 0.0648*width, height: 0.0432*width))
        ball.name = "ball"
        addChild(ball)
        
        originalBallPos = ball.position
        
        ball.physicsBody = SKPhysicsBody(texture: ball.texture!, size: CGSize(width: 0.0648*width, height: 0.0432*width))
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.affectedByGravity = false
        //------------------Declaración ambiente-------------------
        
        timeLabel.position = CGPoint(x: 0.019*width, y: 0.19 * height)
        timeLabel.horizontalAlignmentMode = .right
        timeLabel.zPosition = 1
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        let background = SKSpriteNode(imageNamed: "cancha")
        background.name = "background"
        background.zPosition = 0
        background.size = CGSize(width: width , height: height) //926  452
       
        addChild(background)
        background.addChild(timeLabel)
        
        // parallaxScroll(image: "ground", y: -180, z: 5, duration: 6, needsPhysics: true)
        
        physicsWorld.contactDelegate = self
        
        // timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createObstacle), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == ball {
                                print("Plane Touched")
                                ball.position = touchLocation
                                planeTouched = true
                                started = true
                                
                            }
                        }
                    }
                }
            }
        }
        if isGamerunning == false{
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == restart {
                                print("restarted")
                                DispatchQueue.main.asyncAfter(deadline: .now() ) {
                                    
                                   let scene = BallGameScene(self.$currentScore)
                                    let transition = SKTransition.fade(withDuration: 3)
                                    scene.scaleMode = .aspectFit
                                    scene.size = CGSize(width: self.width, height: self.height)
                                    scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                                    self.view?.presentScene(scene, transition: transition)
                                }
                                
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //        guard planeTouched else { return }
        //        guard let touch = touches.first else { return }
        //
        //        let location = touch.location(in: self)
        //        plane.position = locationf
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == ball {
                                // MARK: Made duck snap back to its original position when it has been dragged further than the mid-X point to prevent the user from cheating (and dragging the duck around so it hits the boxes)!
                                
                                ball.position = touchLocation
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        planeTouched = false
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == ball {
                                let dx = -(touchLocation.x - originalBallPos.x)
                                let dy = -(touchLocation.y - originalBallPos.y)
                                let impulse = CGVector(dx: dx/4, dy: dy/4)
                                
                                ball.physicsBody?.applyImpulse(impulse)
                                ball.physicsBody?.applyAngularImpulse(-0.01)
                                ball.physicsBody?.affectedByGravity = true
                                
                                hasGone = true
                                pointed = false
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // print(ball.physicsBody?.velocity.dx,ball.physicsBody?.velocity.dy)
        if started {
            
            if startTime == 0 {
                startTime = currentTime
            }
            
            let timePassed = currentTime - startTime
            
            if tiempoExtra {
                tiempoMas+=5
                tiempoExtra = false
                
            }
            
            remainingTime = Int(ceil(Double(tiempoMas) - timePassed))
            if remainingTime < 10{
                timeLabel.position = CGPoint(x: 0.015*width, y: 0.18805*height)
            }else{
                timeLabel.position = CGPoint(x: 0.019*width, y: 0.18805*height)
            }
            timeLabel.text = "\(remainingTime)"
            timeLabel.alpha = 1
            if remainingTime <= 0 {
                let finalFrame = SKSpriteNode(imageNamed: "marco")
                finalFrame.scale(to:CGSize(width: 0.27*width, height: 0.885*height))
                finalFrame.position = CGPoint(x:-0.29*width,y:0) // 926 452
                finalFrame.zPosition = 10
                finalFrame.alpha = 0
                
                let finalScore = SKLabelNode()
                finalScore.position = CGPoint(x:-0.28*width,y:0.11*height)
                finalScore.zPosition = 15
                finalScore.fontSize = 17
                finalScore.fontColor = UIColor.black
                finalScore.fontName = "PWScolarpaper"
                finalScore.text = "Puntaje Final \(currentScore)"
                finalScore.alpha = 0
                
                let maxScore = SKLabelNode()
                maxScore.position = CGPoint(x:-0.28*width,y:-0.085*height)
                maxScore.zPosition = 15
                
                maxScore.fontSize = 17
                maxScore.fontColor = UIColor.black
                maxScore.fontName = "PWScolarpaper"
                maxScore.text = "Puntaje mas alto \(currentScore)"
                maxScore.alpha = 0
                
                
                isGamerunning = false
                
                
                restart.zPosition = 11
                restart.position = CGPoint(x:0.324*width,y:0)
                restart.name = "restart"
                restart.alpha = 0
                restart.scale(to: CGSize(width: 0.22*width, height: 0.22*width))
                let gameOver = SKSpriteNode(imageNamed: "game-over-1")
                gameOver.zPosition = 10
                gameOver.alpha = 0;
                
                let out = SKAction.fadeIn(withDuration: 2)
                
                addChild(restart)
                addChild(maxScore)
                addChild(finalScore)
                addChild(finalFrame)
                addChild(gameOver)
                
                gameOver.run(out)
                restart.run(out)
                maxScore.run(out)
                finalScore.run(out)
                finalFrame.run(out)
                
                ball.removeFromParent()
                currentScore = 0
                started = false
                timeLabel.text = "0"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    
                    
                    
                    
                }
            }else{
                
                if let ballPhysicsBody = ball.physicsBody {
                    if ballPhysicsBody.velocity.dx <= 0.01 && ballPhysicsBody.velocity.dy <= 100  && ballPhysicsBody.angularVelocity <= 0.01 && hasGone{
                        print ("reset")
                        ball.physicsBody?.affectedByGravity = false
                        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        ball.physicsBody?.angularVelocity = 0
                        ball.zRotation = 0
                        ball.position = originalBallPos
                        pointed = false
                        hasGone = false
                        
                        
                        // 3: When you reset, loop through the boxes and set them to its original position, rotation and velocity
                        
                        
                    }
                }
                if ball.position.y > 190 {
                    let dy = -((ball.physicsBody?.velocity.dy)!)
                    let dx = ((ball.physicsBody?.velocity.dx)!)
                    ball.physicsBody?.velocity = CGVector(dx : dx, dy: dy )
                    ball.position.y = 190
                    
                }
                if ball.position.y < -190 {
                    let dy = -((ball.physicsBody?.velocity.dy)!)
                    let dx = ((ball.physicsBody?.velocity.dx)!)
                    ball.physicsBody?.velocity = CGVector(dx : dx, dy: dy )
                    ball.position.y = -190
                    
                }
                if ball.position.x < -height{
                    let dy = ((ball.physicsBody?.velocity.dy)!)
                    let dx = -((ball.physicsBody?.velocity.dx)!)
                    ball.physicsBody?.velocity = CGVector(dx : dx, dy: dy )
                    ball.physicsBody?.angularVelocity = 0
                    ball.position.x = -height
                }
                if ball.position.x > height {
                    let dy = ((ball.physicsBody?.velocity.dy)!)
                    let dx = -((ball.physicsBody?.velocity.dx)!)
                    ball.physicsBody?.velocity = CGVector(dx : dx, dy: dy )
                    ball.position.x = height
                }
            }
            
            
        } else {
            
            timeLabel.alpha = 0
            
            
        }
        
    }
    
    
    
    func planeHit(_ node: SKNode) {
        
        if node.name == "aro" {
            if let explosion = SKEmitterNode(fileNamed: "planeExplosion") {
                explosion.position = aro.position
                explosion.zPosition = 10
                addChild(explosion)
                
            }
            
            //            run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
            if pointed == false {
                currentScore += 1
                print(currentScore)
                tiempoExtra = true
                // startTime += 5
                pointed = true;
            }
            ball.removeFromParent()
            ball.zPosition = 5
            ball.position = CGPoint(x: -0.37*width, y: -0.221*height)
            ball.scale(to: CGSize(width: 0.0648*width, height: 0.042*width))
            ball.name = "ball"
            addChild(ball)
            
            originalBallPos = ball.position
            
            ball.physicsBody = SKPhysicsBody(texture: ball.texture!, size: CGSize(width: 60, height: 40))
            ball.physicsBody?.categoryBitMask = 1
            ball.physicsBody?.collisionBitMask = 0
            ball.physicsBody?.affectedByGravity = false
            hasGone = false
            //            music.removeFromParent()
            
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //                let scene = GameScene(self.$currentScore)
            //                scene.scaleMode = .aspectFit
            //                scene.size = CGSize(width: 926, height: 444)
            //                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            //                self.view?.presentScene(scene)
            //
            //            }
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        print("hit")
        if nodeA == ball {
            planeHit(nodeB)
        } else {
            planeHit(nodeA)
        }
        
    }
    
    
}
