//
//  Ud.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//
import UIKit


struct WordData {
    let id: UUID
    let character: String
    let pinyin: String
    let translationRu: String
    let translationEn: String
    
    // Вычисляемое свойство для текущего перевода
    var translation: String {
        UserDefaults.standard.bool(forKey: Constants.useEnglishKey) ? translationEn : translationRu
    }
}
