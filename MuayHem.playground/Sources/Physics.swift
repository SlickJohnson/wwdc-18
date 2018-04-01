import Foundation

public struct PhysicsCategory {
  static let none: UInt32 = 0
  static let player: UInt32 = 0b0001
  static let ground: UInt32 = 0b0010
  static let enemy: UInt32 = 0b0100
  static let playerField: UInt32 = 0b1000
}
