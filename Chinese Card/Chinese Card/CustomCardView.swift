//
//  CustomCardView.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//


import UIKit

class CustomCardView: UIView {
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
           
//           heightAnchor.constraint(equalToConstant: 80).isActive = true
           
           addSubview(label)
           NSLayoutConstraint.activate([
               label.centerXAnchor.constraint(equalTo: centerXAnchor),
               label.centerYAnchor.constraint(equalTo: centerYAnchor),
               label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
               label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
           ])
       }
}
