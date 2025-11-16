import SwiftUI

struct QuickAddTaskView: View {
 @Binding var isPresented: Bool
 @Binding var taskText: String
 @FocusState var isInputFocused: Bool
 let onAddTask: () -> Void

 @State private var showTaskDetails = false
// @ObservedObject var keyboardObserver: KeyboardObserver

 var body: some View {
  VStack(spacing: 0) {
   // Input Field with placeholder
   HStack {
    TextField("Stay On Track", text: $taskText)
     .font(.system(size: 18, weight: .regular))
     .foregroundColor(.textSecondary)
     .padding(.horizontal, 16)
     .padding(.vertical, 12)
     .background(Color.white)
     .cornerRadius(12)
     .focused($isInputFocused)
   }
   .padding(.horizontal, 16)
   .padding(.vertical, 12)

   // Time and options buttons
   HStack(spacing: 12) {
    Button(action: {}) {
     HStack(spacing: 6) {
      Image(systemName: "clock.fill")
       .font(.caption2)
      Text("ANYTIME")
       .font(.system(size: 11, weight: .semibold))
     }
     .foregroundColor(.blackPrimary)
     .padding(.horizontal, 12)
     .padding(.vertical, 8)
     .background(Color.white)
     .cornerRadius(8)
    }

    Button(action: {}) {
     HStack(spacing: 6) {
      Image(systemName: "repeat")
       .font(.caption2)
      Text("NO")
       .font(.system(size: 11, weight: .semibold))
     }
     .foregroundColor(.blackPrimary)
     .padding(.horizontal, 12)
     .padding(.vertical, 8)
     .background(Color.white)
     .cornerRadius(8)
    }

    Button(action: { showTaskDetails = true }) {
     Image(systemName: "ellipsis")
      .font(.caption)
      .foregroundColor(.blackPrimary)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(Color.white)
      .cornerRadius(8)
    }

    Spacer()

    Button(action: onAddTask) {
     HStack(spacing: 6) {
      Image(systemName: "waveform")
       .font(.caption2)
      Text("Speak")
       .font(.system(size: 11, weight: .semibold))
     }
     .foregroundColor(.white)
     .padding(.horizontal, 16)
     .padding(.vertical, 8)
     .background(Color.blackPrimary)
     .cornerRadius(20)
    }
   }
   .padding(.horizontal, 16)
   .padding(.bottom, 12)
  }
  .padding(.vertical, 0)
  .background(Color(red: 0.95, green: 0.95, blue: 0.97))
  .onAppear {
   isInputFocused = true
  }
  .sheet(isPresented: $showTaskDetails) {
   TaskDetailsView(isPresented: $showTaskDetails, taskText: taskText)
  }
 }
}

#Preview {
 QuickAddTaskView(
  isPresented: .constant(true),
  taskText: .constant(""),
  onAddTask: {}
 )
}
