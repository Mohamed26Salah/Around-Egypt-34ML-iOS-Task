//
//  GeomtryReader + Extenstion.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
import SwiftUI

extension View {
    func getWidth(_ width: Binding<CGFloat>) -> some View {
        modifier(GetWidthModifier(width: width))
    }
}

struct GetWidthModifier: ViewModifier {
    @Binding var width: CGFloat
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    let proxyWidth = proxy.size.width
                    Color.clear
                        .task(id: proxy.size.width) {
                            $width.wrappedValue = max(proxyWidth, 0)
                        }
                }
            )
    }
}
