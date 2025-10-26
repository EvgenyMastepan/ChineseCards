//
//  GameViewController.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import UIKit



class GameViewController: UIViewController, GameViewProtocol {
    var presenter: GamePresenterProtocol!
    private var leftColumnWords: [WordData] = []
    private var rightColumnWords: [WordData] = []
    private var leftCards: [UUID: CustomCardView] = [:]  // wordID -> card
    private var rightCards: [UUID: CustomCardView] = [:]
    
    private lazy var leftStackView = CustomStackView()
    private lazy var rightStackView = CustomStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.startGame()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(leftStackView)
        view.addSubview(rightStackView)
        
        NSLayoutConstraint.activate([
            leftStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            leftStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            leftStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            leftStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.43),
            
            rightStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            rightStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            rightStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            rightStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.43)
        ])
    }
    
    func highlightCard(wordData: WordData, cardType: CardType, isSelected: Bool) {
        let stackView = cardType == .character ? leftStackView : rightStackView
        
        // Ищем карточку с нужным текстом
        for case let card as CustomCardView in stackView.arrangedSubviews {
            if card.text == (cardType == .character ? wordData.character : wordData.translation) {
                card.setSelected(isSelected)
                break
            }
        }
    }
    
    func removeMatchedCards(first: WordData, second: WordData) {
        print("🟡 removeMatchedCards вызван")
        animateCardRemoval(wordData: first, cardType: .character)
        animateCardRemoval(wordData: second, cardType: .translation)
    }

    private func animateCardRemoval(wordData: WordData, cardType: CardType) {
        let cardsDict = cardType == .character ? leftCards : rightCards
        
        if let card = cardsDict[wordData.id] {
            UIView.animate(withDuration: 0.3, animations: {
                card.alpha = 0
                card.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { _ in
                card.isHidden = true
            }
        }
    }

    func showMismatch(first: WordData, firstType: CardType, second: WordData, secondType: CardType) {
        print("🟡 showMismatch: первая \(first.character) (\(firstType)), вторая \(second.character) (\(secondType))")
        
        animateMismatch(wordData: first, cardType: firstType)
        animateMismatch(wordData: second, cardType: secondType)
    }

    private func animateMismatch(wordData: WordData, cardType: CardType) {
        let cardsDict = cardType == .character ? leftCards : rightCards
        
        // Находим карточку по ID слова - ТОЧНО!
        if let card = cardsDict[wordData.id] {
            UIView.animate(withDuration: 0.1, animations: {
                card.backgroundColor = .systemRed
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    card.backgroundColor = .systemBlue
                    card.setSelected(false)
                }
            }
        }
    }
    
    func showWords(leftWords: [WordData], rightWords: [WordData]) {
        leftColumnWords = leftWords
        rightColumnWords = rightWords
        leftStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for word in leftWords {
            let card = CustomCardView()
            card.text = word.character
            leftCards[word.id] = card  // сохраняем карточку
            
            card.onTap = { [weak self] in
                self?.presenter.didSelectWord(word, cardType: .character)
            }
            
            leftStackView.addArrangedSubview(card)
        }
        
        for word in rightWords {
            let card = CustomCardView()
            card.text = word.translation
            rightCards[word.id] = card  // сохраняем карточку
            
            card.onTap = { [weak self] in
                self?.presenter.didSelectWord(word, cardType: .translation)
            }
            
            rightStackView.addArrangedSubview(card)
        }
    }
}
