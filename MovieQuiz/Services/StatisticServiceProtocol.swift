//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Виолетта Сиротина on 17.11.25.
//
import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
