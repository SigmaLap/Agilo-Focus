import SwiftUI

struct FocusView: View {
 @State private var timerMinutes: Int = 18
 @State private var timerSeconds: Int = 32
 @State private var isRunning: Bool = false
 @State private var selectedDuration: Int = 25
 @State private var progress: Double = 0.26 // 26% complete (dummy data)
 @State private var showTimerCompleteConfetti: Bool = false

 let durations = [15, 25, 45, 60]

 var body: some View {
  
  ZStack {
   ScrollView {
    VStack(spacing: 40) {
     // Timer Display
     VStack(spacing: 20) {
      Text("Focus")
       .font(.largeTitle.weight(.ultraLight))
       .foregroundColor(.blackPrimary)
       .fontDesign(.serif)
       .padding(.bottom, -32)


      // Circular Timer
      ZStack{
       CircularTimer()
      }
     }
     .padding(.top, 48)

     // Control Buttons
     HStack() {
      Button(action: {
       isRunning.toggle()
       if isRunning {
        // TODO: Start timer and check for completion
        // When timer reaches 100%, trigger:
        // showTimerCompleteConfetti = true
        // Then hide after 2.5 seconds
       }
      }) {
       HStack(spacing: 12) {
        Image(systemName: isRunning ? "pause.fill" : "play.fill")
         .font(.title2)
        Text(isRunning ? "Pause" : "Start")
         .font(.headline)
         .fontDesign(.serif)
       }
       .foregroundStyle(.primary)
       .padding(.horizontal, 24)
       .padding(10)
      }
      .buttonStyle(.glass)

     }
     .padding(.top, -52)

    }
    .padding(.top, 68)
   }

   // Confetti overlay - shows when timer is completed
   if showTimerCompleteConfetti {
    ConfettiView()
   }
  }
 }
}


#Preview {
 FocusView()
}



struct CircularTimer: View {
 @State private var progress: CGFloat = 22.0 / 60.0
 private let totalMinutes: CGFloat = 60
 private let ringWidth: CGFloat = 35
 @State private var minuteForHaptics: Int = 22
 
 // Confetti state
 @State private var confettiParticles: [ConfettiParticle] = []
 @State private var lastConfettiEmission: Date = .distantPast
 
