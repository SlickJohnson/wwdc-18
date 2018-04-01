import Foundation
import SpriteKit

public class Player: SKSpriteNode {
  /// Keeps track of whether or not the player is jumping.
  var isJumping: Bool = false
  /// Keeps track of whether or not the player is attached to another body.
  var isAttached: Bool = false
  /// Keeps track of the joint the player is using to attach to an object.
  var joint: SKPhysicsJointPin? {
    didSet {
      isAttached = joint != nil
    }
  }

  public init(size: CGSize, position: CGPoint) {
    super.init(texture: nil, color: .red, size: size)
    self.position = position
    // Configure SKPhysicsBody
    physicsBody = SKPhysicsBody(rectangleOf: size)
    physicsBody!.affectedByGravity = true
    physicsBody!.categoryBitMask = PhysicsCategory.player
    physicsBody!.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.dummy
    physicsBody!.contactTestBitMask = PhysicsCategory.dummy
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Player actions
public extension Player {
  /// Applies a force to the player's physicsbody that propels it to the given CGPoint.
  ///
  /// - Parameter location: The CGPoint the player will attempt to jump towards.
  public func jump(to location: CGPoint) {
    guard let physicsBody = physicsBody else { return }
    // Calculate angle between player and finger.
    let dx = location.x - position.x
    let dy = location.y - position.y
    guard physicsBody.velocity.dy >= 0 else { return }
    let jumpVector = CGVector(dx: dx * 12, dy: dy * 12)
    physicsBody.applyForce(jumpVector)
  }

  /// Attacks the current node that the player is attached to.
  public func attack() {
    guard let joint = joint else { return }
    var target: SKNode!
    if joint.bodyA.node == self {
      target = joint.bodyB.node
    } else {
      target = joint.bodyA.node
    }
    target.removeFromParent()
  }
}
