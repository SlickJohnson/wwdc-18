import Foundation
import SpriteKit

public class GameScene: SKScene {
  /// The SKShapeNode that represents the ground at the bottom of game screen.
  var ground: SKShapeNode!
  /// The SKShapeNode that represents the player and responds to touch events.
  var player: Player!
  /// The multiplier that will be applied to player's gravity to create "heaviness".
  let fallMultiplier: CGFloat = 1.3
  /// The multiplier that will be applied to player's gravity to elongate player jump.
  let lowJumpMultiplier: CGFloat = 1.0425
  /// Bool that keeps track of whether or not a finger is touching the screen.
  var touchDown: Bool = false
  /// The cam used to control the zoom levels.
  var cam: SKCameraNode!
  /// The camera's scale.
  var camScale: CGFloat = 2
  /// The object that acts as a dummy enemy in the game scene.
  var dummy: SKShapeNode!

  public init(size: CGSize, color: SKColor) {
    super.init(size: size)
    backgroundColor = color
    physicsWorld.contactDelegate = self
    setupScene()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("not implemented")
  }

  public override func didMove(to view: SKView) {
  }

  public override func update(_ currentTime: TimeInterval) {
    guard let playerPhysicsBody = player.physicsBody else { return }
    applyGravityMultipliers(to: playerPhysicsBody)
  }
}

// MARK: - Helper methods
private extension GameScene {
  // MARK: Setup
  /// Configure the game scene with a ground and player.
  func setupScene() {
    makeGround()
    makePlayer()
    makeDummy()
    setupCam()
  }

  /// Creates and adds the SKShapeNode for the ground.
  func makeGround() {
    let groundSize = CGSize(width: size.width * 1.3, height: 40)
    let groundCenter = CGPoint(x: groundSize.width / 2, y: groundSize.height / 2)
    ground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: groundSize.width, height: groundSize.height))
    ground.fillColor = .black
    ground.strokeColor = .black
    // Configure SKPhysicsBody
    let physicsBody = SKPhysicsBody(rectangleOf: groundSize, center: groundCenter)
    physicsBody.isDynamic = false
    physicsBody.categoryBitMask = PhysicsCategory.ground
    physicsBody.collisionBitMask = PhysicsCategory.player
    ground.physicsBody = physicsBody
    addChild(ground)
  }

  /// Creates and adds the SKShapeNode for the player.
  func makePlayer() {
    player = Player(size: CGSize(width: 40, height: 40), position: CGPoint(x: size.width / 2, y: size.height / 2))
    addChild(player)
  }

  /// Creates the dummy objects to test player attaching mechanic.
  func makeDummy() {
    dummy = SKShapeNode(rect: CGRect(x: -40, y: -40, width: 80, height: 80 ))
    dummy.fillColor = .orange
    let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 80))
    physicsBody.categoryBitMask = PhysicsCategory.dummy
    physicsBody.collisionBitMask = PhysicsCategory.player
    physicsBody.contactTestBitMask = PhysicsCategory.player
    physicsBody.affectedByGravity = false
    dummy.physicsBody = physicsBody
    addChild(dummy)
    dummy.position = CGPoint(x: size.width / 2, y: size.height / 1.25)
  }

  func setupCam() {
    cam = SKCameraNode()
    cam.position = CGPoint(x: size.width / 2, y: size.height / 2)
    self.camera = cam
    cam.setScale(camScale)
    addChild(cam)
  }

  // MARK: Game play
  /// Applies an impulse to an SKPhysicsBody to influence it's trajectory.
  ///
  /// - Parameter physicsBody: The SKPhysicsBody who's projectile trajectory will be influenced.
  func applyGravityMultipliers(to physicsBody: SKPhysicsBody) {
    if physicsBody.velocity.dy < 0 {
      physicsBody.applyImpulse(CGVector(dx: 0, dy: physicsWorld.gravity.dy * (fallMultiplier - 1)))
    } else if physicsBody.velocity.dy > 0 {
      physicsBody.applyImpulse(CGVector(dx: 0, dy: physicsWorld.gravity.dy * (lowJumpMultiplier - 1)))
    }
  }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
  public func didBegin(_ contact: SKPhysicsContact) {
    let bodyA = contact.bodyA
    let bodyB = contact.bodyB
    let collision = bodyA.categoryBitMask | bodyB.categoryBitMask

    switch collision {
    case PhysicsCategory.player | PhysicsCategory.dummy:
      let pinJoint = SKPhysicsJointPin.joint(withBodyA: bodyA, bodyB: bodyB, anchor: contact.contactPoint)
      scene?.physicsWorld.add(pinJoint)
      player.joint = pinJoint
    default:
      print("Hit something else")
    }
  }

  public func didEnd(_ contact: SKPhysicsContact) {
    let bodyA = contact.bodyA
    let bodyB = contact.bodyB
    let seperation = bodyA.categoryBitMask | bodyB.categoryBitMask

    switch seperation {
    case PhysicsCategory.player | PhysicsCategory.dummy:
      guard let playerJoint = player.joint else { return }
      scene?.physicsWorld.remove(playerJoint)
      player.joint = nil
    default:
      print("Hit something else")
    }
  }
}

// MARK: - Game controls
public extension GameScene {
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let touchLocation = touch.location(in: self)
    touchDown = true
    player.jump(to: touchLocation)
    if player.isAttached {
      player.attack()
    }
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = false
  }
}
