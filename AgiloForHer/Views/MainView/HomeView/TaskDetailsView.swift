import SwiftUI

struct TaskDetailsView: View {
 @EnvironmentObject var taskManager: TaskManager
 @State private var taskTitle = ""
 @State private var taskColor: String = "purple"
 @State private var taskSymbol: String = "checkmark"

 @Binding var isPresented: Bool
 let taskText: String
 @Environment(\.dismiss) private var dismiss
 @State private var selectedTimeOfDay = "Morning"
 @State private var duration = "30m"
 @State private var subTasksCount: Int = 0
 @State private var subTasksCompleted: Int = 0
 @State private var notes = ""
 @State private var showSuggestBreakdown = false
 @State private var sliderValue: Double = 0
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
 
	private enum SchedulingMode {
		case timeOfDaySlider
		case atTime
	}
	@State private var schedulingMode: SchedulingMode = .timeOfDaySlider
	@State private var startDate: Date = Date()
	@State private var endDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
	@State private var repeatRule: String = "Never"
	
	private var schedulingLabel: String {
		switch schedulingMode {
		case .atTime:
			return "At time"
		case .timeOfDaySlider:
			return selectedTimeOfDay
		}
	}
	
	private var schedulingIconName: String {
		switch schedulingMode {
		case .atTime:
			return "calendar"
		case .timeOfDaySlider:
			switch selectedTimeOfDay {
			case "Morning": return "sun.horizon.fill"
			case "Afternoon": return "sun.max.fill"
			case "Evening": return "sunset.fill"
			case "Night": return "moon.fill"
			case "Late Night": return "moon.stars.fill"
			default: return "sun.horizon.fill"
			}
		}
	}
	
	private var schedulingTint: Color {
		switch schedulingMode {
		case .atTime:
			return .myPurple
		case .timeOfDaySlider:
			switch selectedTimeOfDay {
			case "Morning": return .cyan
			case "Afternoon": return .softSand
			case "Evening": return .myRed
			case "Night": return .purple
			case "Late Night": return .slateGray
			default: return .myPurple
			}
		}
	}
 
