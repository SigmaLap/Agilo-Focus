import SwiftUI
import Foundation

struct MainView: View {
 @StateObject private var taskManager = TaskManager()

 var todayNumberSymbol: String {
  let day = Calendar.autoupdatingCurrent.component(.day, from: Date())
  return "\(day).calendar"
 }
 
 var body: some View {
   TabView {

    Tab("To-do", systemImage: "checkmark") {
     NavigationStack{
      HomeView()
     }
    }
    
//    Tab("Today", systemImage: todayNumberSymbol) {
//     NavigationStack{
//      TodayView()
//     }
//    }
    
   
    Tab {
     NavigationStack{
      FocusView()
     }
    } label: {
     Label {
      Text("Focus")
     } icon: {
      Image(systemName: "circle.circle", variableValue: 0.5)
     }
    }
    
//    Tab("Me", systemImage: "mouth") {
//     NavigationStack{
//      MeView()
//     }
//    }

    Tab(role: .search){
     NavigationStack{
      BacklogView()
     }
    }
    
   }
//   .tabViewBottomAccessory {
//    NavigationStack{
//     ProgressTaskFocus()
//    }
//   }
   .tabBarMinimizeBehavior(.onScrollDown)
   .environmentObject(taskManager)
 }
}
#Preview {
 MainView()
}
