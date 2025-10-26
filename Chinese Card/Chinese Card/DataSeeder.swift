//
//  DataSeeder.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import CoreData

class DataSeeder {
    static func seedInitialData() {
        let context = CoreManager().persistentContainer.viewContext
        
        // Проверяем есть ли уже данные
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        if let count = try? context.count(for: request), count > 0 {
            return // Данные уже есть
        }
        
        // Добавляем тестовые слова HSK1
        let words = [
            ("你好", "nǐ hǎo", "привет", "hello", 1),
            ("谢谢", "xiè xie", "спасибо", "thank you", 1),
            ("我", "wǒ", "я", "I", 1),
            ("你", "nǐ", "ты", "you", 1),
            ("好", "hǎo", "хороший", "good", 1),
            ("是", "shì", "быть", "to be", 1),
            ("有", "yǒu", "иметь", "to have", 1),
            ("看", "kàn", "смотреть", "to see", 1),
            ("听", "tīng", "слушать", "to hear", 1),
            ("说", "shuō", "говорить", "to say", 1)
        ]
        
        
        for (character, pinyin, ru, en, level) in words {
            let word = Word(context: context)
            word.charackter = character
            word.pinyin = pinyin
            word.translationRu = ru
            word.translationEn = en
            word.hskLevel = Int16(level)
            word.id = UUID()
        }
        
        try? context.save()
    }
}
