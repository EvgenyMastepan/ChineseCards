//
//  GamePresenter.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import Foundation
import CoreData

struct WordData {
    let id: UUID
    let character: String
    let translation: String
}



class GamePresenter: GamePresenterProtocol {
    weak var view: GameViewProtocol?
    private var currentWords: [WordData] = []
    private var leftColumnWords: [WordData] = []
    private var rightColumnWords: [WordData] = []
    private var firstSelectedWord: WordData?
    private var secondSelectedWord: WordData?
    private var firstSelectedCardType: CardType?
    private var secondSelectedCardType: CardType?
    
    func startGame() {
        loadWordsForGame()
    }
    
    private func loadWordsForGame() {
        let context = CoreManager().persistentContainer.viewContext
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = NSPredicate(format: "hskLevel == 1")
        
        do {
            let allWords = try context.fetch(request)
            let selectedWords = Array(allWords.shuffled().prefix(8))
            
            // Конвертируем в WordData
            currentWords = selectedWords.map { word in
                WordData(
                    id: word.id ?? UUID(),
                    character: word.character ?? "",
                    translation: word.translationEn ?? ""
                )
            }
            
            leftColumnWords = currentWords
            rightColumnWords = currentWords.shuffled()
            
            view?.showWords(leftWords: leftColumnWords, rightWords: rightColumnWords)
            
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    func didSelectWord(_ wordData: WordData, cardType: CardType) {
        if firstSelectedWord == nil {
            firstSelectedWord = wordData
            firstSelectedCardType = cardType
            view?.highlightCard(wordData: wordData, cardType: cardType, isSelected: true)
        } else {
            // Проверяем что карточки разных типов
            guard firstSelectedCardType != cardType else {
                print("🚫 Обе карточки одного типа")
                return
            }
            
            secondSelectedWord = wordData
            secondSelectedCardType = cardType  // ← ДОБАВЬ ЭТУ СТРОКУ
            checkMatch()
        }
    }
    
    private func checkMatch() {
        guard let first = firstSelectedWord, let second = secondSelectedWord,
              let firstType = firstSelectedCardType, let secondType = secondSelectedCardType else { return }
        
        // Сбрасываем выделение с ОБЕИХ карточек
        view?.highlightCard(wordData: first, cardType: firstType, isSelected: false)
        
        if first.id == second.id {
            view?.removeMatchedCards(first: first, second: second)
        } else {
            view?.showMismatch(first: first, firstType: firstType,
                              second: second, secondType: secondType)  // ← ПЕРЕДАЁМ ТИПЫ
        }
        
        // Сброс
        firstSelectedWord = nil
        secondSelectedWord = nil
        firstSelectedCardType = nil
        secondSelectedCardType = nil
    }
}
