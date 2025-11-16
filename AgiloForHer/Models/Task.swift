import Foundation
import SwiftUI

struct Task: Identifiable {
 let id = UUID()
 let title: String
 let createdDate: Date
 var isCompleted: Bool = false
 var taskColor: String = "purple" // Color name as string
 var taskSymbol: String = "checkmark" // SF Symbol name

 init(title: String) {
  self.title = title
  self.createdDate = Date()
 }

 func getTaskColor() -> Color {
  switch taskColor {
  case "purple": return .myPurple
  case "orange": return .orange
  case "blue": return .blue
  case "green": return .myGreen
  case "red": return .myRed
  case "pink": return .pink
  case "cyan": return .cyan
  case "yellow": return .yellow
  default: return .myPurple
  }
 }
}
