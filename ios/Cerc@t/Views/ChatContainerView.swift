//
//  InsideChatView.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//
import SwiftUI

struct ChatContainerView: View {
    @EnvironmentObject var vm: AppViewModel
    @FocusState var focusField:DetailFields?
    @State var showKeyboard = true
    
    var body: some View {
        GeometryReader { proxy in
            LazyVStack {
                ScrollView {
                    ScrollViewReader { reader in
                        ForEach(vm.chat) { message in
                            ChatCellView(message:message)
                        }
                        .onChange(of:vm.chat) { newValue in
                            if let last = newValue.last {
                                reader.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                .padding()
                //    .frame (maxWidth: .infinity)
                //    .frame (height: 450)
                .frame(maxWidth: .infinity)
                .frame(height: proxy.size.height)
//                .background{
//                    //Color.aYellow
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.black.opacity(0.1))
//                }
                //.padding(.vertical, 100)
            }
            
        }
    }
}

struct ChatContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ChatContainerView()
            .environmentObject(AppViewModel())
    }
}
