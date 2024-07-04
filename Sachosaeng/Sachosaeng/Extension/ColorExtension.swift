//
//  ColorExtension.swift
//  Sachosaeng
//
//  Created by LJh on 5/2/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255,
                opacity: Double(a) / 255
            )
        }
}

struct CustomColor {
    struct GrayScaleColor {
        /// 텍스트, First card 배경색에 쓰임
        static let white = Color(red: 1, green: 1, blue: 1)
        /// 프레임 배경색에 쓰임
        static let gs1 = Color(red: 249.0 / 255.0, green: 250.0 / 255.0, blue: 251.0 / 255.0)
        /// Second card 배경색, Tap bar 배경색에 쓰임
        static let gs2 = Color(red: 242.0 / 255.0, green: 244.0 / 255.0, blue: 247.0 / 255.0)
        /// 아웃라인에 쓰임
        static let gs3 = Color(red: 228.0 / 255.0, green: 231.0 / 255.0, blue: 236.0 / 255.0)
        /// 아웃라인에 쓰임
        static let gs4 = Color(red: 208.0 / 255.0, green: 213.0 / 255.0, blue: 221.0 / 255.0)
        /// 비선택된 탭 메뉴, 비선택된 아이콘에 쓰임
        static let gs5 = Color(red: 152.0 / 255.0, green: 162.0 / 255.0, blue: 179.0 / 255.0)
        /// 아이콘 배경색, 카테고리 타이틀에 쓰임
        static let gs6 = Color(red: 52.0 / 255.0, green: 64.0 / 255.0, blue: 84.0 / 255.0)
        /// card 타이틀, card 본문, 선택된 아이콘에 쓰임
        static let black = Color(red: 12.0 / 255.0, green: 17.0 / 255.0, blue: 29.0 / 255.0)
    }
    
    struct PrimaryColor {
        static let red = Color(red: 240.0 / 255.0, green: 68.0 / 255.0, blue: 56.0 / 255.0)
        static let orange = Color(red: 251.0 / 255.0, green: 101.0 / 255.0, blue: 20.0 / 255.0)
        static let amber = Color(red: 247.0 / 255.0, green: 144.0 / 255.0, blue: 9.0 / 255.0)
        static let yellow = Color(red: 241.0 / 255.0, green: 183.0 / 255.0, blue: 8.0 / 255.0)
        static let olive = Color(red: 159.0 / 255.0, green: 175.0 / 255.0, blue: 0.0 / 255.0)
        static let green = Color(red: 18.0 / 255.0, green: 183.0 / 255.0, blue: 74.0 / 255.0)
        static let mint = Color(red: 43.0 / 255.0, green: 203.0 / 255.0, blue: 186.0 / 255.0)
        static let blue = Color(red: 11.0 / 255.0, green: 165.0 / 255.0, blue: 236.0 / 255.0)
        static let indigo = Color(red: 71.0 / 255.0, green: 85.0 / 255.0, blue: 174.0 / 255.0)
        static let purple = Color(red: 122.0 / 255.0, green: 90.0 / 255.0, blue: 248.0 / 255.0)
        static let pink = Color(red: 238.0 / 255.0, green: 70.0 / 255.0, blue: 151.0 / 255.0)
        
        static func primaryColorWithAlpha(_ color: Color) -> Color {
            switch color {
            case PrimaryColor.red, PrimaryColor.orange, PrimaryColor.amber, PrimaryColor.green, PrimaryColor.mint, PrimaryColor.blue, PrimaryColor.indigo, PrimaryColor.purple, PrimaryColor.pink:
                return color.opacity(0.12)
            default:
                return color.opacity(0.20)
            }
        }
    }
}
