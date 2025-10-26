//
//  GamePresenterProtocol.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

protocol GamePresenterProtocol {
    func startGame()
    func didSelectWord(_ wordData: WordData, cardType: CardType)
}
