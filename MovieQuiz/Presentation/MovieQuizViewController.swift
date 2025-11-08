import UIKit

final class MovieQuizViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    //MARK: - Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    //MARK: - Models
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    //MARK: - Data
    private let questions: [QuizQuestion] = [
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showFirstQuestion()
    }
    
    //MARK: - Actions
    @IBAction func yesButtonTapped(_ sender: Any) {
        handleAnswer(true)
    }
    @IBAction func noButtonTapped(_ sender: Any) {
        handleAnswer(false)
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        posterImageView.layer.cornerRadius = 20
        posterImageView.layer.masksToBounds = true
    }
    
    private func showFirstQuestion() {
        let firstQuestion = questions[currentQuestionIndex]
                let viewModel = convert(model: firstQuestion)
                show(quiz: viewModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        posterImageView.image = step.image
        questionTextLabel.text = step.question
        counterLabel.text = step.questionNumber
        posterImageView.layer.borderWidth = 0
        posterImageView.layer.borderColor = nil
        yesButton.isEnabled = true
        noButton.isEnabled = true
       }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.borderWidth = 8
        posterImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        posterImageView.layer.cornerRadius = 20
        
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func handleAnswer(_ givenAnswer: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
                    let viewModel = QuizResultsViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
                    show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    
    private func show(quiz result: QuizResultsViewModel) {
           let alert = UIAlertController(
               title: result.title,
               message: result.text,
               preferredStyle: .alert)
           
           let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
               self.currentQuestionIndex = 0
               self.correctAnswers = 0
               
               let firstQuestion = self.questions[self.currentQuestionIndex]
               let viewModel = self.convert(model: firstQuestion)
               self.show(quiz: viewModel)
           }
           
           alert.addAction(action)
           self.present(alert, animated: true, completion: nil)
       }
}
    

