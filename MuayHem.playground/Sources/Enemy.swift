import Foundation
import SpriteKit

public class Enemy: SKSpriteNode {
  /// The number of hits remaining to destroy the enemy.
  var hitPoints: CGFloat = 0 {
    didSet {
      run(SKAction.scale(to: originalSize.width / hitPoints, duration: 0.2))
      if hitPoints <= 0 {
        removeFromParent()
      }
    }
  }
  /// The original size of the enemy before taking damage.
  var originalSize: CGSize!

  public init(size: CGSize, position: CGPoint) {
    super.init(texture: nil, color: .orange, size: size)
    self.position = position
    originalSize = size
    hitPoints = size.width
    // Configure SKPhysicsBody
    physicsBody = SKPhysicsBody(rectangleOf: size)
    physicsBody!.affectedByGravity = false
    physicsBody!.categoryBitMask = PhysicsCategory.enemy
    physicsBody!.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.enemy | PhysicsCategory.player
    physicsBody!.contactTestBitMask = PhysicsCategory.player
    physicsBody!.usesPreciseCollisionDetection = true
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Enemy actions
public extension Enemy {
  /// Damages the enemy by the given amount
  ///
  /// - Parameters:
  ///     - amount: Int of amount of hitPoints the enemy will lose.
  ///     - isDestroyed: Callback that gives a bool that tracks whether or not the enemy is now destroyed.
  public func damage(_ amount: CGFloat, isDestroyed: (Bool) -> Void) {
    hitPoints -= amount
    isDestroyed(hitPoints <= 0)
  }
}
