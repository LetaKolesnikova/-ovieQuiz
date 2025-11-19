//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Виолетта Сиротина on 17.11.25.
//
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    var formattedDate: String {
            return date.dateTimeString
        }
    var formattedString: String {
            return "\(correct)/\(total) (\(date.dateTimeString))"
        }
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
    
    
}
