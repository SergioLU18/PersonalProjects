//
//  DonationView.swift
//  QR_Generator
//
//  Created by Carlos Remes on 22/11/21.
//

import SwiftUI

struct DonationView: View {
    
    @State var showingQR: Bool = false
    
    var body: some View {
        VStack{
            Image("banco-alimentos-logo")
                .resizable()
                .scaledToFit()
            .frame(maxWidth: 300)
            
            Text("Cómo desbloquear juegos?")
                .font(.Quicksand(style: "SemiBold", size: 24))
                .foregroundColor(Color("Primary-Purple"))
                .padding(.vertical,45)
            
            VStack(alignment: .leading,spacing: 25){
                HStack{
                    Text("1")
                        .font(.Quicksand(style: "Bold", size: 40))
                        .foregroundColor(Color("Primary-Purple"))
                        .padding(.horizontal, 20)
                    
                    Text("Dona una bolsa de arroz, frijoles o ------- en tu escuela o institución más cercana.")
                        .padding(.trailing,30)
                        .font(.Quicksand(style: "Regular", size: 18))
                }
                
                HStack{
                    Text("2")
                        .font(.Quicksand(style: "Bold", size: 40))
                        .foregroundColor(Color("Primary-Purple"))
                        .padding(.horizontal, 20)
                    
                    Text("Pide el código Qr con la misma gente que reciba tus donaciones.")
                        .padding(.trailing,30)
                        .font(.Quicksand(style: "Regular", size: 18))
                }
                
                HStack{
                    Text("3")
                        .font(.Quicksand(style: "Bold", size: 40))
                        .foregroundColor(Color("Primary-Purple"))
                        .padding(.horizontal, 20)
                    
                    Text("Disfruta la variedad de juegos que tenemos para ti.")
                        .padding(.trailing,30)
                        .font(.Quicksand(style: "Regular", size: 18))
                }
            }
            
            Spacer()
            
            Text("Ya donaste?")
                .font(.Quicksand(style: "SemiBold", size: 15))
                .foregroundColor(Color("Secondary-MediumPurple"))
            
            Button(action: {
                showingQR = true
            }, label: {
                Text("Generar Qr")
                    .padding(.horizontal,20)
            })
                .sheet(isPresented: $showingQR) {
                    GeneratedQRView()
                }
                .buttonStyle(Primary())
        }
        //        .padding(.top,30)
        .padding(.bottom,15)
    }
}

struct DonationView_Previews: PreviewProvider {
    static var previews: some View {
        DonationView()
    }
}
