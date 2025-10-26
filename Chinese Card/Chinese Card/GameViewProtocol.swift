//
//  GameViewProtocol.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

protocol GameViewProtocol: AnyObject {
    func showWords(leftWords: [WordData], rightWords: [WordData])
    func highlightCard(wordData: WordData, cardType: CardType, isSelected: Bool)
    func removeMatchedCards(first: WordData, second: WordData)
    func showMismatch(first: WordData, firstType: CardType, second: WordData, secondType: CardType)
    func showWinScreen(stats: GameStats)
}
