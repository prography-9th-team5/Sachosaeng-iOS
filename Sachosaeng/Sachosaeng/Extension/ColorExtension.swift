//
//  ColorExtension.swift
//  Sachosaeng
//
//  Created by LJh on 5/2/24.
//

import SwiftUI

extension Color {
    struct GrayScaleColor {
        /// 텍스트, First card 배경색에 쓰임
        static let white = Color(red: 0, green: 0, blue: 0)
        /// 프레임 배경색에 쓰임
        static let gs1 = Color(red: 249, green: 250, blue: 251)
        /// Second card 배경색, Tap bar 배경색에 쓰임
        static let gs2 = Color(red: 242, green: 244, blue: 247)
        /// 아웃라인에 쓰임
        static let gs3 = Color(red: 228, green: 231, blue: 236)
        /// 아웃라인에 쓰임
        static let gs4 = Color(red: 208, green: 213, blue: 221)
        /// 비선택된 탭 메뉴, 비선택된 아이콘에 쓰임
        static let gs5 = Color(red: 152, green: 162, blue: 179)
        /// 아이콘 배경색, 카테고리 타이틀에 쓰임
        static let gs6 = Color(red: 52, green: 64, blue: 84)
        /// card 타이틀, card 본문, 선택된 아이콘에 쓰임
        static let black = Color(red: 12, green: 17, blue: 29)
    }
    struct PrimaryColor {
        static let red = Color(red: 240, green: 68, blue: 56)
        static let orange = Color(red: 251, green: 101, blue: 20)
        static let amber = Color(red: 247, green: 144, blue: 9)
        static let yellow = Color(red: 241, green: 183, blue: 8)
        static let olive = Color(red: 159, green: 175, blue: 0)
        static let green = Color(red: 18, green: 183, blue: 74)
        static let mint = Color(red: 43, green: 203, blue: 186)
        static let blue = Color(red: 11, green: 165, blue: 236)
        static let indigo = Color(red: 71, green: 85, blue: 174)
        static let purple = Color(red: 122, green: 90, blue: 248)
        static let pink = Color(red: 238, green: 70, blue: 151)
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
