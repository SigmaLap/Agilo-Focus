import SwiftUI

struct HomeView: View {
 @State private var showQuickAdd = false
 @State private var quickAddText = ""
 @FocusState private var isInputFocused: Bool
 @State private var card1Completed: Int = 0
 @State private var card2Completed: Int = 0
 @State private var card3Completed: Int = 0
 var formattedDate: String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "dd MMM"
  return dateFormatter.string(from: Date())
 }
 
 var body: some View {
   ScrollView {
    // Welcome back message
    VStack{
     HStack {
      VStack{
       HStack {
        Text("Top 3")
         .font(.largeTitle)
         .fontWeight(.medium)
         .fontDesign(.serif)
         .foregroundColor(.blackPrimary)
         .padding(.horizontal)
       }
      }
      Spacer()
     }
    }
    .padding(.bottom, -10)
    

    

    
    
    ZStack{
     
     
     Text("\(formattedDate)")
      .fontDesign(.serif)
      .font(.title3)
      .foregroundStyle(Color.textSecondary)
   
     ActivityRings(lineWidth: 34, backgroundColor: Color.accent.opacity(0.1), foregroundColor: Color.accent.opacity(0.7), percentage: 65, percent: 75, startAngle: -96, adjustedSympol: "shippingbox", iconSize: 20)
      .frame(width: 279, height: 349)
     
     ActivityRings(lineWidth: 29, backgroundColor: Color.cyan.opacity(0.1), foregroundColor: Color.cyan.opacity(0.7), percentage: 45, percent: 75, startAngle: -97, adjustedSympol: "arrow.forward.to.line", iconSize: 18)
      .frame(width: 207, height: 207)
     
//     ActivityRings(lineWidth: 26, backgroundColor: Color.orange.opacity(0.1), foregroundColor: Color.orange.opacity(0.7), percentage: 82, percent: 75, startAngle: -99, adjustedSympol: "arrow.triangle.capsulepath", iconSize: 17)
//      .frame(width: 145, height: 145)
     
    }
     
    
    
    
    HStack() {
     TaskCircleView(
      color: .orange,
      icon: "arrow.triangle.capsulepath",
      title: "Energy Level",
      value: "5/20",
      percentage: 25
     )
     
     Spacer()
     
     TaskCircleView(
      color: .cyan,
      icon: "arrow.forward.to.line",
      title: "Sprint Days",
      value: "3/14",
      percentage: 21
     )
    }
    .padding(.horizontal, 50)
    
    
    
    
    // Add To-dos Prompt Card
    VStack{
     AddTodosCard(totalCount: 2, completedCount: $card1Completed)
     AddTodosCard(totalCount: 0, completedCount: $card2Completed)
     AddTodosCard(totalCount: 10, completedCount: $card3Completed)
    }
     .padding(.horizontal)
     .padding(.bottom, 40)
    
    
    
    
    
    
    
    
   }
   .scrollIndicators(.hidden)

   .toolbar {
    ToolbarItemGroup(placement: .topBarTrailing) {
    
     Button(action: {
      withAnimation(.easeInOut(duration: 0.25)) {
       showQuickAdd = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
       isInputFocused = true
      }
     }) {
      Image(systemName: "plus")
       .font(.headline)
     }
    }
//
//    ToolbarItemGroup(placement: .topBarLeading) {
//     HStack{
//      Button(action: {}) {
//       Image(systemName: "party.popper.fill")
//       Text("2")
//       Text("/")
//       Text("3")
//      }
//
//     }
//     .bold()
//     .font(.caption)
//    }
   }

   // Input Accessory Overlay above Keyboard
   if showQuickAdd {
    VStack(spacing: 0) {
     // Dimmed background when input is active
     Color.black.opacity(0.3)
      .ignoresSafeArea()
      .onTapGesture {
       withAnimation(.easeInOut(duration: 0.2)) {
        showQuickAdd = false
       }
      }

     // Quick Add View positioned above keyboard
     QuickAddTaskView(
      isPresented: $showQuickAdd,
      taskText: $quickAddText,
      onAddTask: addTask
     )
     .presentationDetents([.height(150)])
//     .presentationDragIndicator(.visible)
    }
   }
  
 }
 

 private func addTask() {
  let task = quickAddText.trimmingCharacters(in: .whitespaces)
  if !task.isEmpty {
   // TODO: Add task to your data model
   print("Task added: \(task)")
   quickAddText = ""
   showQuickAdd = false
  }
 }
}

// MARK: - Stat Card
struct StatCard: View {
 let title: String
 let value: String
 let icon: String
 let color: Color
 
