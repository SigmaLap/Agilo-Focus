import SwiftUI

struct ColorSymbolPickerView: View {
 @Binding var taskColor: String
 @Binding var taskSymbol: String
 @Environment(\.dismiss) private var dismiss

 let getColorValue: (String) -> Color

 private let availableColors = ["purple", "orange", "blue", "green", "red", "pink", "cyan", "yellow"]
 private let commonSymbols = ["checkmark", "star.fill", "bolt.fill", "flame.fill", "heart.fill", "sparkles", "target", "gift.fill", "lightbulb.fill", "crown.fill"]

 var body: some View {
  NavigationStack {
   Form {
    Section("Color") {
     VStack(spacing: 12) {
      Text("Choose a color for your task")
       .font(.body)
       .foregroundColor(.textSecondary)

      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
       ForEach(availableColors, id: \.self) { color in
        Button(action: { taskColor = color }) {
         ZStack {
          Circle()
           .fill(getColorValue(color))
           .frame(height: 60)

          if taskColor == color {
           Circle()
            .stroke(Color.white, lineWidth: 3)
            .frame(height: 60)

           Image(systemName: "checkmark")
            .font(.body.weight(.semibold))
            .foregroundColor(.white)
          }
         }
        }
       }
      }
    }
    }
    .listRowSeparator(.hidden)

    Section("Icon") {
     VStack(spacing: 12) {
      Text("Choose an icon for your task")
       .font(.body)
       .foregroundColor(.textSecondary)

      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
       ForEach(commonSymbols, id: \.self) { symbol in
        Button(action: { taskSymbol = symbol }) {
         ZStack {
          RoundedRectangle(cornerRadius: 12)
           .fill(taskSymbol == symbol ? getColorValue(taskColor).opacity(0.2) : Color.gray.opacity(0.1))
           .frame(height: 50)

          Image(systemName: symbol)
           .font(.body.weight(.semibold))
           .foregroundColor(taskSymbol == symbol ? getColorValue(taskColor) : .gray)
         }
        }
       }
      }
     }
    }
    .listRowSeparator(.hidden)

    Section {
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

#Preview {
 ColorSymbolPickerView(
  taskColor: .constant("purple"),
  taskSymbol: .constant("checkmark"),
  getColorValue: { color in
   switch color {
   case "purple": return .purple
   case "orange": return .orange
   case "blue": return .blue
   case "green": return .green
   case "red": return .red
   case "pink": return .pink
   case "cyan": return .cyan
   case "yellow": return .yellow
   default: return .purple
   }
  }
 )
}
