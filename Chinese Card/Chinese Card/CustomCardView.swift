//
//  CustomCardView.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//


import UIKit

class CustomCardView: UIView {
    var onTap: (() -> Void)?
    
    var showPinyin: Bool = true {
        didSet {
            updateDisplay()
        }
    }
    
    var wordData: WordData? {
        didSet {
            updateDisplay()
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    private let label: UILabel = {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.numberOfLines = 2
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let pinyinLabel: UILabel = {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    

    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = Constants.cardColor
        layer.cornerRadius = Constants.cardCornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        addSubview(label)
        addSubview(pinyinLabel)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cardContentPadding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardContentPadding),
            label.heightAnchor.constraint(equalToConstant: Constants.cardLabelHeight),
            
            pinyinLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            pinyinLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cardContentPadding),
            pinyinLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardContentPadding),
            pinyinLabel.heightAnchor.constraint(equalToConstant: Constants.pinyinLabelHeight),
        ])
    }
    
    func setSelected(_ isSelected: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) {
            if isSelected {
                self.backgroundColor = Constants.selectedColor
                self.transform = CGAffineTransform(scaleX: Constants.cardScaleFactor, y: Constants.cardScaleFactor)
            } else {
                self.backgroundColor = Constants.cardColor
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
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
        onTap?()
    }
}