 var body: some View {
  VStack(alignment: .leading, spacing: 12) {
   HStack {
    Image(systemName: icon)
     .font(.title2)
     .foregroundColor(color)
    
    Spacer()
   }
   
   Text(value)
    .font(.system(size: 32, weight: .bold))
    .foregroundColor(.blackPrimary)
   
   Text(title)
    .font(.subheadline)
    .foregroundColor(.textSecondary)
  }
  .padding()
  .frame(maxWidth: .infinity)
  .background(Color.cardBackground)
  .cornerRadius(16)
  .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
 }
}

// MARK: - Task Row
struct TaskRow: View {
 let title: String
 let time: String
 @State private var isCompleted: Bool = false
 @State private var showConfetti: Bool = false

 var body: some View {
  ZStack {
   HStack(spacing: 12) {
    Button(action: {
     withAnimation(.easeInOut(duration: 0.3)) {
      isCompleted.toggle()
      if isCompleted {
       showConfetti = true
       // Hide confetti after animation completes (1.2s lifetime + 0.2s buffer)
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
        showConfetti = false
       }
      }
     }
    }) {
     Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
      .font(.title3)
      .foregroundColor(isCompleted ? .myGreen : .textSecondary)
    }
    .buttonStyle(.plain)

    VStack(alignment: .leading, spacing: 4) {
     Text(title)
      .font(.body)
      .foregroundColor(.blackPrimary)
      .strikethrough(isCompleted)
      .opacity(isCompleted ? 0.5 : 1.0)

     Text(time)
      .font(.caption)
      .foregroundColor(.textSecondary)
    }

    Spacer()
   }
   .padding()
   .background(Color.gray.opacity(0.05))
   .cornerRadius(12)
   .opacity(isCompleted ? 0.6 : 1.0)

   // Confetti overlay
   if showConfetti {
    ConfettiView()
   }
  }
 }
}

// MARK: - Activity Row
struct ActivityRow: View {
 let icon: String
 let title: String
 let time: String
 let color: Color

 var body: some View {
  HStack(spacing: 12) {
   Image(systemName: icon)
    .font(.title3)
    .foregroundColor(color)
    .frame(width: 40, height: 40)
    .background(color.opacity(0.1))
    .cornerRadius(20)

   VStack(alignment: .leading, spacing: 4) {
    Text(title)
     .font(.body)
     .foregroundColor(.blackPrimary)

    Text(time)
     .font(.caption)
     .foregroundColor(.textSecondary)
   }

   Spacer()
  }
 }
}

// MARK: - Goal Card
struct GoalCard: View {
 let title: String
 let progress: Double
 let color: Color

 var body: some View {
  VStack(alignment: .leading, spacing: 12) {
   HStack {
    Text(title)
     .font(.body)
     .foregroundColor(.blackPrimary)

    Spacer()

    Text("\(Int(progress * 100))%")
     .font(.caption.bold())
     .foregroundColor(color)
   }

   GeometryReader { geometry in
    ZStack(alignment: .leading) {
     RoundedRectangle(cornerRadius: 4)
      .fill(Color.gray.opacity(0.1))

     RoundedRectangle(cornerRadius: 4)
      .fill(color.opacity(0.6))
      .frame(width: geometry.size.width * progress)
    }
   }
   .frame(height: 8)
  }
  .padding()
  .background(Color.gray.opacity(0.02))
  .cornerRadius(12)
 }
}

// MARK: - Collab Activity Card
struct CollabActivityCard: View {
 let icon: String
 let title: String
 let description: String
 let time: String
 let color: Color
 
 var body: some View {
  HStack(alignment: .top, spacing: 12) {
   Image(systemName: icon)
    .font(.title2)
    .foregroundColor(color)
    .frame(width: 44, height: 44)
    .background(color.opacity(0.1))
    .cornerRadius(22)
   
   VStack(alignment: .leading, spacing: 4) {
    Text(title)
     .font(.body.bold())
     .foregroundColor(.blackPrimary)
    
    Text(description)
     .font(.subheadline)
     .foregroundColor(.textSecondary)
    
    Text(time)
     .font(.caption)
     .foregroundColor(.textSecondary.opacity(0.8))
   }
   
   Spacer()
  }
  .padding()
  .background(Color.gray.opacity(0.05))
  .cornerRadius(12)
 }
}

// MARK: - Add Todos Card
struct AddTodosCard: View {
 let totalCount: Int
 @Binding var completedCount: Int
 @State private var showConfetti: Bool = false

 private var progress: Double {
  guard totalCount > 0 else { return 0 }
  return Double(completedCount) / Double(totalCount)
 }

