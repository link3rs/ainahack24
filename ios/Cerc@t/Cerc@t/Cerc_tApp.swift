//
//  Cerc_tApp.swift
//  Cerc@t
//
//  Created by Judith Cardona on 8/11/24.
//
import SwiftUI

@main
struct Cerc_tApp: App {
    @StateObject var vm = AppViewModel()
    @StateObject var monitorNetwork = NetworkStatus()
    
    var body: some Scene {
        WindowGroup {
            MainChatView() // Pantalla de chatbot como pantalla principal
                .environmentObject(vm)
                .overlay {
                    if monitorNetwork.status != .online {
                        OfflineView()
                            .transition(.opacity)
                    }
                }
        }
 
    }
}
