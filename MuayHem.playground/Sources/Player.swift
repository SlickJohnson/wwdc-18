import Foundation
import SpriteKit

public class Player: SKSpriteNode {
  /// Keeps track of whether or not the player is jumping.
  var isJumping: Bool = false
  /// Keeps track of whether or not the player is attached to another body.
  var isAttached: Bool = false
  /// The amount of force the player uses to jump around.
  var jumpForce: CGFloat = 4200
  var angleForce: CGFloat = 0.5
  /// The amount of force the player uses to attack an enemy.
  var attackForce: CGFloat = 100
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
    physicsBody!.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.enemy
    physicsBody!.contactTestBitMask = PhysicsCategory.enemy
    physicsBody!.usesPreciseCollisionDetection = true
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
  public func jump(to location: CGPoint, multiplier: CGFloat = 1) {
    guard let physicsBody = physicsBody else { return }
    // Calculate angle between player and finger.
    let dx = location.x - position.x
    let dy = location.y - position.y
    let angle = atan2(dy, dx)
    let jumpVeloctiyX = cos(angle) * jumpForce * multiplier
    let jumpVelocityY = sin(angle) * jumpForce * multiplier
    let jumpVector = CGVector(dx: jumpVeloctiyX, dy: jumpVelocityY)
    let angularVeloicty = -cos(angle) * 0.01
    physicsBody.applyForce(jumpVector)
    physicsBody.applyAngularImpulse(angularVeloicty)
  }

  /// Attacks the current node that the player is attached to.
  ///
  /// - Parameter location: The direction the player will move after target is destroyed.
  public func attack(_ touchLocation: CGPoint, hasPlayerDestroyedTarget: (Bool) -> ()) {
    guard let joint = joint else { return }
    guard let physicsBody = physicsBody else { return }
    // Grab the enemy node
    var target = joint.bodyB.node as? Enemy
    if target == nil {
      target = joint.bodyA.node as? Enemy
    }
    // Launch player in direction of tap once enemy is destroyed
    target?.damage(size.width) { isEnemyDestroyed in
      let dx = touchLocation.x - position.x
      let dy = touchLocation.y - position.y
      let angle = atan2(dy, dx)
      let attackVelocityX = cos(angle) * attackForce
      let attackVeloctyY = sin(angle) * attackForce
      let attackImpulseVector = CGVector(dx: attackVelocityX, dy: attackVeloctyY)
      if isEnemyDestroyed {
        attackForce = 120
      }
      physicsBody.applyImpulse(attackImpulseVector)
      hasPlayerDestroyedTarget(isEnemyDestroyed)
    }
  }
}