 var body: some View {
  ZStack {
   VStack(spacing: 0) {
    HStack(spacing: 12) {
     ZStack {
      Circle()
       .fill(Color.yellow.opacity(0.35))
       .frame(width: 29, height: 29)

      Image(systemName: "checkmark")
       .font(.body.weight(.semibold))
     }

     Text("Add your to-dos to the list")
      .font(.body)
      .strikethrough(completedCount > 0)
      .foregroundColor(completedCount > 0 ? .gray : .primary)

     Spacer()

     // Tappable completion circle
     Button(action: {
      if completedCount < totalCount && totalCount > 0 {
       withAnimation(.easeInOut(duration: 0.3)) {
        completedCount += 1
        showConfetti = true
       }
       // Hide confetti after animation completes (1.2s lifetime + 0.2s buffer)
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
        showConfetti = false
       }
      }
     }) {
      ZStack {
       Circle()
        .stroke(Color.black.opacity(0.9), lineWidth: 1)
        .frame(width: 25, height: 25)

       if completedCount < totalCount && totalCount > 0 {
        Image(systemName: "plus")
         .font(.caption.weight(.semibold))
         .foregroundColor(.black)
       }
      }
     }
     .disabled(completedCount >= totalCount || totalCount == 0)
    }
    .padding(.horizontal)

    if totalCount > 0 {
     Divider()
      .opacity(0.06)

     HStack {
      GeometryReader { geo in
       ZStack(alignment: .leading) {
        Capsule()
         .fill(Color.black.opacity(0.06))
         .frame(height: 12)

        Capsule()
         .fill(Color.myGreen.opacity(0.8))
         .frame(width: geo.size.width * progress, height: 12)
       }
      }
      .frame(height: 12)
      .frame(maxWidth: 60)

      Text("\(completedCount) / \(totalCount)")
       .font(.headline.weight(.semibold))
       .foregroundColor(.gray)

      Spacer()

      Image(systemName: "chevron.down")
       .font(.headline.weight(.semibold))
       .foregroundColor(.gray)
     }
     .padding(.horizontal)
     .padding(.vertical, 8)
    }
   }
   .padding(.vertical, 8)
   .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22))

   // Confetti overlay
   if showConfetti {
    ConfettiView()
   }
  }
 }
}

#Preview {
 HomeView()
}


struct RingShape: Shape {
 var percent: Double
 let startAngle: Double
 
 typealias AnimatableData = Double
 var animatableData: Double {
  get {
   return percent
  }
  set {
   percent = newValue
  }
 }
 
 init(percent: Double = 100, startAngle: Double = -90) {
  self.percent = percent
  self.startAngle = startAngle
 }
 
 static func percentToAngle(percent: Double, startAngle: Double) -> Double {
  return (percent / 100 * 360) + startAngle
 }
 
 func path(in rect: CGRect) -> Path {
  let width = rect.width
  let height = rect.height
  let radius = min(height, width) / 2
  let center = CGPoint(x: width / 2, y: height / 2)
  let endAngle = Self.percentToAngle(percent: percent, startAngle: startAngle)
  
  return Path { path in
   path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle), endAngle: Angle(degrees: endAngle), clockwise: false)
  }
 }
}


struct ActivityRings: View {
 let lineWidth : CGFloat
 let backgroundColor: Color
 let foregroundColor: Color
 let percentage: Double
 var percent: Double
 var startAngle: Double
 var adjustedSympol : String
 var iconSize : CGFloat
 
 var body: some View {
  GeometryReader { geometry in
   ZStack {
    let width = geometry.size.width
    let height = geometry.size.height
    let radius = min(height, width) / 2
    let center = CGPoint(x: width / 2, y: height / 2)
    let startAngleRadians = startAngle * .pi / 180
    let arrowX = center.x + radius * cos(CGFloat(startAngleRadians))
    let arrowY = center.y + radius * sin(CGFloat(startAngleRadians))
    RingShape()
     .stroke(style: StrokeStyle(lineWidth: lineWidth))
     .fill(backgroundColor)
    RingShape(percent: percentage)
     .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
     .fill(foregroundColor)
    Image(systemName: adjustedSympol)
     .position(x: arrowX, y: arrowY)
     .font(.system(size: iconSize))
   }
   .padding(lineWidth / 2)
  }
 }
}



struct TaskCircleView: View {
 var color: Color
 var icon: String
 var title: String
 var value: String
 var percentage: Double
 
 var body: some View {
  ZStack {
   RingShape()
    .stroke(style: StrokeStyle(lineWidth: 3))
    .fill(color.opacity(0.1))
    .frame(width: 100, height: 110)
   RingShape(percent: percentage)
    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
    .fill(color.opacity(0.7))
    .frame(width: 100, height: 110)
   Circle()
    .frame(width: 105, height: 110)
    .foregroundStyle(color.opacity(0.1))
   VStack {
    Image(systemName: icon)
     .padding(.bottom, 0.5)
    Text(title)
     .font(.caption2)
     .foregroundStyle(.gray)
     .padding(.bottom, 1)
    Text(value)
     .font(.headline)
     .foregroundStyle(color)
   }
  }
 }
}
