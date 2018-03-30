import Foundation
import SpriteKit

public class GameScene: SKScene {
  public init(size: CGSize, color: SKColor) {
    super.init(size: size)
    backgroundColor = color
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

// MARK: - Game controls
public extension GameScene {
  public override func mouseDown(with event: NSEvent) {
    touchDown(atPoint: event.location(in: self))
  }

  public override func mouseDragged(with event: NSEvent) {
    touchMoved(toPoint: event.location(in: self))
  }

  public override func mouseUp(with event: NSEvent) {
    touchUp(atPoint: event.location(in: self))
  }
}

// MARK: - Touch handling
private extension GameScene {
  func touchDown(atPoint pos : CGPoint) {
  }

  func touchMoved(toPoint pos : CGPoint) {
  }

  func touchUp(atPoint pos : CGPoint) {
  }
}


