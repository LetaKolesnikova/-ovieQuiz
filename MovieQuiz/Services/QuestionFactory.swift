//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Виолетта Сиротина on 11.11.25.
//
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше, чем 6?",
            correctAnswer: false),
        
    ]
    
    
        private var usedQuestionIndices = Set<Int>()
        
        func requestNextQuestion() {
            if usedQuestionIndices.count == questions.count {
                delegate?.didRecieveNextQuestion(question: nil)
                return
            }
            
            var randomIndex: Int
            repeat {
                randomIndex = Int.random(in: 0..<questions.count)
            } while usedQuestionIndices.contains(randomIndex)
            
            usedQuestionIndices.insert(randomIndex)
            
            let question = questions[randomIndex]
            delegate?.didRecieveNextQuestion(question: question)
        }
        
        func resetGame() {
            usedQuestionIndices.removeAll()
        }
    
    
}
