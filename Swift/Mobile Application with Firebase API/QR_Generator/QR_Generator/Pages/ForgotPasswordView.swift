//
//  ForgotPasswordView.swift
//  QR_Generator
//
//  Created by Alumno on 29/11/21.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    
    @State var invalidEmail: Bool = false
    @State var email: String = ""
    @Binding var showing: Bool
    
    var body: some View {
        TextField("Correo Electronico", text: $email)
            .padding()
            .cornerRadius(12)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        Button(action: {
            if(isValidEmail(email)) {
                Auth.auth().sendPasswordReset(withEmail: self.email) { (error) in
                    if let error = error {
                        invalidEmail = true
                    }
                    else {
                        print(email)
                        showing = false
                        print("Siuuu")
                    }
                }
            }
            else {
                invalidEmail = true
            }
        }, label: {
            Text("Enviar correo")
        })
            .buttonStyle(Primary())
            .alert("Por favor introduce un correo valido", isPresented: $invalidEmail) {
                Button("OK") {
                    invalidEmail = false
                }
            }
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    
    @State static var temp = false
    
    static var previews: some View {
        ForgotPasswordView(showing: $temp)
    }
}
