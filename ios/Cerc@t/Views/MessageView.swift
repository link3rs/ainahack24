//
//  MessageView.swift
//  Cerc@t
//
//  Created by Judith Cardona on 8/11/24.
//
//import SwiftUI
//
//struct MessageView: View {
//    var message: Message
//    
//    var body: some View {
//        HStack {
//            if message.isUser {
//                Spacer()
//                Text(message.text)
//                    .padding()
//                    .background(Color.blue.opacity(0.2))
//                    .foregroundColor(.primary)
//                    .cornerRadius(16)
//                    .frame(maxWidth: 250, alignment: .trailing)
//                    .shadow(radius: 2)
//            } else {
//                Text(message.text)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .foregroundColor(.primary)
//                    .cornerRadius(16)
//                    .frame(maxWidth: 250, alignment: .leading)
//                    .shadow(radius: 2)
//                Spacer()
//            }
//        }
//        .padding(message.isUser ? .trailing : .leading)
//    }
//}
