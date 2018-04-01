import Foundation

public struct PhysicsCategory {
  static let none: UInt32 = 0
  static let player: UInt32 = 0b001
  static let ground: UInt32 = 0b010
  static let dummy: UInt32 = 0b100
}
