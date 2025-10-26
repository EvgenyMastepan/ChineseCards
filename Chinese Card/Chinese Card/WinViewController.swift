//
//  Untitled.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import UIKit

class WinViewController: UIViewController {
    private let stats: GameStats
    private let onNewGame: () -> Void
    
    init(stats: GameStats, onNewGame: @escaping () -> Void) {
        self.stats = stats
        self.onNewGame = onNewGame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        
        let container = UIView()
        container.backgroundColor = .darkGray
        container.layer.cornerRadius = 20
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "🎉 Победа!"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        
        let statsLabel = UILabel()
        statsLabel.text = """
        Слов угадано: \(stats.correctMatches)
        Ошибок: \(stats.wrongMatches)
        """
        statsLabel.textColor = .white
        statsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        statsLabel.textAlignment = .center
        statsLabel.numberOfLines = 0
        
        let newGameButton = UIButton()
        newGameButton.setTitle("Новая игра", for: .normal)
        newGameButton.backgroundColor = .systemGreen
        newGameButton.layer.cornerRadius = 10
        newGameButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        newGameButton.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, statsLabel, newGameButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(stack)
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 300),
            
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30),
            
            newGameButton.widthAnchor.constraint(equalToConstant: 200),
            newGameButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func newGameTapped() {
        dismiss(animated: true) {
            self.onNewGame()
        }
    }
}
