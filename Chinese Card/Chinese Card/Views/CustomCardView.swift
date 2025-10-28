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
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut]) {
            if isSelected {
                self.backgroundColor = Constants.selectedColor
                self.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
                self.layer.shadowColor = UIColor.systemGreen.cgColor
                self.layer.shadowOpacity = 0.6
                self.layer.shadowOffset = CGSize(width: 0, height: 4)
                self.layer.shadowRadius = 8
            } else {
                self.backgroundColor = Constants.cardColor
                self.transform = .identity
                self.layer.shadowOpacity = 0
            }
        }
    }
    
    private func updateDisplay() {
        guard let wordData = wordData else { return }
        
        label.text = wordData.character
        pinyinLabel.text = showPinyin ? wordData.pinyin : ""
        pinyinLabel.isHidden = !showPinyin
    }
    
    func animateMatch() {
         UIView.animate(withDuration: 0.2, animations: {
             self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
             self.alpha = 0.7
         }) { _ in
             UIView.animate(withDuration: 0.15, animations: {
                 self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                 self.alpha = 0
             }) { _ in
                 self.isHidden = true
             }
         }
     }
     
// MARK: -- Анимация несовпадения
     func animateMismatch() {
         UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: []) {

             UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                 self.transform = CGAffineTransform(translationX: 8, y: 0)
                 self.backgroundColor = Constants.mismatchColor
             }
             UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                 self.transform = CGAffineTransform(translationX: -8, y: 0)
             }
             UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                 self.transform = CGAffineTransform(translationX: 4, y: 0)
             }
             UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                 self.transform = .identity
                 self.backgroundColor = Constants.cardColor
             }
         }
     }
     
// MARK: -- Анимация новых карточек
     func animateAppear(delay: TimeInterval = 0) {
         self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
         self.alpha = 0
         
         UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: []) {
             self.transform = .identity
             self.alpha = 1
         }
     }
    
    @objc private func handleTap() {
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()
        onTap?()
    }
}
