//
//  Color.swift
//  Pawtector
//
//  Created by venuswaran on 7/5/2568 BE.
//

//
//  color.swift
//  Pawtector
//
//  Created by venuswaran on 7/5/2568 BE.
//

// Color+Brand.swift
import SwiftUI

extension Color {
    //Hex initializer (supports "#RRGGBB" or "RRGGBBAA")
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        var hexVal: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&hexVal)

        let (r, g, b, a): (Double, Double, Double, Double)
        switch hexString.count {
        case 6:
          r = Double((hexVal & 0xFF0000) >> 16)/255
          g = Double((hexVal & 0x00FF00) >> 8)/255
          b = Double( hexVal & 0x0000FF)/255
          a = 1
        case 8:
          a = Double((hexVal & 0xFF000000) >> 24)/255
          r = Double((hexVal & 0x00FF0000) >> 16)/255
          g = Double((hexVal & 0x0000FF00) >> 8)/255
          b = Double( hexVal & 0x000000FF)/255
        default:
            self = .brandBlue; return
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    static let brandBlue   = Color(hex: "#77BED1")
    static let brandYellow = Color(hex: "#FDBC33")
    static let brandBrown  = Color(hex: "#947151")
}


