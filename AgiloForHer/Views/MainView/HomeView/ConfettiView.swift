import SwiftUI
import AVFoundation

struct ConfettiView: View {
 @State private var confettiParticles: [ConfettiParticleData] = []
 @State private var isAnimating: Bool = false
 @State private var audioPlayer: AVAudioPlayer?

 var body: some View {
  TimelineView(.animation) { timeline in
   let now = timeline.date
   ZStack {
    ForEach(confettiParticles) { particle in
     let elapsed = now.timeIntervalSince(particle.createdAt)
     let lifetime = 1.2 // Shorter lifetime - 1.2 seconds total
     let t = min(max(elapsed / lifetime, 0), 1)

     // Slow upward float (first 60%)
     let floatPhase = min(t / 0.6, 1.0)
     let floatDistance = particle.upwardVelocity * CGFloat(floatPhase)

     // Settling phase (last 40% - gentle slowdown)
     let settlePhase = max((t - 0.6) / 0.4, 0)
     let settleDistance = floatDistance * (1 - settlePhase * settlePhase * 0.5)

     // Narrow horizontal drift for elegance
     let horizontalSpread = particle.horizontalOffset * CGFloat(min(t * 0.8, 1.0))

     // Smooth fade throughout, more pronounced at end
     let opacity = max(0, 1 - t * t * 1.2)

     let rotation = Angle(degrees: particle.initialRotation + particle.rotationSpeed * elapsed)

     ConfettiShapeView(
      type: particle.shapeType,
      color: particle.color,
      size: particle.size
     )
     .opacity(opacity)
     .rotationEffect(rotation)
     .offset(x: horizontalSpread, y: -settleDistance)
    }
   }
   .onChange(of: now) { _, _ in
    confettiParticles.removeAll {
     now.timeIntervalSince($0.createdAt) > 1.2 // Match lifetime
    }
   }
  }
  .allowsHitTesting(false)
  .ignoresSafeArea()
  .onAppear {
   triggerConfetti()
   playFinishSound()
  }
 }

 private func playFinishSound() {
  guard let url = Bundle.main.url(forResource: "finishSound", withExtension: "mp3") else {
   print("Sound file not found")
   return
  }

  do {
   audioPlayer = try AVAudioPlayer(contentsOf: url)
   audioPlayer?.volume = 0.3 // Set volume to 30% (range: 0.0 to 1.0)
   audioPlayer?.play()
  } catch {
   print("Error playing sound: \(error.localizedDescription)")
  }
 }

 private func triggerConfetti() {
  let shapeTypes: [ConfettiShapeType] = [
   .star, .circle, .rectangle, .star
  ]

  // Premium color palette - elegant and sophisticated
  let colors: [Color] = [
   Color(red: 1.0, green: 0.95, blue: 0.9),     // Champagne
   Color(red: 0.95, green: 0.85, blue: 0.9),    // Rose gold
   Color(red: 1.0, green: 0.92, blue: 0.7),     // Light gold
   Color(red: 0.96, green: 0.88, blue: 0.88),   // Warm beige
   Color(red: 1.0, green: 0.98, blue: 0.95),    // Ivory
   Color(red: 0.99, green: 0.92, blue: 0.85)    // Soft taupe
  ]

  // Create 20 confetti particles - elegant, not overwhelming
  for _ in 0..<20 {
   let shapeType = shapeTypes.randomElement() ?? .circle
   let color = colors.randomElement() ?? .white

   // Narrow horizontal spread for refined feel
   let horizontalOffset = CGFloat.random(in: -50...50)

   // Slow, graceful upward float
   let upwardVelocity = CGFloat.random(in: 300...450)

   // Not used in new physics, kept for data model compatibility
   let downwardVelocity = CGFloat.random(in: 0...0)

   let particle = ConfettiParticleData(
    shapeType: shapeType,
    color: color,
    size: CGFloat.random(in: 4...10),  // Smaller, more refined
    initialRotation: Double.random(in: 0...360),
    rotationSpeed: Double.random(in: -120...120),  // Slower rotation
    horizontalOffset: horizontalOffset,
    upwardVelocity: upwardVelocity,
    downwardVelocity: downwardVelocity,
    createdAt: Date()
   )
   confettiParticles.append(particle)
  }
 }
}

// MARK: - Confetti Shape Types
enum ConfettiShapeType {
 case star
 case circle
 case rectangle
}

// MARK: - Confetti Shape View
struct ConfettiShapeView: View {
 let type: ConfettiShapeType
 let color: Color
 let size: CGFloat

 var body: some View {
  switch type {
  case .star:
   Image(systemName: "star.fill")
    .font(.system(size: size * 0.8, weight: .semibold))
    .foregroundColor(color)

  case .circle:
   Circle()
    .fill(color)
    .frame(width: size, height: size)

  case .rectangle:
   RoundedRectangle(cornerRadius: size * 0.25)
    .fill(color)
    .frame(width: size * 1.2, height: size * 0.6)
  }
 }
}

// MARK: - Confetti Particle Data Model
struct ConfettiParticleData: Identifiable {
 let id = UUID()
 let shapeType: ConfettiShapeType
 let color: Color
 let size: CGFloat
 let initialRotation: Double
 let rotationSpeed: Double // degrees per second
 let horizontalOffset: CGFloat // slight horizontal spread
 let upwardVelocity: CGFloat // fast upward speed (pixels)
 let downwardVelocity: CGFloat // slow downward speed (pixels)
 let createdAt: Date
}

#Preview {
 ZStack {
  Color.white
   .ignoresSafeArea()
  ConfettiView()
 }
}
