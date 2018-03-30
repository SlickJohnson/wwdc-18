//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

// Load the GameScene
let view = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = GameScene(size: view.bounds.size, color: .gray)

// Present the scene
view.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = view
