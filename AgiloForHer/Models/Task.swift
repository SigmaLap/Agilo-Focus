import Foundation
import SwiftUI
import SwiftData

@Model
final class Task: Identifiable {
 var id = UUID()
 var title: String
 var createdDate: Date
 var isCompleted: Bool = false
 var hasSubtasks: Bool = false
 var taskColor: String = "purple"
 var taskSymbol: String = "checkmark"
 var energyCost: Int = 25
 var subTasks: [SubTask] = []

 init(
  title: String,
  createdDate: Date = Date(),
  isCompleted: Bool = false,
  hasSubtasks: Bool = false,
  taskColor: String = "purple",
  taskSymbol: String = "checkmark",
  energyCost: Int = 25,
  subTasks: [SubTask] = []
 ) {
  self.title = title
  self.createdDate = createdDate
  self.isCompleted = isCompleted
  self.hasSubtasks = hasSubtasks
  self.taskColor = taskColor
  self.taskSymbol = taskSymbol
  self.energyCost = energyCost
  self.subTasks = subTasks
 }

 var completedSubTasksCount: Int {
  subTasks.filter { $0.isCompleted }.count
 }
}


@Model
final class SubTask: Identifiable {
 var id = UUID()
 var title: String
 var isCompleted: Bool = false
 var energyCost: Int = 5

 init(title: String, isCompleted: Bool = false, energyCost: Int = 5) {
  self.id = UUID()
  self.title = title
  self.isCompleted = isCompleted
  self.energyCost = energyCost
 }
}

@Model
final class DailyEnergy: Identifiable {
 var id = UUID()
 var date: Date
 var energyCeiling: Int

 init(date: Date = Date(), energyCeiling: Int = 100) {
  self.id = UUID()
  self.date = date
  self.energyCeiling = energyCeiling
 }
}
