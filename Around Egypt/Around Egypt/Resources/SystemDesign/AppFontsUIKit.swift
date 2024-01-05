//
//  AppFonts.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
import UIKit

enum LabelStyleUIKit {
    case Heading1
    case Heading2
    case Heading3
    case Heading4
    case Heading5
    case Heading6
    
    case BodyXLargeBold
    case BodyXLargeSemiBold
    case BodyXLargeMedium
    case BodyXLargeRegular
    
    case BodyLargeBold
    case BodyLargeSemiBold
    case BodyLargeMedium
    case BodyLargeRegular
    
    case BodyMediumBold
    case BodyMediumSemiBold
    case BodyMediumMedium
    case BodyMediumRegular
    
    case BodySmallBold
    case BodySmallSemiBold
    case BodySmallMedium
    case BodySmallRegular
    
    case BodyXSmallBold
    case BodyXSmallSemiBold
    case BodyXSmallMedium
    case BodyXSmallRegular
    
    
    var font: UIFont {
        switch self {
        case .Heading1: return UIFont(name: "SF Pro Display Bold", size: 40) ?? UIFont.systemFont(ofSize: 40, weight: .bold)
        case .Heading2: return UIFont(name: "SF Pro Display Bold", size: 32) ?? UIFont.systemFont(ofSize: 40, weight: .bold)
        case .Heading3: return UIFont(name: "SF Pro Display Bold", size: 24) ?? UIFont.systemFont(ofSize: 40, weight: .bold)
        case .Heading4: return UIFont(name: "SF Pro Display Bold", size: 20) ?? UIFont.systemFont(ofSize: 40, weight: .bold)
        case .Heading5: return UIFont(name: "SF Pro Display Bold", size: 18) ?? UIFont.systemFont(ofSize: 40, weight: .bold)
        case .Heading6: return UIFont(name: "SF Pro Display Bold", size: 16) ?? UIFont.systemFont(ofSize: 40, weight: .bold)
            
        case .BodyXLargeBold: return UIFont(name: "SF Pro Display Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        case .BodyXLargeSemiBold: return UIFont(name: "SF Pro Display Semibold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .BodyXLargeMedium: return UIFont(name: "SF Pro Display Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
        case .BodyXLargeRegular: return UIFont(name: "SF Pro Display Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .regular)
            
            
        case .BodyLargeBold: return UIFont(name: "SF Pro Display Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        case .BodyLargeSemiBold: return UIFont(name: "SF Pro Display Semibold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .BodyLargeMedium: return UIFont(name: "SF Pro Display Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        case .BodyLargeRegular: return UIFont(name: "SF Pro Display Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
            
        case .BodyMediumBold: return UIFont(name: "SF Pro Display Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        case .BodyMediumSemiBold: return UIFont(name: "SF Pro Display Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        case .BodyMediumMedium: return UIFont(name: "SF Pro Display Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        case .BodyMediumRegular: return UIFont(name: "SF Pro Display Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
            
        case .BodySmallBold: return UIFont(name: "SF Pro Display Bold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold)
        case .BodySmallSemiBold: return UIFont(name: "SF Pro Display Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .semibold)
        case .BodySmallMedium: return UIFont(name: "SF Pro Display Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        case .BodySmallRegular: return UIFont(name: "SF Pro Display Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
            
        case .BodyXSmallBold: return UIFont(name: "SF Pro Display Bold", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        case .BodyXSmallSemiBold: return UIFont(name: "SF Pro Display Semibold", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .semibold)
        case .BodyXSmallMedium: return UIFont(name: "SF Pro Display Medium", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .medium)
        case .BodyXSmallRegular: return UIFont(name: "SF Pro Display Regular", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
        }
        
    }
    
    var color: UIColor {
        return .black // Set default color here
    }
}

extension UILabel {
    func applyLabelStyle(style: LabelStyleUIKit, text: String? = nil, color: UIColor? = nil) {
        self.font = style.font
        self.textColor = color ?? style.color
        self.text = text
    }
}
