//
//  GamePresenter.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import UIKit
import CoreData

class GamePresenter: GamePresenterProtocol {
    weak var view: GameViewProtocol?
    private var currentWords: [Word] = []
    
    func startGame() {
        loadWordsForGame()
    }
    
    private func loadWordsForGame() {
        let context = CoreManager().persistentContainer.viewContext
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        request.predicate = NSPredicate(format: "hskLevel == 1")
        request.fetchLimit = 5 // Пока 5 пар для теста
        
        do {
            let words = try context.fetch(request)
            currentWords = words
            print("Загружено слов: \(words.count)")
            // TODO: Перемешать и разбить на иероглифы/переводы
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    func didSelectWord(_ word: Word) {
        // Пока заглушка
    }
}
