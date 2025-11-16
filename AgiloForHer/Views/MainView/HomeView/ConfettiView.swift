import SwiftUI
import AVFoundation

struct ConfettiView: View {
 @State private var confettiParticles: [ConfettiParticleData] = []
 @State private var premiumParticles: [PremiumParticleData] = []
 @State private var audioPlayer: AVAudioPlayer?

 var body: some View {
  TimelineView(.animation) { timeline in
   let now = timeline.date
   ZStack {
    // Premium glow particles (background)
    ForEach(premiumParticles) { particle in
     let elapsed = now.timeIntervalSince(particle.createdAt)
     let lifetime = 2.0
     let t = min(max(elapsed / lifetime, 0), 1)

     // Premium glow burst
     let distance = particle.glowVelocity * CGFloat(t)
     let angle = particle.glowAngle
     let x = distance * cos(angle)
     let y = distance * sin(angle)

     // Fade effect
     let opacity = max(0, 1 - t) * 0.6

     Circle()
      .fill(particle.glowColor)
      .frame(width: particle.glowSize, height: particle.glowSize)
      .opacity(opacity)
      .blur(radius: 2)
      .offset(x: x, y: y)
    }

    // Regular confetti particles (foreground)
    ForEach(confettiParticles) { particle in
     let elapsed = now.timeIntervalSince(particle.createdAt)
     let lifetime = 1.5
     let t = min(max(elapsed / lifetime, 0), 1)

     // Energetic burst outward from center
     let distance = particle.burstVelocity * CGFloat(t)
     let angle = particle.burstAngle
     let x = distance * cos(angle)
     let y = distance * sin(angle)

     // Gravity effect in second half
     let gravityPhase = max((t - 0.5) / 0.5, 0)
     let gravityOffset = gravityPhase * gravityPhase * 200

     // Spinning rotation
     let rotation = Angle(degrees: particle.initialRotation + particle.rotationSpeed * elapsed)

     // Fade out at the end
     let opacity = max(0, 1 - (t - 0.7) * 3)

     ConfettiShapeView(
      type: particle.shapeType,
      color: particle.color,
      size: particle.size
     )
     .opacity(opacity)
     .rotationEffect(rotation)
     .offset(x: x, y: y + gravityOffset)
    }
   }
   .onChange(of: now) { _, _ in
    confettiParticles.removeAll {
     now.timeIntervalSince($0.createdAt) > 1.5
    }
    premiumParticles.removeAll {
     now.timeIntervalSince($0.createdAt) > 2.0
    }
   }
  }
  .allowsHitTesting(false)
  .ignoresSafeArea()
  .onAppear {
   triggerConfetti()
   triggerPremiumGlow()
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
   audioPlayer?.volume = 0.05 // Much quieter - 5% volume
   audioPlayer?.play()
  } catch {
   print("Error playing sound: \(error.localizedDescription)")
  }
 }

 private func triggerPremiumGlow() {
  // Premium glow colors (translucent, premium look)
  let glowColors: [Color] = [
   Color.blue.opacity(0.4),
   Color.purple.opacity(0.4),
   Color.pink.opacity(0.4),
   Color.cyan.opacity(0.4),
   Color.yellow.opacity(0.3),
  ]

  // Create 30 premium glow particles for premium effect
  for _ in 0..<30 {
   let glowColor = glowColors.randomElement() ?? Color.blue.opacity(0.4)

   // Burst outward in all directions from center
   let angle = Double.random(in: 0...(2 * .pi))
   let glowVelocity = CGFloat.random(in: 100...250)

   let particle = PremiumParticleData(
    glowColor: glowColor,
    glowSize: CGFloat.random(in: 20...50),
    glowVelocity: glowVelocity,
    glowAngle: angle,
    createdAt: Date()
   )
   premiumParticles.append(particle)
  }
 }

 private func triggerConfetti() {
  let shapeTypes: [ConfettiShapeType] = [
   .star, .circle, .square, .diamond
  ]

  // Vibrant, energetic colors - premium palette
  let colors: [Color] = [
   Color(red: 0.4, green: 0.8, blue: 1.0),     // Bright cyan
   Color(red: 0.8, green: 0.2, blue: 0.8),     // Bright magenta
   Color(red: 1.0, green: 0.4, blue: 0.6),     // Coral pink
   Color(red: 0.6, green: 0.8, blue: 1.0),     // Sky blue
   Color(red: 1.0, green: 0.8, blue: 0.2),     // Gold
   Color(red: 0.2, green: 1.0, blue: 0.6),     // Mint
   Color(red: 1.0, green: 0.3, blue: 0.3),     // Crimson
   Color(red: 0.6, green: 0.4, blue: 1.0)      // Violet
  ]

  // Create 60 particles for premium energetic burst
  for _ in 0..<60 {
   let shapeType = shapeTypes.randomElement() ?? .circle
   let color = colors.randomElement() ?? Color.blue

   // Burst outward in all directions from center
   let angle = Double.random(in: 0...(2 * .pi))
   let burstVelocity = CGFloat.random(in: 200...450)

   let particle = ConfettiParticleData(
    shapeType: shapeType,
    color: color,
    size: CGFloat.random(in: 6...18),
    initialRotation: Double.random(in: 0...360),
    rotationSpeed: Double.random(in: 300...720),
    burstAngle: angle,
    burstVelocity: burstVelocity,
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
 case square
 case diamond
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

  case .square:
   RoundedRectangle(cornerRadius: size * 0.15)
    .fill(color)
    .frame(width: size, height: size)

  case .diamond:
   Image(systemName: "diamond.fill")
    .font(.system(size: size * 0.9, weight: .semibold))
    .foregroundColor(color)
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
 let rotationSpeed: Double
 let burstAngle: Double
 let burstVelocity: CGFloat
 let createdAt: Date
}

// MARK: - Premium Glow Particle Data Model
struct PremiumParticleData: Identifiable {
 let id = UUID()
 let glowColor: Color
 let glowSize: CGFloat
 let glowVelocity: CGFloat
 let glowAngle: Double
 let createdAt: Date
}

#Preview {
 ZStack {
  Color.white
   .ignoresSafeArea()
  ConfettiView()
 }
}
