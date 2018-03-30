import Foundation
import SpriteKit

public class GameScene: SKScene {
  /// The SKShapeNode that represents the ground at the bottom of game screen.
  var ground: SKShapeNode!
  /// The SKShapeNode that represents the player and responds to touch events.
  var player: SKShapeNode!
  // The multiplier that will be applied to player's gravity to create "heaviness".
  let fallMultiplier: CGFloat = 1.3
  // The multiplier that will be applied to player's gravity to elongate player jump.
  let lowJumpMultiplier: CGFloat = 1.0425
  // Bool that keeps track of whether or not a finger is touching the screen.
  var touchDown: Bool = false

  public init(size: CGSize, color: SKColor) {
    super.init(size: size)
    backgroundColor = color
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

// MARK: - Helper methodsbefore
private extension GameScene {
  // MARK: Setup
  /// Configure the game scene with a ground and player.
  func setupScene() {
    makeGround()
    makePlayer()
  }

  /// Creates and adds the SKShapeNode for the ground.
  func makeGround() {
    let groundSize = CGSize(width: size.width, height: 40)
    let groundCenter = CGPoint(x: groundSize.width / 2, y: groundSize.height / 2)
    ground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: groundSize.width, height: groundSize.height))
    ground.fillColor = .black
    ground.strokeColor = .black
    // Configure SKPhysicsBody
    let physicsBody = SKPhysicsBody(rectangleOf: groundSize, center: groundCenter)
    physicsBody.isDynamic = false
    physicsBody.categoryBitMask = 1
    physicsBody.collisionBitMask = 0
    ground.physicsBody = physicsBody
    addChild(ground)
  }

  /// Creates and adds the SKShapeNode for the player.
  func makePlayer() {
    // Create the SKShapeNode
    let playerRadius: CGFloat = 20
    player = SKShapeNode(circleOfRadius: playerRadius)
    player.position = CGPoint(x: size.width / 2, y: size.height / 2)
    player.fillColor = .red
    player.strokeColor = .red
    // Configure SKPhysicsBody
    let physicsBody = SKPhysicsBody(circleOfRadius: playerRadius)
    physicsBody.affectedByGravity = true
    physicsBody.categoryBitMask = 0
    physicsBody.collisionBitMask = 1
    player.physicsBody = physicsBody

    addChild(player)
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

// MARK: - Game controls
public extension GameScene {
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let touchLocation = touch.location(in: self)
    touchDown = true
    // Calculate angle between player and finger.
    let dx = touchLocation.x - player.position.x
    let dy = touchLocation.y - player.position.y
    //    let angle = atan2(dy, dx)
    //    let vx = cos(angle) * 10000
    //    let vy = sin(angle) * 10000
    let jumpVector = CGVector(dx: dx * 15, dy: dy * 15)
    guard let playerPhysicsBody = player.physicsBody else { return }
    guard playerPhysicsBody.velocity.dy >= 0 else { return }
    playerPhysicsBody.applyForce(jumpVector)
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchDown = false
  }
}
