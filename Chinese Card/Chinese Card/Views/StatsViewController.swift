//
//  StatsViewController.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 27.10.2025.
//

import UIKit

class StatsViewController: UIViewController {
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Назад", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        let titleLabel = UILabel()
        titleLabel.text = "📊 Статистика"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        
        let comingSoonLabel = UILabel()
        comingSoonLabel.text = "Скоро здесь появится статистика вашего прогресса!"
        comingSoonLabel.textColor = .white
        comingSoonLabel.font = .systemFont(ofSize: 18, weight: .medium)
        comingSoonLabel.textAlignment = .center
        comingSoonLabel.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, comingSoonLabel, backButton])
        stack.axis = .vertical
        stack.spacing = 30
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            backButton.widthAnchor.constraint(equalToConstant: 120),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
}
