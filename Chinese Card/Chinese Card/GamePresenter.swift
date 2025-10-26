//
//  GamePresenter.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import Foundation
import CoreData

class GamePresenter: GamePresenterProtocol {
    weak var view: GameViewProtocol?
    private var currentWords: [WordData] = []
    private var leftColumnWords: [WordData] = []
    private var rightColumnWords: [WordData] = []
    private var firstSelectedWord: WordData?
    private var secondSelectedWord: WordData?
    private var firstSelectedCardType: CardType?
    private var secondSelectedCardType: CardType?
    private var matchedPairs: Set<UUID> = []
    private var stats = GameStats()
    private let maxRecentWords = 50
    
    func startGame() {
        loadWordsForGame()
    }
    
    func startNewGame() {
        matchedPairs.removeAll()
        startGame()
    }
    
    private func loadWordsForGame() {
        let context = CoreManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = NSPredicate(format: "hskLevel == 1")
        
        do {
            let allWords = try context.fetch(request)
            
            // Исключаем недавно использованные слова
            let availableWords = allWords.filter { word in
                guard let id = word.id else { return false }
                return !stats.usedWordIds.contains(id)
            }
            
            // Если мало доступных - очищаем историю
            let wordsToUse = availableWords.count >= Constants.cardCount ? availableWords : allWords
            
            let selectedWords = Array(wordsToUse.shuffled().prefix(Constants.cardCount))
            
            // Обновляем историю
            selectedWords.forEach { word in
                if let id = word.id {
                    stats.usedWordIds.insert(id)
                    // Ограничиваем размер истории
                    if stats.usedWordIds.count > Constants.maxRecentWords {
                        stats.usedWordIds.removeFirst()
                    }
                }
            }
            
            // Конвертируем в WordData
            currentWords = selectedWords.map { word in
                WordData(
                    id: word.id ?? UUID(),
                    character: word.character ?? "",
                    pinyin: word.pinyin ?? "",
                    translationRu: word.translationRu ?? "",
                    translationEn: word.translationEn ?? ""
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
            secondSelectedCardType = cardType
            checkMatch()
        }
    }
    
    private func checkMatch() {
        guard let first = firstSelectedWord, let second = secondSelectedWord,
              let firstType = firstSelectedCardType, let secondType = secondSelectedCardType else { return }
        
        // Сбрасываем выделение с ОБЕИХ карточек
        view?.highlightCard(wordData: first, cardType: firstType, isSelected: false)
        
        if first.id == second.id {
            stats.correctMatches += 1
            matchedPairs.insert(first.id)
            view?.removeMatchedCards(first: first, second: second)
            checkWinCondition()
        } else {
            stats.wrongMatches += 1
            view?.showMismatch(first: first, firstType: firstType,
                              second: second, secondType: secondType)
        }
        
        // Сброс
        firstSelectedWord = nil
        secondSelectedWord = nil
        firstSelectedCardType = nil
        secondSelectedCardType = nil
    }
    
    private func checkWinCondition() {
        if matchedPairs.count == currentWords.count {
            view?.showWinScreen(stats: stats)
        }
    }
}
