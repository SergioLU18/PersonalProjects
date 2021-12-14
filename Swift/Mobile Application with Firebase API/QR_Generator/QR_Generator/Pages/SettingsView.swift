//
//  PrimaryView.swift
//  QR_Generator
//
//  Created by Alumno on 10/11/21.
//

import SwiftUI
import CodeScanner
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SettingsView: View {
    
    init() {
        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color("Primary-Purple")),
                                                            .font: UIFont(name: "Quicksand-Medium", size: 18)!]
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("logged") var logged: Bool = true
    @AppStorage("localID") var localID: String = ""
    @AppStorage("localEmail") var localEmail = ""
    @AppStorage("localPassword") var localPassword = ""
    @AppStorage("localRanking") var localRanking: Int = 0
    @AppStorage("localDonations") var localDonations: Int = 0
    @AppStorage("localAdmin") var localAdmin: Bool = false
    @AppStorage("localUser") var localUser: String = ""
    @AppStorage("localIcon") var localIcon = ""
    
    @State var logout: Bool = false
    @State var isPresentingScanner = false
    @State var scannedCode: String = "Scan a QR code to get started"
    @State var codeObtained: Bool = false
    @State private var donations: Int = 0
    @State private var showingAlert: Bool = false
    @State private var presentingQR: Bool = false
    @State private var editingProfile: Bool = false
    @State private var maxDonation: Int = 0
    
    @State var changeProfileImage = false
    @State var openCameraRoll = false
    @State var imageSelected = UIImage(named: "player")
    
    var ghostScore: Int = 30
    var flappyScore: Int = 120
    
    var body: some View {
        if(!logout) {
            NavigationView{
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            Image(self.localIcon)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(12)
                            Spacer()
                            VStack {
                                Text("\(localUser)")
                                    .font(.Quicksand(style: "SemiBold", size: 30))
                            }
                            Spacer()
                        }
                        .padding(.top,15)
                        //progress bar
                        VStack {
                            Text("donaciones")
                                .font(.Quicksand(style: "Normal", size: 13))
                                .foregroundColor(Color("Primary-Purple"))
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 5)
                                    .opacity(0.3)
                                    .foregroundColor(Color("Primary-Purple"))
                                    .frame(width: 50, height: 50)

                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(self.localDonations/150, 1)))
                                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(Color("Primary-Purple"))
                                    .rotationEffect(Angle(degrees: 270.0))
                                    .frame(width: 50, height: 50)
                                    .animation(.linear, value: 5)

                                Text(String(self.localDonations))
                                    .font(.Quicksand(style: "Bold", size: 20))
                            }
                        }
                        .padding(.top,10)
                    }
                    List {
                        Button(action: {
                            self.presentingQR = true
                        }, label: {
                            HStack {
                                Image(systemName: "qrcode")
                                Text("Mi codigo QR")
                            }
                        })
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .sheet(isPresented: $presentingQR) {
                                GeneratedQRView()
                            }
                        if(localAdmin) {
                            Button(action: {
                                self.isPresentingScanner = true
                            }, label: {
                                HStack {
                                    Image(systemName: "qrcode.viewfinder")
                                    Text("Escaneado de QR")
                                }
                            })
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .sheet(isPresented: $isPresentingScanner) {
                                    CodeScannerView(
                                        codeTypes: [.qr],
                                        completion: { result in
                                            if case let .success(code) = result {
                                                self.scannedCode = code
                                                self.codeObtained = true
                                                self.isPresentingScanner = false
                                            }
                                        } )
                                }
                        }
                        Button(action: {
                            editingProfile = true
                        }, label: {
                            HStack {
                                Image(systemName: "pencil.circle.fill")
                                Text("Editar perfil")
                            }
                        })
                        .sheet(isPresented: $editingProfile) {
                            EditProfileView(showing: $editingProfile)
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        Button(action: {
                            updateData()
                        }) {
                            HStack {
                                Image(systemName: "purchased.circle.fill")
                                Text("Actualizar datos")
                            }
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        Button(action: {
                            showingAlert = true
                        }) {
                            HStack {
                                Image(systemName: "person.fill.xmark")
                                Text("Salir de la cuenta")
                            }
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .alert("Estas seguro que quieres salir?", isPresented: $showingAlert) {
                            Button(action: {
                                logout = true
                                logged = false
                            }) {
                                Text("Si")
                            }
                            Button(action: {
                                showingAlert = false
                            }) {
                                Text("No")
                            }
                        }
                    }
                    if(codeObtained) {
                        VStack {
                            TextField("Numero de donaciones", value: $donations, formatter: NumberFormatter())
                                .frame(width: 190, height: 40)
                                .multilineTextAlignment(.center)
                                .cornerRadius(16)
                                .keyboardType(.decimalPad)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                                .padding([.horizontal], 4)
                            Button {
                                uploadDonations()
                                codeObtained = false
                            } label: {
                                Image(systemName: "arrow.up.and.person.rectangle.portrait")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(20)
                            }
                        }
                    }
        
                }
                .navigationBarTitle(Text("Mi perfil"), displayMode: .inline)
            }
        }
        else {
            HelperView()
        }
    }
    
    private func updateData() {
        
        let email = self.localEmail
        let pass = self.localPassword
        let user = UserModel()
        user.fetchUser(email: email, password: pass) { update in
            if(update) {
                print("Se actualizo :D")
            }
            else {
                print(":(")
            }
        }
        
    }
    
    private func uploadDonations() {
        
        let db = Firestore.firestore()
        let userRef = db.collection("User").document(scannedCode)
        db.collection("User").document(scannedCode).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fetchedDonations = document["user_donations"] as? Int {
                    userRef.updateData(["user_donations": fetchedDonations + donations]) { (error) in
                        if error == nil {
                            print("Se subio a la base de datos")
                        }
                        else {
                            print("No existe el usuario introducido")
                        }
                    }
                }
                else {
                    return
                }
            } else {
                return
            }
        }
        
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
