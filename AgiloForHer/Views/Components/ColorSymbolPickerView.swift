import SwiftUI

struct ColorSymbolPickerView: View {
 @Binding var taskColor: String
 @Binding var taskSymbol: String
 @Environment(\.taskManager) var taskManager
 @Environment(\.dismiss) private var dismiss

 private let availableColors = ["purple", "orange", "blue", "green", "red", "pink", "cyan", "yellow"]
 private let commonSymbols = ["checkmark", "star.fill", "bolt.fill", "flame.fill", "heart.fill", "sparkles", "target", "gift.fill", "lightbulb.fill", "crown.fill"]

 var body: some View {
  NavigationStack {
   Form {
    // MARK: - Color Section
    Section("Color") {
     VStack(spacing: 12) {
      Text("Choose a color for your task")
       .font(.body)
       .foregroundColor(.textSecondary)

      ColorGridView(
       selectedColor: $taskColor,
       colors: availableColors,
       getColorValue: taskManager.getTaskColor(colorString:)
      )
     }
    }
    .listRowSeparator(.hidden)

    // MARK: - Symbol Section
    Section("Icon") {
     VStack(spacing: 12) {
      Text("Choose an icon for your task")
       .font(.body)
       .foregroundColor(.textSecondary)

      SymbolGridView(
       selectedSymbol: $taskSymbol,
       symbols: commonSymbols,
       taskColor: taskColor,
       getColorValue: taskManager.getTaskColor(colorString:)
      )
     }
    }
    .listRowSeparator(.hidden)

    // MARK: - Preview Section
    Section {
     PreviewView(
      taskColor: taskColor,
      taskSymbol: taskSymbol,
      getColorValue: taskManager.getTaskColor(colorString:)
     )
    }
    .listRowSeparator(.hidden)
   }
   .navigationTitle("Customize Task")
   .navigationBarTitleDisplayMode(.inline)
   .toolbar {
    ToolbarItem(placement: .topBarTrailing) {
     Button("Done") {
      dismiss()
     }
     .fontWeight(.semibold)
    }
   }
  }
 }
}

// MARK: - Color Grid View
private struct ColorGridView: View {
 @Binding var selectedColor: String
 let colors: [String]
 let getColorValue: (String) -> Color

 private let columnsPerRow = 4

 var body: some View {
  VStack(spacing: 12) {
   ForEach(0..<rowCount, id: \.self) { row in
    HStack(spacing: 12) {
     ForEach(0..<columnsPerRow, id: \.self) { col in
      let index = row * columnsPerRow + col

      if index < colors.count {
       ColorButtonView(
        color: colors[index],
        isSelected: selectedColor == colors[index],
        getColorValue: getColorValue,
        action: {
         withAnimation(.easeInOut(duration: 0.15)) {
          selectedColor = colors[index]
         }
        }
       )
      } else {
       Color.clear
        .frame(height: 60)
      }
     }
    }
   }
  }
 }

 private var rowCount: Int {
  (colors.count + columnsPerRow - 1) / columnsPerRow
 }
}

// MARK: - Color Button View
private struct ColorButtonView: View {
 let color: String
 let isSelected: Bool
 let getColorValue: (String) -> Color
 let action: () -> Void

 var body: some View {
  Button(action: action) {
   ZStack {
    Circle()
     .fill(getColorValue(color))
     .frame(height: 60)

    if isSelected {
     Circle()
      .stroke(Color.white, lineWidth: 3)
      .frame(height: 60)

     Image(systemName: "checkmark")
      .font(.body.weight(.semibold))
      .foregroundColor(.white)
    }
   }
  }
  .buttonStyle(.plain)
 }
}

// MARK: - Symbol Grid View
private struct SymbolGridView: View {
 @Binding var selectedSymbol: String
 let symbols: [String]
 let taskColor: String
 let getColorValue: (String) -> Color

 private let columnsPerRow = 5

 var body: some View {
  VStack(spacing: 12) {
   ForEach(0..<rowCount, id: \.self) { row in
    HStack(spacing: 12) {
     ForEach(0..<columnsPerRow, id: \.self) { col in
      let index = row * columnsPerRow + col

      if index < symbols.count {
       SymbolButtonView(
        symbol: symbols[index],
        isSelected: selectedSymbol == symbols[index],
        accentColor: getColorValue(taskColor),
        action: {
         withAnimation(.easeInOut(duration: 0.15)) {
          selectedSymbol = symbols[index]
         }
        }
       )
      } else {
       Color.clear
        .frame(height: 50)
      }
     }
    }
   }
  }
 }

 private var rowCount: Int {
  (symbols.count + columnsPerRow - 1) / columnsPerRow
 }
}

// MARK: - Symbol Button View
private struct SymbolButtonView: View {
 let symbol: String
 let isSelected: Bool
 let accentColor: Color
 let action: () -> Void

 var body: some View {
  Button(action: action) {
   ZStack {
    RoundedRectangle(cornerRadius: 12)
     .fill(isSelected ? accentColor.opacity(0.2) : Color.gray.opacity(0.1))
     .frame(height: 50)

    Image(systemName: symbol)
     .font(.body.weight(.semibold))
     .foregroundColor(isSelected ? accentColor : .gray)
   }
  }
  .buttonStyle(.plain)
 }
}

// MARK: - Preview View
private struct PreviewView: View {
 let taskColor: String
 let taskSymbol: String
 let getColorValue: (String) -> Color

 var body: some View {
  VStack(spacing: 12) {
   Text("Preview")
    .font(.headline)

   ZStack {
    Circle()
     .fill(getColorValue(taskColor).opacity(0.2))
     .frame(width: 70, height: 70)

    Image(systemName: taskSymbol)
     .font(.system(size: 28, weight: .semibold))
     .foregroundColor(getColorValue(taskColor))
   }
   .frame(maxWidth: .infinity)
   .padding(.vertical, 20)
  }
 }
}

// MARK: - Extension: TaskManager Color Helper
extension TaskManager {
 func getTaskColor(colorString: String) -> Color {
  switch colorString {
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

// MARK: - Preview
#Preview {
 ColorSymbolPickerView(
  taskColor: .constant("purple"),
  taskSymbol: .constant("checkmark")
 )
 .environment(\.taskManager, TaskManager())
}
