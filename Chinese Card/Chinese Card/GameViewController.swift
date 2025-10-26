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
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.startGame()
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        // StackView занимают основное пространство
        view.addSubview(leftStackView)
        view.addSubview(rightStackView)
        
        // Нижняя панель для кнопки
        let bottomPanel = UIView()
        bottomPanel.backgroundColor = Constants.backgroundColor
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomPanel)
        
        // Кнопка в нижней панели справа
        bottomPanel.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            // StackView сверху до нижней панели
            leftStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            leftStackView.bottomAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: -10),
            leftStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            leftStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.43),
            
            rightStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            rightStackView.bottomAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: -10),
            rightStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            rightStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.43),
            
            // Нижняя панель
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomPanel.heightAnchor.constraint(equalToConstant: 50),
            
            // Кнопка в панели
            settingsButton.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),
            settingsButton.centerXAnchor.constraint(equalTo: bottomPanel.centerXAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 50),
            settingsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func highlightCard(wordData: WordData, cardType: CardType, isSelected: Bool) {
        let cardsDict = cardType == .character ? leftCards : rightCards
        
        // Ищем карточку по ID слова - это надёжнее!
        if let card = cardsDict[wordData.id] {
            card.setSelected(isSelected)
        } else {
            print("⚠️ Карточка не найдена: \(wordData.character) \(wordData.id)")
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
        
        let showPinyin = UserDefaults.standard.bool(forKey: Constants.showPinyinKey)
        let useEnglish = UserDefaults.standard.bool(forKey: Constants.useEnglishKey)
        
        // Левые карточки
        for word in leftWords {
            let card = CustomCardView()
            card.wordData = word
            card.showPinyin = showPinyin
            leftCards[word.id] = card
            
            card.onTap = { [weak self] in
                self?.presenter.didSelectWord(word, cardType: .character)
            }
            leftStackView.addArrangedSubview(card)
        }
        
        // Правые карточки
        for word in rightWords {
            let card = CustomCardView()
            // Устанавливаем перевод в зависимости от языка
            card.text = useEnglish ? word.translationEn : word.translationRu
            rightCards[word.id] = card
            
            card.onTap = { [weak self] in
                self?.presenter.didSelectWord(word, cardType: .translation)
            }
            rightStackView.addArrangedSubview(card)
        }
    }
    
    func showWinScreen(stats: GameStats) {
        let winVC = WinViewController(stats: stats) { [weak self] in
            self?.presenter.startNewGame()
        }
        winVC.modalPresentationStyle = .overFullScreen
        self.present(winVC, animated: true)
    }
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController { [weak self] in
            self?.refreshPinyinDisplay()
        }
        settingsVC.modalPresentationStyle = .overFullScreen
        present(settingsVC, animated: true)
    }
    
    private func refreshPinyinDisplay() {
        let showPinyin = UserDefaults.standard.bool(forKey: Constants.showPinyinKey)
        let useEnglish = UserDefaults.standard.bool(forKey: Constants.useEnglishKey)
        
        // Обновляем ВСЕ карточки без перезапуска игры
        
        // Левые карточки (иероглифы) - обновляем пиньинь
        for (wordId, card) in leftCards {
            if let wordData = leftColumnWords.first(where: { $0.id == wordId }) {
                card.wordData = wordData
                card.showPinyin = showPinyin
            }
        }
        
        // Правые карточки (переводы) - обновляем язык
        for (wordId, card) in rightCards {
            if let wordData = rightColumnWords.first(where: { $0.id == wordId }) {
                // Обновляем текст перевода
                card.text = useEnglish ? wordData.translationEn : wordData.translationRu
            }
        }
    }
}
