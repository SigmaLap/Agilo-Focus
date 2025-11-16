import SwiftUI

struct TaskCard: View {
 @Binding var task: Task
 @State private var showConfetti: Bool = false

 var body: some View {
  ZStack {
   VStack(spacing: 0) {
    HStack(spacing: 12) {
     Button(action: toggleTask) {
      ZStack {
       Circle()
        .fill(task.isCompleted ? Color.myGreen.opacity(0.2) : task.getTaskColor().opacity(0.2))
        .frame(width: 40, height: 40)

       Image(systemName: task.isCompleted ? "checkmark.circle.fill" : task.taskSymbol)
        .font(.title2)
        .foregroundColor(task.isCompleted ? .myGreen : task.getTaskColor())
      }
     }
     .buttonStyle(.plain)

     VStack(alignment: .leading, spacing: 4) {
      Text(task.title)
       .font(.body.bold())
       .foregroundColor(.blackPrimary)
       .strikethrough(task.isCompleted)
       .lineLimit(2)

      Text(task.createdDate.formatted(date: .abbreviated, time: .omitted))
       .font(.caption)
       .foregroundColor(.textSecondary)
     }

     Spacer()

     Button(action: toggleTask) {
      ZStack {
       Circle()
        .stroke(Color.blackPrimary.opacity(0.3), lineWidth: 2)
        .frame(width: 32, height: 32)

       Image(systemName: task.isCompleted ? "checkmark" : "plus")
        .font(.caption.weight(.semibold))
        .foregroundColor(.blackPrimary)
      }
     }
     .disabled(task.isCompleted)
    }
    .padding(.horizontal)

    if !task.isCompleted {
     Divider()
      .opacity(0.06)
      .padding(.vertical, 8)

     HStack {
      VStack(alignment: .leading, spacing: 4) {
       Text("Status")
        .font(.caption)
        .foregroundColor(.textSecondary)
       Text("Pending")
        .font(.caption.bold())
        .foregroundColor(task.getTaskColor())
      }

      Spacer()

      Image(systemName: "chevron.right")
       .font(.caption.bold())
       .foregroundColor(.textSecondary)
     }
     .padding(.horizontal)
     .padding(.vertical, 8)
    }
   }
   .padding(.vertical, 12)
   .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22))

   // Confetti overlay
   if showConfetti {
    ConfettiView()
   }
  }
 }

 private func toggleTask() {
  withAnimation(.easeInOut(duration: 0.3)) {
   task.isCompleted.toggle()
   if task.isCompleted {
    showConfetti = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
     showConfetti = false
    }
   }
  }
 }
}

#Preview {
 @Previewable @State var task = Task(title: "Complete project setup")
 TaskCard(task: $task)
  .padding()
}
