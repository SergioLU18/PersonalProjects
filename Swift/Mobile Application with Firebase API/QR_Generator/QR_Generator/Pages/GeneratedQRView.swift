//
//  GeneratedQRView.swift
//  QR_Generator
//
//  Created by Alumno on 21/10/21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct GeneratedQRView: View {
    
    @AppStorage("localID") var localID = ""
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack {
            Image(uiImage: generateQRCode(from:"\(localID)"))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct GeneratedQRView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratedQRView()
    }
}
