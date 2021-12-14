//
//  Buttons.swift
//  QR_Generator
//
//  Created by Carlos Remes on 17/11/21.
//

import SwiftUI

struct Primary: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical,16)
            .background(Color("Primary-Purple"))
            .foregroundColor(Color("Text-White"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .font(.Quicksand(style: "Bold", size: 22))
    }
}

struct Secondary: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical,16)
            .background(Color.white)
            .foregroundColor(Color("Text-Black"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .font(.Quicksand(style: "Bold", size: 22))
            .overlay(
                    RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 3)
                )
            //falta border
    }
}

struct Special: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical,16)
            .background(Color("Primary-Yellow"))
            .foregroundColor(Color("Text-Black"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .font(.Quicksand(style: "Bold", size: 22))
            //falta border
    }
}

//struct CustomTextFieldStyle: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .padding(10)
//            .overlay(RoundedRectangle(cornerRadius: 12)
//            
//            .foregroundColor(Color("Secondary-MediumPurple"))
//            
//    }
//}
