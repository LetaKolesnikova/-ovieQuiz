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
    
    func isBetterThan(_ another: GameResult) -> Bool {
            correct > another.correct
        }
    
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return "Ваш рекорд: \(correct)/\(total) (\(dateString))"
    }
}
