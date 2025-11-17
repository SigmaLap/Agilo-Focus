
import SwiftUI
import SwiftData

@main
struct AgiloForHer: App {
 
 var body: some Scene {
  WindowGroup {
   //    if isAuthenticating {
   //     ProgressView()
   //      .task {
   //       await initializeApp()
   //      }
   //    } else if !isUserAuthenticated() {
   //     if let authViewModel = authViewModel {
   //      SignInView(viewModel: authViewModel) {
   //       // User signed in successfully
   //       showProfileSetup = true
   //      }
   //     }
   //    } else if showProfileSetup {
   //     ProfileSetupView(
   //      authViewModel: authViewModel!,
   //      persistence: persistence
   //     ) {
   //      showProfileSetup = false
   //      showOnboarding = !UserDefaults.standard.bool(forKey: UserDefaultsKeys.onboardingComplete)
   //     }
   //    } else if showOnboarding {
   //     if let authViewModel = authViewModel {
   //      OnboardingFlow(
   //       persistence: persistence,
   //       authViewModel: authViewModel
   //      ) {
   //       showOnboarding = false
   //      }
   //     }
   //    } else {
   MainView()
    .modelContainer(for: [Task.self, SubTask.self, DailyEnergy.self])
   //    }
  }
  //  .modelContainer(persistence.container)
 }
 
}
