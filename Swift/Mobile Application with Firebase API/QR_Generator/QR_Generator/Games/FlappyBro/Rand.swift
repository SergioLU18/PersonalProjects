//
//  Rand.swift
//  Flappy
//
//  Created by javier banegas on 1/11/21.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    public static func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min min: CGFloat, max max: CGFloat) ->CGFloat{
        return CGFloat.random() * (max - min) + min
    }
}
