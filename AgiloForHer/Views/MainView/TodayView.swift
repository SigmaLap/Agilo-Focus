
import SwiftUI

struct TodayView: View {
 @State private var timerMinutes: Int = 18
 @State private var timerSeconds: Int = 32
 @State private var isRunning: Bool = false
 @State private var selectedDuration: Int = 25
 @State private var progress: Double = 0.26 // 26% complete (dummy data)
 
 let durations = [15, 25, 45, 60]
 
 var body: some View {
  
  ScrollView {
   VStack(alignment: .center){
    Text("Don’t Organize anything don’t worry we take good care of that - We focusing more on Doing")
    Text("Ai Card")
    Text("then chatting with the user to understand his requirements in memory (Would ask her about her name, do you have ADHD or hard in focus?,what is your Dreams in Career Life? we will make together a 5 years plan would you ?, now give us activities you do (Or like to do) in your day and when you like to do them (Reading, Gym). Do you like after work hours to be family time or you are open to work as late as you want)")
    Divider()
    Text("📅 Daily Execution Plan: November 6, 2025 (Thursday)")
    Text("""
        Strategic context: Year 1 - Month 1 - Week 1 - Day 6
        ,Sprint, Agilo v3.0 ADHD Pivot + Brand Foundation
        Days Until v3.0 Ship: 13 days
        
        💭 Motivational Quote: "fdsddsF"
        
        💡 Tip of the Day: Since you’re building the remaining tabs today, master the distinction between @State, @StateObject, and @ObservedObject. For Agilo’s energy-based task system, you’ll need @StateObject for your ViewModel pattern. Study this 30-minute Kodeco lesson during your learning block today: “Manage Model Data in Your App”
        """)
    Divider()
    Text("Do you feel low continue?")
    Text("How is your energy card?")
    Text("We will adjust things based on that")
    Text("Smart sorting: Match tasks to energy")
    Divider()
    Text("""
         Pattern Recognition
         - "You usually do X at 10am"
         - "Tuesdays are your productive days
         """)
    Text("""
         - Always Show in the HomeView some indication that the user make a progress. (3 Circles, Progress Bars)
         - Show a section for users Level in Gamification
         """)
    
    Text("""
         Cycle-Aware Task Suggestions
         "You're in your ovulation phase - great time for presentations/meetings!"
         "Luteal phase detected - focus on writing and planning tasks"
          
         """)
         
    Text("Automatically adjust task recommendations based on energy patterns")
    Text("Hormonal pattern visualization")
    Text("PMS/PMDD symptom alerts")
    Text("""
        Give Reccomnedations like
        High-intensity training recommended this week"
                 Rest day reminders during menstruation
        Hormonal Mood Pattern Recognition
        Detect emotional patterns across your cycle
        PMS/PMDD symptom alerts
        "Mood dip expected in 3 days"
        Journal entries tied to cycle phase
        Stress Management by Phase
        Luteal phase: Extra stress management tools
        Grounding exercises and breathing techniques
        "You might feel more anxious this week - here's your calm toolkit"
        Women-Focused Goals
        Cycle-aware goal setting (don't schedule major reviews during menstruation)
        "Better time to make big decisions during follicular phase"
        Balance ambition with cycle awareness
        Anonymous aggregate data: "Women report highest energy during ovulation"

        """)
    
   }
   .padding()
   
  }
 }
}



#Preview {
 TodayView()
}


