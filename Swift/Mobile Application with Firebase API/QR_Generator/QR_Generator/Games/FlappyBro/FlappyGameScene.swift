//
//  GameScene.swift
//  Flappy
//
//  Created by javier banegas on 1/11/21.
//
import SwiftUI
import SpriteKit
import GameplayKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Physics{
    static let Character : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score: UInt32 = 0x1 << 4
}

var SilenceSFX = false
var SilenceMusic = false


class FlappyGameScene: SKScene, SKPhysicsContactDelegate {
    
    @AppStorage("localID") var localID: String = ""
    @AppStorage("flappyScore") var MaxScore: Int = 0;
    
    var Ground = SKSpriteNode()
    var Character = SKSpriteNode()
    var walls = SKNode()
    var wallActions = SKAction()
    var started = Bool()
    var Streak = Int()
    var Label = SKLabelNode()
    var Lost = Bool()
    var Restart = SKSpriteNode()
    var Over = SKSpriteNode()
    var Sky = SKSpriteNode()
    var BG = SKSpriteNode()
    var NewMax = SKLabelNode()
    var Max = SKLabelNode()
    var StartLabel = SKLabelNode()
    var playedSound = Bool()
    var muteMusic = SKSpriteNode()
    var muteSFX = SKSpriteNode()
    let texture = SKTexture(imageNamed: "FlappyDragonJump")
    let texture2 = SKTexture(imageNamed: "FlappyDragon")
    
    //var song =
    
    func restartScene(){
//        if Streak > MaxScore{
//            MaxScore = Streak
//            updateDB()
//        }
        self.removeAllActions()
        self.removeAllChildren()
        Lost = false
        started = false
        playedSound = false
        Streak = 0
        Label.fontColor = UIColor.white
        parallaxScroll(image: "MedivalBackground", y: 0, z: 1, duration: 50, needsPhysics: false)
        createScene()
        
    }
    func createLabel(){
        StartLabel = SKLabelNode()
        StartLabel.text = "CLICK TO START"
        StartLabel.fontColor = UIColor.systemGreen
        StartLabel.fontSize = 45
        StartLabel.zPosition = 8
        StartLabel.fontName = "HelveticaNueu-Bold"
        StartLabel.position = CGPoint(x: 0, y: 150)
        self.addChild(StartLabel)
    }
    func createScene(){
        self.physicsWorld.contactDelegate = self
        
        Label.position = CGPoint(x: 0, y: 320)
        Label.text = "\(Streak)"
        Label.fontName = "HelveticaNeue-Bold"
        Label.zPosition = 4
        Label.fontSize = 60
        self.addChild(Label)
        
        
        
        Ground = SKSpriteNode(imageNamed: "stone wall-1")
        
        Ground.setScale(0.6)
        Ground.position = CGPoint(x: 0 , y: -400)
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = Physics.Ground
        Ground.physicsBody?.collisionBitMask = Physics.Character
        Ground.physicsBody?.contactTestBitMask = Physics.Character
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        self.addChild(Ground)
        
        Character = SKSpriteNode(imageNamed: "FlappyDragon")
        Character.size = CGSize(width: 150.68, height: 180.8)
        //Character.position = CGPoint(x: self.frame.width / 2 - 500 , y:-100)
        Character.position = CGPoint(x: -155 , y: 0.5)
        Character.physicsBody = SKPhysicsBody(circleOfRadius: 37)
        Character.physicsBody?.categoryBitMask = Physics.Character
        Character.physicsBody?.collisionBitMask = Physics.Ground | Physics.Wall
        Character.physicsBody?.contactTestBitMask = Physics.Ground | Physics.Wall | Physics.Score
        Character.physicsBody?.affectedByGravity = false
        Character.physicsBody?.isDynamic = true
        Character.zPosition = 2
        self.addChild(Character)
        
        parallaxScroll(image: "MedivalBackground", y: 0, z: 1, duration: 50, needsPhysics: false)
      
        
        
        BG = SKSpriteNode(imageNamed: "Blue")
        BG.size = CGSize(width: 3000, height: 3000)
        BG.position = CGPoint(x: 0, y: 0)
        BG.zPosition = 0
        self.addChild(BG)
        
       
        
        if started == false{
            createLabel()
        }
    }
    
    override func didMove(to view: SKView) {
        self.removeAllActions()
        self.removeAllChildren()
        
        createScene()
    }
    
    func playMusic(){
            
            playM(name: "BGMusic")
    }
    
