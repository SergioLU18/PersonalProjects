//
//  RegisterView.swift
//  QR_Generator
//
//  Created by Alumno on 22/11/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct RegisterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var passwordConfirm: String = ""
    @Binding var showing: Bool
    @State var usedEmail: Bool = false
    @State var wrongPass: Bool = false
    @State var visible: Bool = false
    @State var passwordType: Bool = false
    @State var validEmail: Bool = false
    @State var errorCreating: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                TextField("Correo electronico", text: $email)
                    .padding()
                    .cornerRadius(12)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Usuario", text: $username)
                    .padding()
                    .cornerRadius(12)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack() {
                    if visible {
                        TextField("Contraseña", text: $password)
                            .padding()
                            .cornerRadius(12)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    else {
                        SecureField("Contraseña", text: $password)
                            .padding()
                            .cornerRadius(12)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Button(action: {
                        visible.toggle()
                    }, label: {
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                    } )
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
                HStack() {
                    if visible {
                        TextField("Re-introduce contraseña", text: $passwordConfirm)
                            .padding()
                            .cornerRadius(12)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    else {
                        SecureField("Re-introduce contraseña", text: $passwordConfirm)
                            .padding()
                            .cornerRadius(12)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Button(action: {
                        visible.toggle()
                    }, label: {
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                    } )
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
                .padding(.bottom,25)
            }
            Button(action: {
                checkData()
            }, label: {
                HStack {
                    Text("Registrarse")
                }
            })
                .buttonStyle(Primary())
                .alert("Por favor introduce un correo valido", isPresented: $validEmail) {
                    Button("OK") {
                        validEmail = false
                    }
                }
                .alert("El correo ya esta en uso", isPresented: $usedEmail) {
                    Button("OK") {
                        usedEmail = false
                    }
                }
                .alert("Las contraseñas no coinciden", isPresented: $wrongPass) {
                    Button("OK", role: .cancel) {
                        wrongPass = false
                    }
                }
                .alert("La contraseña debe contener: \n1 Mayuscula \n1 Numero \n8 Caracteres", isPresented: $passwordType) {
                    Button("OK", role: .cancel) {
                        passwordType = false
                    }
                }
                .alert("Ocurrio un error mientras se creaba la cuenta. Por favor intenta mas tarde", isPresented: $errorCreating) {
                    Button("OK", role: .cancel) {
                        errorCreating = false
                    }
                }
        }
        .padding(.horizontal,15)
    }
    
    private func checkData() {
        
        let db = Firestore.firestore()
        db.collection("User").whereField("email", isEqualTo: self.email).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print(err)
            }
            else {
                if isValidEmail(self.email) {
                    if(querySnapshot!.documents.count == 0) {
                        if(self.password != self.passwordConfirm) {
                            self.wrongPass = true
                        }
                        else {
                            if(isValidPassword(self.password)) {
                                print("Valid account :)")
                                let user = User(user_name: username, group_id: "equipo1", user_donations: 0, user_ranking: 0, is_admin: false, email: email, icon: "player")
                                let auth = Auth.auth()
                                auth.createUser(withEmail: self.email, password: self.password) {
                                    result, error in
                                    guard result != nil , error == nil else {
                                        self.errorCreating = true
                                        return
                                    }
                                    auth.signIn(withEmail: self.email, password: self.password) {
                                        result, error in
                                        guard result != nil, error == nil else {
                                            return
                                        }
                                        do {
                                            let _ = try db.collection("User").document(auth.currentUser!.uid).setData(from: user)
                                            print("Se subio :D")
                                        }
                                        catch {
                                            print("No se pudo :(")
                                        }
                                    }
                                }
                                self.showing = false
                            }
                            else {
                                self.passwordType = true
                            }
                        }
                    }
                    else {
                        self.usedEmail = true
                    }
                }
                else {
                    self.validEmail = true
                }
            }
        }
        
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        
        let passPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passPred.evaluate(with: password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    
    @State static var temp: Bool = false
    
    static var previews: some View {
        RegisterView(showing: $temp)
    }
}
