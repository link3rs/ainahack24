//
//  AppViewModel.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//

import SwiftUI

enum DetailFields {
    case questionTextField//firstName , lastName, email, address, zipcode, username

}

final class AppViewModel:ObservableObject {
    enum Screens {
        case splash
        case welcome
        case login
        case access
    }
    
//    var currentUser: User?
//
//    init(currentUser: User? = .preview) {
//        self.currentUser = currentUser
//    }
    
    @Published var screen:Screens = .splash
    
    let persistence = AsyncPersistence.shared
    @Published var chatHistory: [String] = []
    @Published var chat: [Message] = []
    @Published var newLine = ""
    @Published var showError = false
    @Published var errorMsg = ""
    @Published var activateFlor = false
    @Published var selectedDialect = "Català Central" // Valor predeterminado para el dialecto
    let dialects = ["Català Central", "Català Valencià", "Català Balear", "Català Nord-occidental"]
    
    /*
    //MARK: - LOGINs
     
     func logout(){
         UserDefaults.standard.set("-", forKey: .kUserMail)
         currentUser = nil
         screen = .welcome
     }
     
     func tryLogin(email: String) {
         if !email.isEmpty {
             Task(priority: .userInitiated) {
                     await getLoginUser(email: email)
                 }
             }
     }
     
     func tryAutomaticLogin() {
         //UserDefaults.standard.set("luisla.tester@luisla.cm", forKey: .kUserMail) //To force wrong user in testing
         if let userEmail = UserDefaults.standard.string(forKey: .kUserMail) {
             Task(priority: .userInitiated) {
                 await getLoginUser(email: userEmail)
             }
         }
     }
     
    
    //MARK: - To change!!!!!!
     @MainActor func getLoginUser(email: String) async {
         do {
             let user = User.preview //try await AsyncPersistence.shared.checkUser(email: email)
             UserDefaults.standard.set(user.email, forKey: .kUserMail)
             currentUser = User.preview
             screen = .access
         } catch let error as APIErrors {
             errorMsg = error.description
         } catch {
             errorMsg = error.localizedDescription
         }
     }
    */
    @MainActor func postLine() async {
        do {
            chat.append(Message(role: "user", content: newLine))
            self.newLine = ""
            chat = try await persistence.postChat(conversation: chat)
            chat = try persistence.save(conversation: chat)

        } catch let error as APIErrors {
            errorMsg = error.description
            showError.toggle()
        } catch {
        }
    }

    
    
    
}
