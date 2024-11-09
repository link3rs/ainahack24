//
//  MainChatView.swift
//  Cerc@t
//
//  Created by Judith Cardona on 9/11/24.
//
import SwiftUI

struct MainChatView: View {
    @State private var showVoiceChat = false
    @EnvironmentObject var vm: AppViewModel
    @FocusState var focusField:DetailFields?



    
    var body: some View {
            VStack {
                // Vista del chat principal
                ChatView(showVoiceChat: $showVoiceChat)
            }
            .sheet(isPresented: $showVoiceChat) {
                VoiceChatView(isPresentingVoiceChat: $showVoiceChat)
            }
//        .edgesIgnoringSafeArea(.all)
    }
}

// #Preview para MainChatView en SwiftUI 5
#Preview {
    MainChatView()
        .environmentObject(AppViewModel())
}
