import Foundation
import SpriteKit

public class GameScene: SKScene {
  /// The SKShapeNode that represents the ground at the bottom of game screen.
  var ground: SKShapeNode!

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
    // Called before each frame is rendered
  }
}

// MARK: - Helper methodsbefore
private extension GameScene {
  /// Configure the game scene with a ground and player.
  func setupScene() {
    let groundSize = CGSize(width: size.width, height: 40)
    ground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: groundSize.width, height: groundSize.height))
    ground.fillColor = .black
    addChild(ground)
  }
}

// MARK: - Game controls
public extension GameScene {
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
  }
}
