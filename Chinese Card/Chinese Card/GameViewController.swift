//
//  GameViewController.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import UIKit

class GameViewController: UIViewController, GameViewProtocol {
    var presenter: GamePresenterProtocol!
    
    private lazy var leftStackView = CustomStackView()
    private lazy var rightStackView = CustomStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.startGame()
        addTestCards()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(leftStackView)
        view.addSubview(rightStackView)
        
        NSLayoutConstraint.activate([
            leftStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            leftStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            leftStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            leftStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40),
            
            rightStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            rightStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            rightStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            rightStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40)
        ])
    }
    
    private func addTestCards() {
        // Добавляем несколько карточек в каждую колонку
        let leftCards = ["你好", "谢谢", "我", "你"]
        let rightCards = ["hello", "thank you", "I", "you"]
        
        for text in leftCards {
            let card = CustomCardView()
            card.text = text
            leftStackView.addArrangedSubview(card)
        }
        
        for text in rightCards {
            let card = CustomCardView()
            card.text = text
            rightStackView.addArrangedSubview(card)
        }
    }
    
}
