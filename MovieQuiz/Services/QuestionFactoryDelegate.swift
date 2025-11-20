//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Виолетта Сиротина on 12.11.25.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?) 
}

