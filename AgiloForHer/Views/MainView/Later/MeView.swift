import SwiftUI

struct MeView: View {
 
 var body: some View {
  ZStack {
   Color.background
    .ignoresSafeArea()
   
   ScrollView {
    VStack{
     Text("""
           IntegrationS
           - Calendre and Reminders
           - Notion Tasks
           We are not a replacement to other tools we are the last puzzle piece you need to guide you the how you will achieving these goals you set
           """)
    }
    
    
   }
   .navigationTitle("Profile")
   .navigationBarTitleDisplayMode(.large)
   
   .toolbar{
    ToolbarItem{
     Image(systemName: "gears")
    }
   }
  }
 }
}

#Preview {
 MeView()
}

