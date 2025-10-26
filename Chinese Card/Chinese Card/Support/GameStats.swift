//
//  GameStats.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//
import UIKit


struct GameStats {
    var correctMatches: Int
    var wrongMatches: Int
    var usedWordIds: Set<UUID>
    
    init() {
        self.correctMatches = 0
        self.wrongMatches = 0
        self.usedWordIds = []
    }
}
