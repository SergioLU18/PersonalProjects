//
//  Fonts.swift
//  QR_Generator
//
//  Created by Carlos Remes on 17/11/21.
//

import SwiftUI

extension Font {
    public static func Quicksand(style: String,size: CGFloat) -> Font {
        return Font.custom("Quicksand-\(style)", size: size)
    }
}
