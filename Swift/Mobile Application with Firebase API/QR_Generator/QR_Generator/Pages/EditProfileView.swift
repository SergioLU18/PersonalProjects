//
//  EditProfileView.swift
//  QR_Generator
//
//  Created by Alumno on 22/11/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct myImage: Identifiable {
    var id: String
    var name: String
    var usable: Bool
}

struct EditProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("localUser") var localUser = ""
    @AppStorage("localID") var localID = ""
    @AppStorage("localDonations") var localDonations = 0
    @AppStorage("localIcon") var localIcon = ""
    
    @State var gotImages: Bool = false
    @State var username: String = ""
    @State var showingAlert: Bool = false
    @State var images: [myImage] = []
    
    var columns : [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 4)
    
    @Binding var showing: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                TextField(localUser, text: $localUser)
                    .padding(30)
                if(images.count > 0) {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(images) { image in
                            if(image.usable) {
                                Image(image.name)
                                    .resizable()
                                    .frame(width: (geo.size.width-20)/4, height: (geo.size.width-20)/4)
                                    .overlay(
                                        Rectangle()
                                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: self.localIcon == image.name ? 1 : 0)
                                        )
                                    .onTapGesture {
                                        self.localIcon = image.name
                                    }
                            }
                            else {
                                Image(image.name)
                                    .resizable()
                                    .frame(width: (geo.size.width-20)/4, height: (geo.size.width-20)/4)
                                    .overlay(
                                        Rectangle()
                                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth:  0)
                                    )
                                    .opacity(0.25)
                                    .onTapGesture {
                                        self.showingAlert = true
                                    }
                            }
                        }
                        .alert("Dona mas para desbloquear esta imagen", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) {}
                        }
                    }
                }
                else {
                    ProgressView()
                        .padding(20)
                }

                Button(action: {
                    updateUser()
                }, label: {
                    HStack {
//                        Image(systemName: "icloud.and.arrow.up.fill")
                        Text("Guardar")
                    }
                })
                    .buttonStyle(Primary())
                    .padding(.top,30)
                    }
            
        }
        .onAppear {
            fetchAssets()
        }
    }

    private func fetchAssets() {
        let db = Firestore.firestore()
        db.collection("IconImages").getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print(err)
            }
            else {
                for image in querySnapshot!.documents {
                    var usable = false
                    let reqDonations = image["required_donations"] as! Int
                    if(reqDonations < self.localDonations) {
                        usable = true
                    }
                    let temp = myImage(id: image.documentID, name: image["image"] as! String, usable: usable)
                    images.append(temp)
                }
            }
        }
    }
    
    private func updateUser() {
        let db = Firestore.firestore()
        let userRef = db.collection("User").document(self.localID)
        userRef.updateData(["user_name": self.localUser, "icon": self.localIcon]) { (error) in
            if error == nil {
                print("Se actualizo :)")
                self.showing = false
            }
            else {
                print(":(")
            }
        }
        return
        
    }
    
}

struct EditProfileView_Previews: PreviewProvider {
    
    @State static var tempVar: Bool = false
    
    static var previews: some View {
        EditProfileView(showing: $tempVar)
    }
}
