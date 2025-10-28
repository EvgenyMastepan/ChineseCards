//
//  Constants.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import UIKit

// MARK: -- Туть хранить все константы из программы. Прям как взрослый, да.

enum Constants {
    
    // MARK: - Game Settings
    static let cardCount = 8
    static let maxRecentWords = 50
    
    // MARK: - Animation
    static let animationDuration = 0.3
    static let mismatchAnimationDuration = 0.1
    static let cardScaleFactor: CGFloat = 1.05
    static let selectionDuration: Double = 0.15
    static let matchDuration: Double = 0.2
    static let mismatchDuration: Double = 0.4
    static let appearDuration: Double = 0.3
    static let cardScaleSelected: CGFloat = 1.08
    static let cardScaleMatch: CGFloat = 1.1
    static let cardScaleDisappear: CGFloat = 0.1
    
    // MARK: - Тени
    static let shadowOpacitySelected: Float = 0.6
    static let shadowOffsetSelected = CGSize(width: 0, height: 4)
    static let shadowRadiusSelected: CGFloat = 8
    
    // MARK: - Layout
    static let stackViewSpacing: CGFloat = 10
    static let cardCornerRadius: CGFloat = 12
    static let cardContentPadding: CGFloat = 8
    static let cardLabelHeight: CGFloat = 26
    static let pinyinLabelHeight: CGFloat = 12
    
    // MARK: - Font Sizes
    static let mainFontSize: CGFloat = 20
    static let pinyinFontSize: CGFloat = 12
    static let titleFontSize: CGFloat = 24
    static let buttonFontSize: CGFloat = 18
    
    // MARK: - UserDefaults Keys
    static let showPinyinKey = "showPinyin"
    static let useEnglishKey = "useEnglish"
    
    // MARK: - Colors
    static let backgroundColor = UIColor.black
    static let cardColor = UIColor.systemBlue
    static let selectedColor = UIColor.systemGreen
    static let mismatchColor = UIColor.systemRed
    static let settingsBackground = UIColor.darkGray
    static let buttonColor = UIColor.systemGray
}
