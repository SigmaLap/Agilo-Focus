import SwiftUI
import SwiftData

struct TaskDetailsView: View {
 @Environment(\.taskManager) var taskManager
 @Environment(\.modelContext) var modelContext
 @State private var taskTitle = ""
 @State private var taskColor: String = "purple"
 @State private var taskSymbol: String = "checkmark"

 @Binding var isPresented: Bool
 let taskText: String
 @Environment(\.dismiss) private var dismiss
 @State private var subTasks: [SubTask] = []
 @State private var storyPoints: Int = 25
 @State private var showStoryPointsInfo: Bool = false
 @State private var showStoryPointsPicker: Bool = false
 @State private var showMoreOptions: Bool = false
 @State private var showColorSymbolPicker: Bool = false

 private let availableColors = ["purple", "orange", "blue", "green", "red", "pink", "cyan", "yellow"]
 private let commonSymbols = ["checkmark", "star.fill", "bolt.fill", "flame.fill", "heart.fill", "sparkles", "target", "gift.fill", "lightbulb.fill", "crown.fill"]

 private func getColorValue(_ colorName: String) -> Color {
  switch colorName {
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

 // MARK: - SubTask Helper Methods

 private var totalSubTaskEnergy: Int {
  subTasks.reduce(0) { $0 + $1.energyCost }
 }

 private var remainingEnergy: Int {
  max(0, storyPoints - totalSubTaskEnergy)
 }

 private var canAddMoreSubTasks: Bool {
  remainingEnergy > 0
 }

 private func addSubTask() {
  if canAddMoreSubTasks {
   let newSubTask = SubTask(
    title: "",
    isCompleted: false,
    energyCost: min(5, remainingEnergy)
   )
   subTasks.append(newSubTask)
  }
 }

 private func removeSubTask(at offsets: IndexSet) {
  subTasks.remove(atOffsets: offsets)
 }

 private func updateSubTaskEnergy(index: Int, newEnergy: Int) {
  if index >= 0 && index < subTasks.count {
   let currentEnergy = subTasks[index].energyCost
   let difference = newEnergy - currentEnergy

   if difference <= remainingEnergy {
    subTasks[index].energyCost = newEnergy
   }
  }
 }

 private func toggleSubTaskCompletion(index: Int) {
  if index >= 0 && index < subTasks.count {
   subTasks[index].isCompleted.toggle()
  }
 }

 // MARK: - Main Body

 var body: some View {
  NavigationStack {
   Form {
    titleSection
    storyPointsSection
    moreOptionsToggle

    if showMoreOptions {
     subtasksSection
    }
   }
   .padding(.top, -25)
   .listSectionSpacing(12)
   .navigationTitle("Add task")
   .navigationBarBackButtonHidden()
   .navigationBarTitleDisplayMode(.inline)
   .background(Color("background"))
   .onAppear {
    if taskTitle.isEmpty && !taskText.isEmpty {
     taskTitle = taskText
    }
    taskManager.modelContext = modelContext
   }
   .toolbar {
    ToolbarItem(placement: .topBarLeading) {
     Button(role: .cancel) {
      dismiss()
     }
    }
    ToolbarItem(placement: .topBarTrailing) {
     Button {
      saveTask()
     } label: {
      Image(systemName: "checkmark")
       .fontWeight(.semibold)
     }
     .disabled(taskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
    }
   }
   .sheet(isPresented: $showColorSymbolPicker) {
    ColorSymbolPickerView(taskColor: $taskColor, taskSymbol: $taskSymbol)
   }
  }
 }

 // MARK: - Section Views

 private var titleSection: some View {
  Section {
   HStack {
    ZStack(alignment: .leading) {
     if taskTitle.isEmpty {
      HStack {
       Text("Task title")
        .font(.title3)
        .fontDesign(.serif)
        .fontWeight(.ultraLight)
       Image(systemName: "pencil.line")
      }
      .foregroundColor(.gray)
     }

     TextField("", text: $taskTitle, axis: .vertical)
    }

    Spacer()
    Button(action: { showColorSymbolPicker = true }) {
     ZStack {
      Circle()
       .fill(getColorValue(taskColor))
       .frame(width: 38, height: 38)

      Image(systemName: taskSymbol)
       .font(.body.weight(.semibold))
       .foregroundColor(.white)
     }
    }
    .buttonStyle(.plain)
   }
  }
 }

 private var storyPointsSection: some View {
  Section {
   HStack {
    Button {
     showStoryPointsInfo = true
    } label: {
     Image(systemName: "info.circle")
      .imageScale(.small)
      .foregroundStyle(.secondary)
    }
    .buttonStyle(.plain)
    .sheet(isPresented: $showStoryPointsInfo) {
     storyPointsInfoSheet
    }

    Text("Story Points")
     .font(.headline)
    Spacer()

    Button {
     showStoryPointsPicker = true
    } label: {
     HStack(spacing: 6) {
      Image(systemName: "number")
      Text("\(storyPoints)")
       .font(.headline)
       .bold()
     }
     .foregroundStyle(.textPrimary)
     .padding(.horizontal, 14)
     .padding(.vertical, 7)
     .glassEffect(.regular.interactive())
    }
    .buttonStyle(.plain)
    .sheet(isPresented: $showStoryPointsPicker) {
     storyPointsPickerSheet
    }
   }
  }
  .listRowSeparator(.hidden)
 }

 private var moreOptionsToggle: some View {
  Section {
   Toggle("More", isOn: $showMoreOptions)
    .font(.headline)
    .tint(.accentColor)
  }
  .listRowSeparator(.hidden)
 }

 private var subtasksSection: some View {
  Section {
   VStack(alignment: .leading, spacing: 12) {
    subtasksHeader
    subtasksList
    addSubTaskButton
   }
  }
  .listRowSeparator(.hidden)
 }

 private var subtasksHeader: some View {
  HStack {
   Text("Sub-tasks")
    .font(.system(size: 16, weight: .semibold))

   Spacer()

   HStack(spacing: 6) {
    Image(systemName: "zap.fill")
     .font(.caption.weight(.semibold))
     .foregroundColor(remainingEnergy > 0 ? .myRed : .gray)
    Text("\(remainingEnergy) / \(storyPoints)")
     .font(.caption.weight(.semibold))
     .foregroundColor(remainingEnergy > 0 ? .textPrimary : .gray)
   }
   .padding(.horizontal, 10)
   .padding(.vertical, 6)
   .background(Color.black.opacity(0.05))
   .cornerRadius(8)
  }
 }

 private var subtasksList: some View {
  Group {
   if subTasks.isEmpty {
    VStack(alignment: .center, spacing: 8) {
     Image(systemName: "checklist")
      .font(.title3)
      .foregroundColor(.gray)
     Text("No sub-tasks yet")
      .font(.subheadline)
      .foregroundColor(.gray)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
   } else {
    VStack(spacing: 12) {
     ForEach(Array(subTasks.enumerated()), id: \.element.id) { index, subTask in
      subtaskRow(index: index, subTask: subTask)
     }
    }
   }
  }
 }

 private func subtaskRow(index: Int, subTask: SubTask) -> some View {
  HStack(spacing: 12) {
   Button(action: {
    withAnimation(.easeInOut(duration: 0.2)) {
     toggleSubTaskCompletion(index: index)
    }
   }) {
    Image(systemName: subTask.isCompleted ? "checkmark.circle.fill" : "circle")
     .font(.title3)
     .foregroundColor(subTask.isCompleted ? .myGreen : .gray)
   }

   VStack(alignment: .leading, spacing: 4) {
    TextField("Sub-task title", text: Binding(
     get: { subTasks[index].title },
     set: { subTasks[index].title = $0 }
    ))
    .font(.body)
    .textFieldStyle(.roundedBorder)
    .strikethrough(subTask.isCompleted, color: .gray)
    .opacity(subTask.isCompleted ? 0.6 : 1.0)

    if subTask.isCompleted {
     Text("Done")
      .font(.caption)
      .foregroundColor(.myGreen)
    }
   }

   Spacer()

   Menu {
    ForEach(1...min(20, remainingEnergy + subTask.energyCost), id: \.self) { energy in
     Button("\(energy)") {
      updateSubTaskEnergy(index: index, newEnergy: energy)
     }
    }
   } label: {
    HStack(spacing: 4) {
     Image(systemName: "bolt.fill")
      .font(.caption.weight(.semibold))
     Text("\(subTask.energyCost)")
      .font(.subheadline.weight(.semibold))
    }
    .foregroundColor(.white)
    .padding(.horizontal, 10)
    .padding(.vertical, 6)
    .background(Color.myRed)
    .cornerRadius(8)
   }
  }
  .swipeActions(edge: .trailing, allowsFullSwipe: true) {
   Button(role: .destructive) {
    withAnimation {
     removeSubTask(at: IndexSet(integer: index))
    }
   } label: {
    Label("Delete", systemImage: "trash.fill")
   }
  }
 }

 private var addSubTaskButton: some View {
  Button(action: {
   withAnimation {
    addSubTask()
   }
  }) {
   HStack(spacing: 8) {
    Image(systemName: "plus.circle.fill")
     .foregroundColor(.orange)
    Text(subTasks.isEmpty ? "Add sub-task" : "Add another sub-task")
     .foregroundColor(.blackPrimary)
   }
   .font(.body)
   .padding(.vertical, 8)
  }
  .disabled(!canAddMoreSubTasks)
  .opacity(canAddMoreSubTasks ? 1.0 : 0.5)
 }

 private var storyPointsInfoSheet: some View {
  VStack(alignment: .leading, spacing: 16) {
   HStack {
    Image(systemName: "info.circle.fill")
     .foregroundStyle(.myPurple)
    Text("About Story Points")
     .font(.title3.bold())
   }
   Text("Story points represent the relative effort or complexity of a task. Choose a number from 1 (very small) to 100 (very large).")
    .font(.body)
    .foregroundStyle(.secondary)

   Divider()

   VStack(alignment: .leading, spacing: 8) {
    Text("Tips")
     .font(.headline)
    Text("• Start small and adjust as you build intuition.\n• Keep numbers consistent across similar tasks.\n• Use higher values sparingly.")
     .foregroundStyle(.secondary)
   }

   Spacer()
  }
  .padding(20)
  .presentationDetents([.medium, .large])
  .presentationDragIndicator(.visible)
 }

 private var storyPointsPickerSheet: some View {
  VStack(spacing: 20) {
   Text("Set Story Points")
    .font(.title3.bold())

   Text("\(storyPoints)")
    .font(.system(size: 48, weight: .ultraLight))
    .fontDesign(.serif)

   Slider(value: Binding(
    get: { Double(storyPoints) },
    set: { storyPoints = Int($0.rounded()) }
   ), in: 1...100, step: 1)

   HStack {
    Text("1")
     .foregroundStyle(.secondary)
    Spacer()
    Text("100")
     .foregroundStyle(.secondary)
   }

   Button {
    showStoryPointsPicker = false
   } label: {
    HStack(spacing: 8) {
     Image(systemName: "checkmark.circle.fill")
     Text("Done")
      .bold()
    }
    .padding(.horizontal, 18)
    .padding(.vertical, 10)
   }
   .buttonStyle(.glass)

   Spacer()
  }
  .padding(20)
  .presentationDetents([.medium, .large])
  .presentationDragIndicator(.visible)
 }

 // MARK: - Save Task Function

 private func saveTask() {
  let trimmedTitle = taskTitle.trimmingCharacters(in: .whitespaces)
  guard !trimmedTitle.isEmpty else { return }

  let validSubTasks = subTasks.filter { !$0.title.trimmingCharacters(in: .whitespaces).isEmpty }

  let totalSubTaskEnergy = validSubTasks.reduce(0) { $0 + $1.energyCost }
  guard totalSubTaskEnergy <= storyPoints else {
   print("Error: Subtasks energy (\(totalSubTaskEnergy)) exceeds task energy (\(storyPoints))")
   return
  }

  let newTask = Task(
   title: trimmedTitle,
   createdDate: Date(),
   isCompleted: false,
   hasSubtasks: !validSubTasks.isEmpty,
   taskColor: taskColor,
   taskSymbol: taskSymbol,
   energyCost: storyPoints,
   subTasks: validSubTasks
  )

  taskManager.addTask(newTask)
  dismiss()
 }
}

#Preview("Default") {
 TaskDetailsView(isPresented: .constant(true), taskText: "Make a cake")
  .environment(\.taskManager, TaskManager())
  .modelContainer(for: [Task.self, SubTask.self, DailyEnergy.self], isAutosaveEnabled: false)
}