    func button(){
        let fadein = SKAction.fadeIn(withDuration: 2.0)
        let wait = SKAction.wait(forDuration: 1.0)
        let fadeout = SKAction.fadeOut(withDuration: 2.0)
        let group = SKAction.group([fadein, wait, fadeout])
        
        NewMax = SKLabelNode()
        NewMax.fontName = "HelveticaNeue-Bold"
        NewMax.text = "NEW HIGH SCORE \(Streak)"
        NewMax.fontColor = UIColor.systemRed
        NewMax.fontSize = 32
        NewMax.position = CGPoint(x: 0, y: 0)
        NewMax.zPosition = 5
        
        Max = SKLabelNode()
        Max.fontName = "HelveticaNeue-Bold"
        Max.text = "HIGH SCORE \(MaxScore)"
        Max.fontColor = UIColor.black
        Max.fontSize = 32
        Max.position = CGPoint(x: 0, y: -100)
        Max.zPosition = 5
        
        Restart = SKSpriteNode(imageNamed: "fRestart")
        Restart.size = CGSize(width: 150, height: 75)
        Restart.position = CGPoint(x: 0, y: -200)
        Restart.zPosition = 5
       
        self.addChild(Restart)
        
        Over = SKSpriteNode(imageNamed: "gameOver2")
        Over.size = CGSize(width: 310, height: 230)
        Over.position = CGPoint(x: 0, y: 100)
        Over.zPosition = 5
       
        self.addChild(Over)
        
       
        if Streak > MaxScore{
            NewMax.run(group)
            self.addChild(NewMax)
        }else{
         
            self.addChild(Max)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == Physics.Score && secondBody.categoryBitMask == Physics.Character || firstBody.categoryBitMask == Physics.Character && secondBody.categoryBitMask == Physics.Score{
            
            Streak += 1
            Label.text = "\(Streak)"
            Label.fontSize = 60
        }
        if firstBody.categoryBitMask == Physics.Character && secondBody.categoryBitMask == Physics.Wall || firstBody.categoryBitMask == Physics.Wall && secondBody.categoryBitMask == Physics.Character{
            Lost = true
            music?.stop()
            button()
        }
        if firstBody.categoryBitMask == Physics.Character && secondBody.categoryBitMask == Physics.Ground || firstBody.categoryBitMask == Physics.Ground && secondBody.categoryBitMask == Physics.Character{
            Lost = true
            if(Streak > MaxScore) {
                MaxScore = Streak
                updateDB()
            }
            music?.stop()
            button()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if started == false{
            started = true
            Character.physicsBody?.affectedByGravity = true
            let spawn = SKAction.run({
                () in
                self.createWalls()
            })
            StartLabel.removeFromParent()
            let delay = SKAction.wait(forDuration: 1.5)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnF = SKAction.repeatForever(spawnDelay)
            self.run(spawnF)
            
            let dist = CGFloat(self.frame.width + walls.frame.width)
            let moveWalls = SKAction.moveBy(x: -dist, y: 0, duration: TimeInterval( 0.0038 * dist))
            let deleteWalls = SKAction.removeFromParent()
            
            wallActions = SKAction.sequence([moveWalls, deleteWalls])
            Character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 133))
 
            
           // let jumpAnimation = SKAction.setTexture(withdu)
            
            if SilenceMusic == false{
                playMusic()
            }
            let sequence = SKAction.sequence([

                SKAction.setTexture(texture),
                SKAction.wait(forDuration: 0.5),  //Wait between 1.0 and 4.0
                SKAction.setTexture(texture2),
                ])
            Character.run(sequence)
            
            
        }else{
            let sequence = SKAction.sequence([

                SKAction.setTexture(texture),
                SKAction.wait(forDuration: 0.3),  //Wait between 1.0 and 4.0
                SKAction.setTexture(texture2),
                ])
            Character.run(sequence)
            if Lost == true{
                
            }else{
                Character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                Character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 110))
            }
        }
        
        if Streak > MaxScore{
            Label.fontColor = UIColor.systemYellow
        }else{
            Label.fontColor = UIColor.white
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if Lost == true{
                if Restart.contains(location){
                    restartScene()
                }
                
            }
           
        }
        
    }
    func parallaxScroll(image: String, y: CGFloat, z: CGFloat, duration: Double, needsPhysics: Bool) {
        
        for i in 0 ... 1 {
            let node = SKSpriteNode(imageNamed: image)
            node.scale(to: CGSize(width:2048, height: MyVariables.height * 1.1))
            node.position = CGPoint(x: 2048 * CGFloat(i), y: y)
            node.zPosition = 1
            addChild(node)
            
        
            
            let move = SKAction.moveBy(x: -1024, y: 0, duration: duration)
            let wrap = SKAction.moveBy(x: 1024, y: 0, duration: 0)
            
            let sequence = SKAction.sequence([move, wrap])
            let forever = SKAction.repeatForever(sequence)
            node.run(forever)
            
        }
        
    }
    func createWalls(){
        let score = SKSpriteNode()
        score.size = CGSize(width: 1, height: 300)
        score.position = CGPoint(x: 250, y: 0)
        score.physicsBody = SKPhysicsBody(rectangleOf: score.size)
        score.physicsBody?.affectedByGravity = false
        score.physicsBody?.isDynamic = false
        score.physicsBody?.categoryBitMask = Physics.Score
        score.physicsBody?.collisionBitMask = 0
        score.physicsBody?.contactTestBitMask = Physics.Character
        
        
        walls = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "torre")
        
        let bottomWall = SKSpriteNode(imageNamed: "torre")
        
        topWall.position = CGPoint(x: 250, y: 520)
        
        bottomWall.position = CGPoint(x: 250 , y:-420)
        
        topWall.zRotation = CGFloat(M_PI)
        
        topWall.setScale(0.25)
        
        bottomWall.setScale(0.25)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = Physics.Wall
        topWall.physicsBody?.collisionBitMask = Physics.Character
        topWall.physicsBody?.contactTestBitMask = Physics.Character
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = Physics.Wall
        bottomWall.physicsBody?.collisionBitMask = Physics.Character
        bottomWall.physicsBody?.contactTestBitMask = Physics.Character
        bottomWall.physicsBody?.affectedByGravity = false
        bottomWall.physicsBody?.isDynamic = false

        
        
        walls.addChild(topWall)
        walls.addChild(bottomWall)
        walls.addChild(score)
        walls.zPosition = 1
        var randPos = CGFloat.random(min: -260, max: 260)
        walls.position.y = walls.position.y + randPos
        
        walls.run(wallActions)
        self.addChild(walls)
    }
    
    private func updateDB() {
        let db = Firestore.firestore()
        let userRef = db.collection("FlappyBro").document(self.localID)
        userRef.updateData(["score": self.MaxScore]) { error in
            if error == nil {
                print("Se actualizo el score")
            }
            else {
                print("no se actualizo el score")
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
