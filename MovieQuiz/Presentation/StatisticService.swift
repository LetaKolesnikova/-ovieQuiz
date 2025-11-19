
//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Виолетта Сиротина on 17.11.25.
//
import Foundation
import UIKit
final class StatisticService: StatisticServiceProtocol {
    private enum Keys {
        static let gamesCount = "gamesCount"
        static let bestGameCorrect = "bestGameCorrect"
        static let bestGameTotal = "bestGameTotal"
        static let bestGameDate = "bestGameDate"
        static let totalCorrectAnswers = "totalCorrectAnswers"
        static let totalQuestionsAsked = "totalQuestionsAsked"
    }
    private let storage: UserDefaults = .standard
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect)
            let total = storage.integer(forKey: Keys.bestGameTotal)
            let date = storage.object(forKey: Keys.bestGameDate) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect)
            storage.set(newValue.total, forKey: Keys.bestGameTotal)
            storage.set(newValue.date, forKey: Keys.bestGameDate)
        }
    }
    
    var totalAccuracy: Double {
           let correctAnswers = storage.integer(forKey: Keys.totalCorrectAnswers)
            let totalQuestions = storage.integer(forKey: Keys.totalQuestionsAsked)
            
            guard totalQuestions > 0 else { return 0.0 }
            return Double(correctAnswers) / Double(totalQuestions) * 100
        }
    
    private var totalCorrectAnswers: Int {
            get { storage.integer(forKey: Keys.totalCorrectAnswers) }
            set { storage.set(newValue, forKey: Keys.totalCorrectAnswers) }
        }
        
        private var totalQuestionsAsked: Int {
            get { storage.integer(forKey: Keys.totalQuestionsAsked) }
            set { storage.set(newValue, forKey: Keys.totalQuestionsAsked) }
        }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        if gamesCount == 1 || currentGame.isBetterThan(bestGame) {
                    bestGame = currentGame
                }
    }
    
    
}
