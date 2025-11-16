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
     .padding(.horizontal, 16)
     .padding(.vertical, 12)
     .background(.ultraThinMaterial)
     .cornerRadius(20)
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
     .padding(.horizontal, 16)
     .padding(.vertical, 8)
     .background(.ultraThinMaterial)
     .cornerRadius(20)
    }

    Button(action: {}) {
     HStack(spacing: 6) {
      Image(systemName: "repeat")
       .font(.caption2)
      Text("NO")
       .font(.system(size: 11, weight: .semibold))
     }
     .padding(.horizontal, 16)
     .padding(.vertical, 8)
     .background(.ultraThinMaterial)
     .cornerRadius(20)

    }

    Button(action: { showTaskDetails = true }) {
     Image(systemName: "ellipsis")
      .font(.caption)
      .padding(.horizontal, 16)
      .padding(.vertical, 8)
      .background(.ultraThinMaterial)
      .cornerRadius(20)

    }

    Spacer()

    Button(action: onAddTask) {
     HStack(spacing: 6) {
      Image(systemName: "checkmark")
       .font(.caption2)
      Text("Done")
       .font(.system(size: 11, weight: .semibold))
     }
     .padding(.horizontal, 16)
     .padding(.vertical, 8)
     .background(.ultraThinMaterial)
     .cornerRadius(20)
    }
   }
   .padding(.horizontal, 16)
   .padding(.bottom, 25)
  }
  .padding(.vertical, 0)
  .background(.ultraThinMaterial)
  .offset(y: 15)
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
