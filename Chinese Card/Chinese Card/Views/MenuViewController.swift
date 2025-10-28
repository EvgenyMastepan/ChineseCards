//
//  MenuViewController.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 27.10.2025.
//

import UIKit

class MenuViewController: UIViewController {
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("🎮 ИГРАТЬ", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let statsButton: UIButton = {
        let button = UIButton()
        button.setTitle("📊 СТАТИСТИКА", for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("⚙️ НАСТРОЙКИ", for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        let titleLabel = UILabel()
        titleLabel.text = "Китайские Карточки"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, playButton, statsButton, settingsButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            playButton.heightAnchor.constraint(equalToConstant: 55),
            statsButton.heightAnchor.constraint(equalToConstant: 55),
            settingsButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        // Назначаем действия
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        statsButton.addTarget(self, action: #selector(statsTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
    }
    
    @objc private func playTapped() {
        let gameVC = Builder.createGameModule()
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }
    
    @objc private func statsTapped() {
        let statsVC = StatsViewController()
        statsVC.modalPresentationStyle = .fullScreen
        present(statsVC, animated: true)
    }
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController(onDismiss: {})
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true)
    }
}
