import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var name = ""
    @State private var surname = ""
    @State private var dni = ""
    @State private var email = ""
    @State private var city = ""
    @State private var personalDescription = ""

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Configuracions de llenguatge").font(.headline)) {
                    Picker("Selecciona el dialecte", selection: $vm.selectedDialect) {
                        ForEach(vm.dialects, id: \.self) { dialect in
                            Text(dialect)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Informació Personal").font(.headline)) {
                    TextField("Nom", text: $name)
                    TextField("Cognoms", text: $surname)
                    TextField("DNI", text: $dni)
                    TextField("Correu Electrònic", text: $email)
                        .keyboardType(.emailAddress) // Teclado específico para correos electrónicos
                    TextField("Població", text: $city)
                    TextField("Descripció Personal", text: $personalDescription)
                        .lineLimit(3) // Limita a 3 líneas para descripciones largas
                }
            }
            .navigationTitle("Configuració")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Tornar")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
