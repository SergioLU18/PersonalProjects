//
import SwiftUI
import SpriteKit
import GameplayKit
import FirebaseFirestore
import FirebaseFirestoreSwift

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
  return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }

  func normalized() -> CGPoint {
    return self / length()
  }
}

class GhostGameScene: SKScene, SKPhysicsContactDelegate {
    
    @AppStorage("ghostScore") var maxScore: Int = 0
    @AppStorage("localID") var localID: String = ""

  struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let monster   : UInt32 = 0b1       // 1
    static let projectile: UInt32 = 0b10      // 2
  }


  let player = SKSpriteNode(imageNamed: "player")
  var monstersDestroyed = 0
  let score = SKLabelNode(fontNamed: "Chalkduster")


  
    
  override func didMove(to view: SKView) {

    
    self.removeAllChildren()
    self.removeAllActions()
    
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    let background = SKSpriteNode(imageNamed: "WallpaperNinja")
    background.size = CGSize(width: 926, height: 444)
    background.zPosition = 1
    addChild(background)

    player.position = CGPoint(x: -350, y: 0.5)
    player.zPosition = 5
    player.scale(to: CGSize(width: 100, height: 100))
    addChild(player)

    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self

    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run(addMonster),
        SKAction.wait(forDuration: 1.0)
        ])
    ))

    score.fontSize = 30
    score.fontColor = SKColor.black
    score.position = CGPoint(x: 0.5, y: 0.5)
    score.zPosition = 2
    addChild(score)

  }

  func random() -> CGFloat {
    return CGFloat(Float(arc4random())  / 0xFFFFFFFF)
  }

  func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
  }

  func addMonster() {

    let monster = SKSpriteNode(imageNamed: "monster")

    monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
    monster.physicsBody?.isDynamic = true // 2
    monster.physicsBody?.categoryBitMask = PhysicsCategory.monster // 3
    monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
    monster.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
    monster.zPosition = 5

    let actualY = random(min: -160, max: 160)

    monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
    monster.scale(to: CGSize(width: 80, height: 80))

    addChild(monster)


    let actualDuration = random(min: CGFloat(3.0), max: CGFloat(6.0))


    let actionMove = SKAction.move(to: CGPoint(x: -400, y: actualY), duration: TimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()
    let loseAction = SKAction.run() { [weak self] in
      guard let `self` = self else { return }
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        if(self.monstersDestroyed > self.maxScore) {
            self.maxScore = self.monstersDestroyed
            self.updateDB()
        }
      let gameOverScene = GhostGameOverScene(size: self.size, won: false) 
      self.view?.presentScene(gameOverScene, transition: reveal)
    }
    monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    guard let touch = touches.first else {
      return
    }

    let touchLocation = touch.location(in: self)


    let projectile = SKSpriteNode(imageNamed: "projectile")
    projectile.position = player.position

    projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
    projectile.physicsBody?.isDynamic = true
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    projectile.physicsBody?.usesPreciseCollisionDetection = true
    projectile.scale(to: CGSize(width: 40, height: 40))
    projectile.zPosition = 5

    let offset = touchLocation - projectile.position


    if offset.x < 0 { return }


    addChild(projectile)


    let direction = offset.normalized()


    let shootAmount = direction * 1000


    let realDest = shootAmount + projectile.position


    let actionMove = SKAction.move(to: realDest, duration: 2.0)
    let actionMoveDone = SKAction.removeFromParent()
    projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
  }

  func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
    //print("Hit")
    projectile.removeFromParent()
    monster.removeFromParent()

    monstersDestroyed += 1
    score.text = String(monstersDestroyed)
//    if monstersDestroyed > 30 {
//      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//      let gameOverScene = GhostGameOverScene(size: self.size, won: true)
//      view?.presentScene(gameOverScene, transition: reveal)
//    }
  }

    func updateDB() {
        let db = Firestore.firestore()
        let userRef = db.collection("GhostAttack").document(self.localID)
        userRef.setData(["score": self.maxScore]) { error in
            if error == nil {
                print("Se actualizo el score")
            }
            else {
                print("no se actualizo el score")
            }
        }
    }
    
  func didBegin(_ contact: SKPhysicsContact) {

    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
    } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
    }


    if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
    (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
      if let monster = firstBody.node as? SKSpriteNode,
          let projectile = secondBody.node as? SKSpriteNode {
          projectileDidCollideWithMonster(projectile: projectile, monster: monster)
      }
    }
  }
}
