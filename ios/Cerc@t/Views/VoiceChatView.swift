import SwiftUI

struct VoiceChatView: View {
    @Binding var isPresentingVoiceChat: Bool
    @State private var isRecording = false
    @StateObject var audioVM = AudioVM()
    @StateObject var speakVM = SpeakVM()

    var body: some View {
        VStack {
            // Imagen en la parte superior
            Image("cerc@t") // Nombre de la imagen en los Assets
                .resizable()
                .scaledToFit()
                .frame(height: 150) // Ajusta la altura según sea necesario
                .padding(.top, 15)

            Spacer()

            // Animación de ondas en el centro
            WaveAnimationView(isRecording: $isRecording)
                .frame(width: 200, height: 200)
                .padding(.bottom, 10)
                .onTapGesture {
                    isRecording.toggle()
                    isRecording ? audioVM.startRecord(time: 6) : audioVM.stopRecord()
                }

            Spacer()

            // Botón para salir del modo de voz
            Button(action: {
                isPresentingVoiceChat = false
                   // Regresa a la pantalla principal del chat
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color("Redd"))
                    .padding()
            }
            .padding(.bottom, 40) // Ajusta la posición en la parte inferior
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    VoiceChatView(isPresentingVoiceChat: .constant(true))
}
