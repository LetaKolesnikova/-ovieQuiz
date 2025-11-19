import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    
    
    //MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    //MARK: - Properties
    private var currentQuestionIndex = 0
     var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private let statisticService = StatisticService()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupQuestionFactory()
        questionFactory?.requestNextQuestion()
        }
    
    // MARK: - QuestionFactoryDelegate

    func didRecieveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }

            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
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
    
    private func setupQuestionFactory() {
            let questionFactory = QuestionFactory()
            questionFactory.setup(delegate: self)
            self.questionFactory = questionFactory
        }
    
    private func showFirstQuestion() {
        let questionFactory = QuestionFactory()
                questionFactory.setup(delegate: self)
                self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func handleAnswer(_ givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // Сохраняем результаты текущей игры
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            // Показываем результаты
            let result = QuizResultsViewModel(
                title: "Результат",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                buttonText: "Сыграть еще раз"
            )
            show(quiz: result)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    func show(quiz result: QuizResultsViewModel) {
        let title = "Этот раунд окончен!"
        let message = """
        Ваш результат: \(correctAnswers)/10
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(statisticService.bestGame.formattedString())
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        let buttonText = "Сыграть ещё раз"
        
        let model = AlertModel(title: title, message: message, buttonText: buttonText) { [weak self] in
            guard let self = self else { return }

            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.show(in: self, model: model)
    }
        
       
}
    

