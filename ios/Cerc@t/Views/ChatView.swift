//
//  ChatView.swift
//  Cerc@t
//
//  Created by Judith Cardona on 8/11/24.
//


import SwiftUI

struct ChatView: View {
    @EnvironmentObject var vm: AppViewModel
    //@StateObject private var chatModel = ChatModel()
    //@State private var newMessage = ""
    @State private var showChatHistory = false
    @State private var showSettings = false 
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    @Binding var showVoiceChat: Bool

    var body: some View {
        VStack {
            // Barra superior con botón para abrir el historial de chats
            HStack {
                Button(action: {
                    showChatHistory.toggle()
                }) {
                    Image(systemName: "list.bullet")
                        .font(.title2)
                        .foregroundColor(Color("Carbon"))
                }
                .sheet(isPresented: $showChatHistory) {
                    ChatHistoryView()
                        .presentationDetents([.medium, .large])
                }
                
                Spacer()
                
                Text("Nova cerc@")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Botón de engranaje para abrir SettingsView en pantalla completa
                Button(action: {
                    showSettings.toggle() // Activa la vista de configuración
                }) {
                    Image(systemName: "gear")
                        .font(.title2)
                        .foregroundColor(Color("Carbon"))
                }
                .fullScreenCover(isPresented: $showSettings) { // Presenta SettingsView en pantalla completa
                    SettingsView()
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .shadow(radius: 1)
            
//            ScrollView {
//                VStack(alignment: .leading, spacing: 10) {
//                    ForEach(chatModel.messages, id: \.id) { message in
//                        MessageView(message: message)
//                    }
//                }
//                .padding()
//            }
            ChatContainerView()
            
            // Campo de entrada de mensaje y botones
            HStack {
                
                TextField("Escriu un missatge...", text: $vm.newLine, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .shadow(radius: 1)
                    .onSubmit {
                        sendMessage()
                    }
                
                // Icono paperplane para enviar el mensaje
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color("Carbon"))
                        .shadow(radius: 1)
                }
                
                // Icono mic para activar el modo de voz
                Button(action: {
                    showVoiceChat.toggle()
                }) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color("Carbon"))
                        .shadow(radius: 1)
                }
            }
            .padding()
            .background(Color.white)
            .offset(y: -keyboardResponder.currentHeight)
            .animation(.easeOut(duration: 0.3), value: keyboardResponder.currentHeight)
        }
        .padding(.bottom, keyboardResponder.currentHeight)
        .edgesIgnoringSafeArea(keyboardResponder.currentHeight > 0 ? .bottom : [])
    }
    
    private func sendMessage() {
        Task { await vm.postLine() }
    }
}

#Preview {
    ChatView(showVoiceChat: .constant(false))
        .environmentObject(AppViewModel())
}