 var body: some View {
  ZStack {
   // Track ring
   Circle()
    .stroke(Color.softSalmon.opacity(0.18), lineWidth: ringWidth)
    .frame(width: 240, height: 240)
   
   GeometryReader { geo in
    let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
    
    ZStack {
     // Outer progress arc
     Circle()
      .trim(from: 0, to: progress)
      .stroke(
       Color.softSalmon,
       style: StrokeStyle(lineWidth: ringWidth, lineCap: .round)
      )
      .rotationEffect(.degrees(-90))
      .animation(.linear(duration: 0.12), value: progress)
      .frame(width: 240, height: 240)
     
     // Inner dashed indicator arc
     Circle()
      .trim(from: 0, to: progress)
      .stroke(
       Color.textSecondary.opacity(0.2),
       style: StrokeStyle(
        lineWidth: 10,
        lineCap: .butt,
        dash: [2, 4]
       )
      )
      .rotationEffect(.degrees(-90))
      .frame(width: 240, height: 240)
    }
    .gesture(
     DragGesture(minimumDistance: 0)
      .onChanged { value in
       let v = CGVector(dx: value.location.x - center.x,
                        dy: value.location.y - center.y)
       var theta = (atan2(v.dy, v.dx) + .pi / 2)
       if theta < 0 { theta += 2 * .pi }
       var newProgress = theta / (2 * .pi)
       newProgress = min(max(newProgress, 0), 1)
       progress = newProgress
       
       // Confetti emission (throttled)
       let now = Date()
       if now.timeIntervalSince(lastConfettiEmission) > 0.15 {
        lastConfettiEmission = now
        emitConfetti(atAngle: theta)
       }
       
       // Haptics
       let minute = Int(round(progress * totalMinutes))
       if minute != minuteForHaptics {
        minuteForHaptics = minute
        playLegacyHaptic()
       }
      }
    )
   }
   
   // Center labels
   ZStack {
    VStack(spacing: 6) {
     Text("\(Int(round(progress * totalMinutes)))")
      .font(.system(size: 48, weight: .ultraLight, design: .serif))
     Text("MINS")
      .font(.title3.weight(.regular))
    }
    
    VStack {
     Text("60")
     Spacer()
     Text("30")
    }
    .foregroundStyle(.secondary)
    .font(.headline.weight(.ultraLight))
    
    HStack {
     Text("45")
     Spacer()
     Text("15")
    }
    .foregroundStyle(.secondary)
    .font(.headline.weight(.ultraLight))
   }
   .fontDesign(.serif)
   .frame(width: 190, height: 190)
  }
  .frame(width: 240, height: 240)
  // ✅ Confetti overlay (no blocking gestures)
  .overlay(
   TimelineView(.animation) { timeline in
    let now = timeline.date
    ZStack {
     ForEach(confettiParticles) { particle in
      let elapsed = now.timeIntervalSince(particle.createdAt)
      let t = min(max(elapsed / particle.lifetime, 0), 1)
      let baseRadius: CGFloat = 120
      let travel = CGFloat(particle.speed) * CGFloat(elapsed)
      let radius = baseRadius + travel
      let x = cos(particle.angle) * radius
      let y = sin(particle.angle) * radius
      
      let opacity = max(0, 1 - t)
      let scale = 0.8 + 0.6 * (1 - t)
      let rotation = Angle(degrees: particle.initialRotation +
                           (particle.rotationSpeedDegPerS * elapsed))
      
      Image(systemName: particle.symbolName)
       .font(.system(size: particle.size, weight: .semibold, design: .rounded))
       .foregroundStyle(Color.softSalmon.opacity(0.9))
       .opacity(opacity)
       .scaleEffect(scale)
       .rotationEffect(rotation)
       .offset(x: x, y: y)
     }
    }
    .onChange(of: now) { _, _ in
     confettiParticles.removeAll {
      now.timeIntervalSince($0.createdAt) > $0.lifetime
     }
    }
   }
    .allowsHitTesting(false) // 👈 important line
  )
  .modifier(SensoryFeedbackModifier(trigger: minuteForHaptics))
  .padding(75)
 }
 
 // MARK: - Legacy haptics
 private func playLegacyHaptic() {
  if #available(iOS 17, *) {
   // handled by modifier
  } else {
   let generator = UIImpactFeedbackGenerator(style: .light)
   generator.impactOccurred()
  }
 }
 
 // MARK: - Confetti
 private func emitConfetti(atAngle angle: CGFloat, count: Int = 1) {
  let symbols = [
   "flame.fill",
   "bolt.fill",
   "heart.fill",
   "moon.fill",
   "leaf.fill"
  ]
  
  for _ in 0..<count {
   let particleAngle = Double(angle) - 1
   let lifetime = Double.random(in: 1.6...2.6)
   let speed = Double.random(in: 50...90)
   let symbol = symbols.randomElement() ?? "moon.fill"
   let initialRotation = Double.random(in: 0...360)
   let rotationSpeed = Double.random(in: -180...180)
   let size = CGFloat.random(in: 4...22)
   
   let particle = ConfettiParticle(
    createdAt: Date(),
    angle: particleAngle,
    speed: speed,
    lifetime: lifetime,
    symbolName: symbol,
    initialRotation: initialRotation,
    rotationSpeedDegPerS: rotationSpeed,
    size: size
   )
   confettiParticles.append(particle)
  }
 }
}

// MARK: - Confetti model
struct ConfettiParticle: Identifiable {
 let id = UUID()
 let createdAt: Date
 let angle: Double
 let speed: Double
 let lifetime: Double
 let symbolName: String
 let initialRotation: Double
 let rotationSpeedDegPerS: Double
 let size: CGFloat
}


// Wrap sensoryFeedback so it compiles on older SDKs
struct SensoryFeedbackModifier: ViewModifier {
 var trigger: Int
 func body(content: Content) -> some View {
  if #available(iOS 17, *) {
   content.sensoryFeedback(.selection, trigger: trigger)
  } else {
   content
  }
 }
}

private extension CGFloat {
 var deg: CGFloat { self * 180 / .pi }
}
