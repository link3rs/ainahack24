//
//  ChatHistoryView.swift
//  Cerc@t
//
//  Created by Judith Cardona on 8/11/24.
//
import SwiftUI

struct ChatHistoryView: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        NavigationView {
            List(vm.chatHistory, id: \.self) { chat in
                Text(chat)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 8)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Historial de Chats")
//            .navigationBarItems(trailing: Button(action: {
//                vm.startNewChat()
//            }) {
//                Text("Nuevo Chat")
//                    .foregroundColor(.blue)
//            })
        }
    }
}