 var body: some View {
  NavigationStack{
   Form{
    Section{
     HStack{
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
    
    Section{
     HStack{
      Button {
       showStoryPointsInfo = true
      } label: {
       Image(systemName: "info.circle")
        .imageScale(.small)
        .foregroundStyle(.secondary)
      }
      .buttonStyle(.plain)
      
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
     }
    
     .sheet(isPresented: $showStoryPointsInfo) {
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
     
     .sheet(isPresented: $showStoryPointsPicker) {
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
    }
    .listRowSeparator(.hidden)
    
    Section{
     HStack{
      Text("Time of day")
       .font(.headline)
      Spacer()
      
      Menu(){
       Section("Time of day") {
        Button {
         selectedTimeOfDay = "Morning"
         schedulingMode = .timeOfDaySlider
         sliderValue = 0.0
        } label: {
         Label("Morning", systemImage: "sun.horizon.fill")
        }
        Button {
         selectedTimeOfDay = "Afternoon"
         schedulingMode = .timeOfDaySlider
         sliderValue = 0.25
        } label: {
         Label("Afternoon", systemImage: "sun.max.fill")
        }
        Button {
         selectedTimeOfDay = "Evening"
         schedulingMode = .timeOfDaySlider
         sliderValue = 0.5
        } label: {
         Label("Evening", systemImage: "sunset.fill")
        }
        Button {
         selectedTimeOfDay = "Night"
         schedulingMode = .timeOfDaySlider
         sliderValue = 0.75
        } label: {
         Label("Night", systemImage: "moon.fill")
        }
        Button {
         selectedTimeOfDay = "Late Night"
         schedulingMode = .timeOfDaySlider
         sliderValue = 1.0
        } label: {
         Label("Late Night", systemImage: "moon.stars.fill")
        }
       }
       Section("At Specific time"){
        Button {
         schedulingMode = .atTime
        } label: {
         Label("At time", systemImage: "calendar")
        }
        
        Button {
         schedulingMode = .timeOfDaySlider
        } label: {
         Label("All day", systemImage: "clock")
        }
        
        Button {
         schedulingMode = .timeOfDaySlider
        } label: {
         Label("Later", systemImage: "box")
        }
        
       }
       
      } label: {
       HStack(spacing: 4){
        Image(systemName: schedulingIconName)
         .fontWeight(.ultraLight)
        Text(schedulingLabel)
         .font(.headline)
         .bold()
         .padding(.vertical, 7)
       }
       .foregroundStyle(.textPrimary)
       .padding(.horizontal, 15)
       .glassEffect(.regular.interactive().tint(schedulingTint.opacity(0.10)))
      }
     }
     Group {
      if schedulingMode == .atTime {
       // Starts
       HStack {
        Text("Starts")
         .font(.headline)
        Spacer()
        DatePicker("", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
         .labelsHidden()
       }
       // Ends
       HStack {
        Text("Ends")
         .font(.headline)
        Spacer()
        DatePicker("", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
         .labelsHidden()
       }
       // Repeat
       HStack {
        Text("Repeat")
         .font(.headline)
        Spacer()
        Menu(repeatRule) {
         Button("Never") { repeatRule = "Never" }
         Button("Daily") { repeatRule = "Daily" }
         Button("Weekdays") { repeatRule = "Weekdays" }
         Button("Weekly") { repeatRule = "Weekly" }
         Button("Monthly") { repeatRule = "Monthly" }
        }
        .font(.title3)
        //        .fontDesign(.serif)
        .foregroundColor(.myPurple)
        .glassEffect(.regular.interactive())
       }
      } else {
       Slider(value: $sliderValue, in: 0...1, step: 0.25) {
        Text("Time of day")
       } minimumValueLabel: {
        Image(systemName: "sun.horizon.fill")
       } maximumValueLabel: {
        Image(systemName: "moon.stars.fill")
       }
       .onChange(of: sliderValue) { _, newValue in
        let timeOfDays = ["Morning", "Afternoon", "Evening", "Night", "Late Night"]
        let index = min(Int(round(newValue * 4)), 4)
        selectedTimeOfDay = timeOfDays[index]
       }
      }
     }
     
    }
    .listRowSeparator(.hidden)
    
    
    Section {
     Toggle("More", isOn: $showMoreOptions)
      .font(.headline)
      .tint(.accentColor)
    }
    .listRowSeparator(.hidden)
    
    if showMoreOptions {
   
    Section{
     VStack(alignment: .leading, spacing: 12) {
      HStack {
       Text("Sub-tasks")
        .font(.system(size: 16, weight: .semibold))

       Spacer()

       Button(action: { showSuggestBreakdown = true }) {
        HStack(spacing: 6) {
         Text("SUGGEST BREAKDOWN")
          .font(.system(size: 12, weight: .semibold))
         Image(systemName: "list.clipboard")
        }
        .foregroundColor(.blackPrimary)
        .padding(5)
       }
      }
      .buttonStyle(.glass)

      // Sub-tasks Counter
      if subTasksCount > 0 {
       ZStack {
        VStack(spacing: 0) {
         HStack(spacing: 12) {
          ZStack {
           Circle()
            .fill(subTasksCompleted >= subTasksCount ? Color.myGreen.opacity(0.2) : Color.yellow.opacity(0.2))
            .frame(width: 36, height: 36)

           Image(systemName: subTasksCompleted >= subTasksCount ? "checkmark" : "\(subTasksCount)")
            .font(.body.bold())
            .foregroundColor(subTasksCompleted >= subTasksCount ? .myGreen : .yellow)
          }

          VStack(alignment: .leading, spacing: 4) {
           Text("Add your sub-tasks")
            .font(.body)
            .strikethrough(subTasksCompleted >= subTasksCount)
            .foregroundColor(subTasksCompleted >= subTasksCount ? .gray : .primary)

           Text("\(subTasksCompleted) / \(subTasksCount) completed")
            .font(.caption)
            .foregroundColor(.textSecondary)
          }

          Spacer()

          Button(action: {
           if subTasksCompleted < subTasksCount {
            withAnimation(.easeInOut(duration: 0.3)) {
             subTasksCompleted += 1
            }
           }
          }) {
           ZStack {
            Circle()
             .stroke(Color.blackPrimary.opacity(0.3), lineWidth: 2)
             .frame(width: 28, height: 28)

            if subTasksCompleted < subTasksCount {
             Image(systemName: "plus")
              .font(.caption.weight(.semibold))
              .foregroundColor(.blackPrimary)
            }
           }
          }
          .disabled(subTasksCompleted >= subTasksCount)
         }
         .padding(.horizontal)

         if subTasksCount > 0 {
          Divider()
           .opacity(0.06)

          HStack {
           GeometryReader { geo in
            ZStack(alignment: .leading) {
             Capsule()
              .fill(Color.black.opacity(0.06))
              .frame(height: 8)

             Capsule()
              .fill(Color.myGreen.opacity(0.8))
              .frame(width: geo.size.width * Double(subTasksCompleted) / Double(subTasksCount), height: 8)
            }
           }
           .frame(height: 8)
           .frame(maxWidth: 50)

           Text("\(subTasksCompleted) / \(subTasksCount)")
            .font(.caption.bold())
            .foregroundColor(.gray)

           Spacer()

           Image(systemName: "chevron.down")
            .font(.caption.bold())
            .foregroundColor(.gray)
          }
          .padding(.horizontal)
          .padding(.vertical, 8)
         }
        }
        .padding(.vertical, 8)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14))
       }
      }

      // Button to add sub-tasks
      Button(action: {
       if subTasksCount < 10 {
        subTasksCount += 1
       }
      }) {
       HStack(spacing: 8) {
        Image(systemName: "plus.circle.fill")
         .foregroundColor(.orange)
        Text(subTasksCount == 0 ? "Add sub-tasks" : "Add another sub-task")
         .foregroundColor(.blackPrimary)
       }
       .font(.body)
       .padding(.vertical, 8)
      }
     }
    }
    .listRowSeparator(.hidden)

    Section{
     VStack{
      TextField("This is important because...", text: $notes, axis: .vertical)
       .font(.system(size: 16, weight: .regular))
       .padding(.vertical, 8)
      Spacer()
     }
     .frame(minHeight: 120)
    } footer: {
     Button(action: {
      
     }) {
      HStack{
       Text("Tag")
       Image(systemName: "plus")
      }
      .font(.subheadline.bold())
      .padding(2)
     }
     .buttonStyle(.glass)
     .padding(.leading, -10)
    }
    
    
    }
   }
   .padding(.top, -25)
   .listSectionSpacing(12)
   .navigationTitle("Add task")
   .navigationBarBackButtonHidden()
   .navigationBarTitleDisplayMode(.inline)
   .onAppear {
    if taskTitle.isEmpty && !taskText.isEmpty {
     taskTitle = taskText
    }
   }
   
   .toolbar {
    ToolbarItem(placement: .topBarLeading) {
     Button(role: .cancel) {
      dismiss()
     }
    }
    ToolbarItem(placement: .topBarTrailing) {
     Button{
      saveTask()
     } label: {
      Image(systemName: "checkmark")
       .fontWeight(.semibold)
     }
     .disabled(taskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
    }
   }
   .sheet(isPresented: $showColorSymbolPicker) {
    ColorSymbolPickerView(taskColor: $taskColor, taskSymbol: $taskSymbol, getColorValue: getColorValue)
   }

  }

 }

 private func saveTask() {
  let title = taskTitle.trimmingCharacters(in: .whitespaces)
  if !title.isEmpty {
   var newTask = Task(title: title)
   newTask.taskColor = taskColor
   newTask.taskSymbol = taskSymbol
   taskManager.addTask(newTask)
   dismiss()
  }
 }
}

#Preview("Default") {
 TaskDetailsView(isPresented: .constant(true), taskText: "Make a cake")
  .environmentObject(TaskManager())
}

#Preview("Long title • Dark Mode") {
 TaskDetailsView(isPresented: .constant(true), taskText: "Bake a triple-layer chocolate cake with ganache and decorations")
  .environmentObject(TaskManager())
  .environment(\.colorScheme, .dark)
}
