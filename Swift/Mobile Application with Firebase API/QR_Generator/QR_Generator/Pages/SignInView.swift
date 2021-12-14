//
//  SignInView.swift
//  QR_Generator
//
//  Created by Alumno on 17/11/21.
//

import SwiftUI

struct SignInView: View {
    
    @Binding var logged: Bool
    @State var showingAlert: Bool = false
    @State var email: String = ""
    @State var password: String = ""
    @State var showingRegister: Bool = false
    @State var showingForgot: Bool = false
    
    @State var user: UserModel = UserModel()
    
    var body: some View {
        
        VStack {
            Image("banco-alimentos-logo")
                .resizable()
                .scaledToFit()
            .frame(maxWidth: 300)
            .padding(.top,30)
            .padding(.bottom,50)
            
            
            TextField("Correo electronico", text: $email)
                .padding()
                .cornerRadius(12)
                .padding(.bottom, 15)
                .textInputAutocapitalization(.never)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Contraseña", text: $password)
                .padding()
                .cornerRadius(12)
                .padding(.bottom, 20)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                user.fetchUser(email: email, password: password) { temp in
                    if(temp) {
                        logged = true
                    } else {
                        showingAlert = true
                    }
                }

            }) {
                Text("Iniciar Sesión")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
                    .frame(width: 150)
//                    .background(Color.green)
//                    .cornerRadius(15.0)
                
            }
            
            .alert("Wrong username or password", isPresented: $showingAlert) {
                Button("OK", role: .cancel, action: {})
            }
            .buttonStyle(Primary())
            Button(action: {
                showingRegister = true
            }) {
                Text("Registrarse")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
                    .frame(width: 150)
//                    .background(Color.blue)
//                    .cornerRadius(15)
            }
            .buttonStyle(Secondary())
            .sheet(isPresented: $showingRegister) {
                RegisterView(showing: $showingRegister)
            }
            .alert("Incorrect username or password", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            }
            Button(action: {
                showingForgot = true
            }) {
                Text("Restablecer contraseña")
            }
            .sheet(isPresented: $showingForgot) {
                ForgotPasswordView(showing: $showingForgot) 
            }
            Spacer()
        }
        .padding(.horizontal,15)
    }
     
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(logged: .constant(false))
    }
}
