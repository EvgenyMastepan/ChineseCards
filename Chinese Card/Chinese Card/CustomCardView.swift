//
//  CustomCardView.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//


import UIKit

class CustomCardView: UIView {
    var onTap: (() -> Void)?
    
    var showPinyin: Bool = false {
        didSet {
            updateDisplay()
        }
    }
    
    var wordData: WordData? {
        didSet {
            updateDisplay()
        }
    }
    
    private let label: UILabel = {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let pinyinLabel: UILabel = {
        $0.textColor = .systemGray
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
    
    private func updateDisplay() {
        guard let wordData = wordData else { return }
        
        label.text = wordData.character
        pinyinLabel.text = showPinyin ? wordData.pinyin : ""
        pinyinLabel.isHidden = !showPinyin
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}
