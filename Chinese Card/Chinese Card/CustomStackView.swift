//
//  CustomStackView.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import UIKit

class CustomStackView: UIStackView {
    init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 10) {
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.distribution = .fillEqually
        self.alignment = .fill
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
