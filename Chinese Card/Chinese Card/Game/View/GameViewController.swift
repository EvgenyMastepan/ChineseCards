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
    private var leftCards: [UUID: CustomCardView] = [:]
    private var rightCards: [UUID: CustomCardView] = [:]
    
    private lazy var leftStackView = CustomStackView()
    private lazy var rightStackView = CustomStackView()
    
    // Нижняя панель - три кнопки
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setTitle("🍔 Меню", for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var hskPickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("HSK 1 ▼", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showHSKPicker), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return button
    }()
    
    private var hskPickerView: UIView?
    private var selectedHSKLevel = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.startGame()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // StackView занимают основное пространство
        view.addSubview(leftStackView)
        view.addSubview(rightStackView)
        
        // Нижняя панель для кнопок
        let bottomPanel = UIView()
        bottomPanel.backgroundColor = .black
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomPanel)
        
        bottomPanel.addSubview(menuButton)
        bottomPanel.addSubview(hskPickerButton)
        bottomPanel.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            // StackView
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
            bottomPanel.heightAnchor.constraint(equalToConstant: 60),
            
            // Распределение кнопок в панели
            menuButton.leadingAnchor.constraint(equalTo: bottomPanel.leadingAnchor, constant: 30),
            menuButton.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 80),
            menuButton.heightAnchor.constraint(equalToConstant: 40),
            
            hskPickerButton.centerXAnchor.constraint(equalTo: bottomPanel.centerXAnchor),
            hskPickerButton.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),
            hskPickerButton.widthAnchor.constraint(equalToConstant: 100),
            hskPickerButton.heightAnchor.constraint(equalToConstant: 40),
            
            settingsButton.trailingAnchor.constraint(equalTo: bottomPanel.trailingAnchor, constant: -30),
            settingsButton.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 80),
            settingsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - GameViewProtocol
    
    func showWords(leftWords: [WordData], rightWords: [WordData]) {
        leftColumnWords = leftWords
        rightColumnWords = rightWords
        leftStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let showPinyin = UserDefaults.standard.bool(forKey: Constants.showPinyinKey)
        let useEnglish = UserDefaults.standard.bool(forKey: Constants.useEnglishKey)
        
        // Левые карточки с задержкой для последовательного появления
        for (index, word) in leftWords.enumerated() {
            let card = CustomCardView()
            card.wordData = word
            card.showPinyin = showPinyin
            leftCards[word.id] = card
            
            card.onTap = { [weak self] in
                self?.presenter.didSelectWord(word, cardType: .character)
            }
            
            leftStackView.addArrangedSubview(card)
            card.animateAppear(delay: Double(index) * 0.05)
        }
        
        // Правые карточки с задержкой
        for (index, word) in rightWords.enumerated() {
            let card = CustomCardView()
            card.text = useEnglish ? word.translationEn : word.translationRu
            rightCards[word.id] = card
            
            card.onTap = { [weak self] in
                self?.presenter.didSelectWord(word, cardType: .translation)
            }
            
            rightStackView.addArrangedSubview(card)
            card.animateAppear(delay: Double(index) * 0.05 + 0.2)
        }
    }
    
    func highlightCard(wordData: WordData, cardType: CardType, isSelected: Bool) {
        let cardsDict = cardType == .character ? leftCards : rightCards
        
        // Ищем карточку по ID слова - потому что иначе никак!
        if let card = cardsDict[wordData.id] {
            card.setSelected(isSelected)
        } else {
            print("⚠️ Карточка не найдена: \(wordData.character) \(wordData.id)")
        }
    }
    
    func removeMatchedCards(first: WordData, second: WordData) {
        animateCardRemoval(wordData: first, cardType: .character)
        animateCardRemoval(wordData: second, cardType: .translation)
    }

    private func animateCardRemoval(wordData: WordData, cardType: CardType) {
        let cardsDict = cardType == .character ? leftCards : rightCards
        
        if let card = cardsDict[wordData.id] {
            card.animateMatch()
        }
    }

    func showMismatch(first: WordData, firstType: CardType, second: WordData, secondType: CardType) {
        animateMismatch(wordData: first, cardType: firstType)
        animateMismatch(wordData: second, cardType: secondType)
    }

    private func animateMismatch(wordData: WordData, cardType: CardType) {
        let cardsDict = cardType == .character ? leftCards : rightCards
        
        if let card = cardsDict[wordData.id] {
            card.animateMismatch()
        }
    }
    
    func showWinScreen(stats: GameStats) {
        let winVC = WinViewController(stats: stats) { [weak self] in
            self?.presenter.startNewGame()
        }
        winVC.modalPresentationStyle = .overFullScreen
        self.present(winVC, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func menuTapped() {
        dismiss(animated: true)
    }
    
    @objc private func showHSKPicker() {
        // Скрываем предыдущий пикер если есть. А он был!
        hskPickerView?.removeFromSuperview()
        
        // Создаем выпадающий список
        let pickerView = UIView()
        pickerView.backgroundColor = .systemGray6
        pickerView.layer.cornerRadius = 8
        pickerView.layer.shadowColor = UIColor.black.cgColor
        pickerView.layer.shadowOpacity = 0.3
        pickerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        pickerView.layer.shadowRadius = 4
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Создаем кнопки для каждого уровня HSK
        var previousButton: UIButton?
        
        for level in 1...6 {
            let button = UIButton(type: .system)
            button.setTitle("HSK \(level)", for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = level == selectedHSKLevel ? .systemBlue : .clear
            button.setTitleColor(level == selectedHSKLevel ? .white : .label, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.tag = level
            button.addTarget(self, action: #selector(hskLevelSelected(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            pickerView.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            if let previous = previousButton {
                button.topAnchor.constraint(equalTo: previous.bottomAnchor).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
            }
            
            // Разделитель между кнопками (кроме последней)
            if level < 6 {
                let separator = UIView()
                separator.backgroundColor = .systemGray3
                separator.translatesAutoresizingMaskIntoConstraints = false
                pickerView.addSubview(separator)
                
                NSLayoutConstraint.activate([
                    separator.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor, constant: 8),
                    separator.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: -8),
                    separator.topAnchor.constraint(equalTo: button.bottomAnchor),
                    separator.heightAnchor.constraint(equalToConstant: 1)
                ])
            }
            
            previousButton = button
        }
        
        // Завершаем констрейнты для пикера. Ну да. Потом всё приглажу и сделаю красиво. Или нет.
        if let lastButton = previousButton {
            lastButton.bottomAnchor.constraint(equalTo: pickerView.bottomAnchor).isActive = true
        }
        
        view.addSubview(pickerView)
        
        // список НАД кнопкой, а не под ней
        NSLayoutConstraint.activate([
            pickerView.bottomAnchor.constraint(equalTo: hskPickerButton.topAnchor, constant: -8),
            pickerView.centerXAnchor.constraint(equalTo: hskPickerButton.centerXAnchor),
            pickerView.widthAnchor.constraint(equalTo: hskPickerButton.widthAnchor, constant: 20)
        ])
        
        hskPickerView = pickerView
        
        // Анимация появления
        pickerView.alpha = 0
        pickerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2) {
            pickerView.alpha = 1
            pickerView.transform = .identity
        }
        
        // Добавляем тап для закрытия пикера по тапу вне его
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideHSKPicker))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hskLevelSelected(_ sender: UIButton) {
        selectedHSKLevel = sender.tag
        hskPickerButton.setTitle("HSK \(selectedHSKLevel) ▼", for: .normal)
        
        // Скрываем пикер
        hideHSKPicker()
        
        // TODO: Обновить игру с выбранным уровнем HSK
        print("Выбран уровень HSK: \(selectedHSKLevel)")
        
        // Перезапускаем игру с новым уровнем
        presenter.startGame()
    }
    
    @objc private func hideHSKPicker() {
        guard let pickerView = hskPickerView else { return }
        
        UIView.animate(withDuration: 0.15, animations: {
            pickerView.alpha = 0
            pickerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            pickerView.removeFromSuperview()
            self.hskPickerView = nil
        }
        
        // Убираем жест для закрытия. Потому что он оказывается мешает. А мы и не знали!
        view.gestureRecognizers?.forEach { gesture in
            if let tapGesture = gesture as? UITapGestureRecognizer {
                view.removeGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController { [weak self] in
            self?.refreshPinyinDisplay()
        }
        settingsVC.modalPresentationStyle = .overFullScreen
        present(settingsVC, animated: true)
    }
    
    private func refreshPinyinDisplay() {
        let showPinyin = UserDefaults.standard.bool(forKey: "showPinyin")
        let useEnglish = UserDefaults.standard.bool(forKey: "useEnglish")
        
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
