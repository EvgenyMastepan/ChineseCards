//
//  CustomCardView.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//


import UIKit

class CustomCardView: UIView {
    var onTap: (() -> Void)?
    
    private let label: UILabel = {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func setSelected(_ isSelected: Bool) {
        UIView.animate(withDuration: 0.2) {
            if isSelected {
                self.backgroundColor = .systemGreen
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            } else {
                self.backgroundColor = .systemBlue  // ВОЗВРАЩАЕМ СИНИЙ
                self.transform = .identity
            }
        }
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}
