//
//  WaveAnimationView.swift
//  Cerc@t
//
//  Created by Judith Cardona on 8/11/24.
//
import SwiftUI

struct WaveAnimationView: View {
    @Binding var isRecording: Bool

    var body: some View {
        ZStack {
            // Círculo inicial sólido y opaco que se transforma suavemente
            Circle()
                .fill(Color("Chili"))
                .frame(width: isRecording ? 330 : 200, height: isRecording ? 330 : 200) // Tamaño inicial grande
                .scaleEffect(isRecording ? 0.2 : 1) // Transición de tamaño suave
                .opacity(isRecording ? 0 : 1) // Desaparece suavemente al activar isRecording
                .animation(Animation.easeInOut(duration: 1), value: isRecording)

            // Ondas circundantes que se expanden
            ForEach(0..<5) { i in
                Circle()
                    .stroke(Color("Chili").opacity(0.9 - Double(i) * 0.2), lineWidth: isRecording ? 3 : 6)
                    .frame(width: CGFloat(100 + (i * 30)), height: CGFloat(100 + (i * 30)))
                    .scaleEffect(isRecording ? 1 : 0.3) // Transición suave de escala
                    .opacity(isRecording ? 0.8 - Double(i) * 0.2 : 0) // Transición suave de opacidad
                    .animation(
                        Animation.easeInOut(duration: 1.5 - Double(i) * 0.3)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.2),
                        value: isRecording
                    )
            }
        }
    }
}
