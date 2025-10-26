//
//  SettingsViewController.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import UIKit

class SettingsViewController: UIViewController {
    private let onDismiss: () -> Void
    
    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
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
        view.backgroundColor = .darkGray
        
        let container = UIView()
        container.backgroundColor = .black
        container.layer.cornerRadius = 20
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Настройки"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        
        // Пиньинь
        let pinyinSwitch = UISwitch()
        pinyinSwitch.isOn = UserDefaults.standard.bool(forKey: "showPinyin")
        pinyinSwitch.addTarget(self, action: #selector(pinyinChanged), for: .valueChanged)
        
        let pinyinLabel = UILabel()
        pinyinLabel.text = "Показывать пиньинь"
        pinyinLabel.textColor = .white
        pinyinLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        let pinyinStack = UIStackView(arrangedSubviews: [pinyinLabel, pinyinSwitch])
        pinyinStack.axis = .horizontal
        pinyinStack.distribution = .equalSpacing
        
        // Язык перевода
        let languageSegmented = UISegmentedControl(items: ["Русский", "English"])
        languageSegmented.selectedSegmentIndex = UserDefaults.standard.bool(forKey: "useEnglish") ? 1 : 0
        languageSegmented.addTarget(self, action: #selector(languageChanged), for: .valueChanged)
        
        let languageLabel = UILabel()
        languageLabel.text = "Язык перевода"
        languageLabel.textColor = .white
        languageLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        let languageStack = UIStackView(arrangedSubviews: [languageLabel, languageSegmented])
        languageStack.axis = .vertical
        languageStack.spacing = 10
        
        let closeButton = UIButton()
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.backgroundColor = .systemBlue
        closeButton.layer.cornerRadius = 10
        closeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, pinyinStack, languageStack, closeButton])
        stack.axis = .vertical
        stack.spacing = 30
        stack.alignment = .fill
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
            
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func pinyinChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "showPinyin")
    }
    
    @objc private func languageChanged(_ sender: UISegmentedControl) {
        let useEnglish = sender.selectedSegmentIndex == 1
        UserDefaults.standard.set(useEnglish, forKey: "useEnglish")
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true) {
            self.onDismiss()
        }
    }
}
