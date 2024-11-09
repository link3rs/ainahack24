//
//  ChatCellView.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//

import SwiftUI

struct ChatCellView: View {
    let message: Message
    
    var body: some View {
//        GeometryReader { proxy in
            if message.role == "user" {
                HStack {
                    Spacer(minLength: 40)
                    //Text(message.content.toMarkdown())
                    Text(message.content)
                        .padding(10)
                    //                        .frame(width: proxy.size.width*9/10, alignment:.trailing)
                        .frame(maxWidth: .infinity, alignment:.trailing)
                        .background {
                            RoundedRectangle (cornerRadius: 10, style: .continuous)
                                .fill(.blue.opacity (0.2))
                            
                            
                    }
//                        .onTapGesture {
//                            UIPasteboard.general.string = message.content
//                        }
                }
                .id(message.id)
            } else {
                HStack {
                    //Text(message.content.toMarkdown())
                    Text(message.content)
                        .padding (10)
//                        .frame(width: proxy.size.width*9/10, alignment:.leading)
                        .frame(maxWidth: .infinity, alignment:.leading)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.brown.opacity(0.2))
                        }
//                        .contextMenu {
//                            Button {
//                                UIPasteboard.general.string = message.content
//                            } label: {
//                                Text("Copy")
//                                Image(systemName: "doc.on.doc")
//                            }
//                        }

//                        .onTapGesture {
//                            UIPasteboard.general.string = message.content
//                        }
                    Spacer(minLength: 40)
                }
                .id (message.id)
            }
//        }
    }
}

struct ChatCellView_Previews: PreviewProvider {
    static var myContent = """
```swift
    struct Sightseeing: Activity {
        func perform(with sloth: inout Sloth) -> Speed {
            sloth.energyLevel -= 10
            return .slow
        }
    }
    ```
"""
    static var previews: some View {
        VStack {
                ChatCellView(message: Message(role: "assistant", content:myContent))
                ChatCellView(message: Message(role: "user", content:"testing" ))
        }
    }
}
