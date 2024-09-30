//
//  Image+.swift
//  Sachosaeng
//
//  Created by LJh on 9/24/24.
//

import SwiftUI

extension Image {
    func circleImage(frame: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: frame, height: frame)
            .clipShape(Circle())
            .clipped()
    }
}
