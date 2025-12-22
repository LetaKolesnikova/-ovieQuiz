import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    
    func testYesButton() {
        let firstPoster = app.images["Poster"]
        let exists = firstPoster.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "Постер не появился за 10 секунд")
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let yesButton = app.buttons["Yes"]
        XCTAssertTrue(yesButton.waitForExistence(timeout: 5), "Кнопка Yes не найдена")
        
        yesButton.tap()
        
        let expectation = XCTestExpectation(description: "Wait for UI update after Yes tap")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 5), "Постер исчез после ответа")
        let secondPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData, "Постер должен измениться после ответа")
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 10), "Постер не появился")
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let noButton = app.buttons["No"]
        XCTAssertTrue(noButton.waitForExistence(timeout: 5), "Кнопка No не найдена")
        noButton.tap()
        
        let expectation = XCTestExpectation(description: "Wait for UI update after No tap")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 5), "Label Index не найден")
        
        XCTAssertEqual(indexLabel.label, "2/10", "Индекс должен быть 2/10 после первого ответа. Фактический: \(indexLabel.label)")
        
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 5), "Постер исчез")
        let secondPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData, "Постер должен измениться после ответа")
    }
    
    func testGameFinish() {
        let initialPoster = app.images["Poster"]
        XCTAssertTrue(initialPoster.waitForExistence(timeout: 10), "Приложение не загрузилось")
        
        let noButton = app.buttons["No"]
        XCTAssertTrue(noButton.waitForExistence(timeout: 5), "Кнопка No не найдена")
        
        for i in 1...10 {
            print("Отвечаем на вопрос \(i)")
            
            XCTAssertTrue(noButton.waitForExistence(timeout: 3), "Кнопка No не доступна на вопросе \(i)")
            
            let currentIndexLabel = app.staticTexts["Index"]
            if currentIndexLabel.waitForExistence(timeout: 2) {
                print("Текущий индекс: \(currentIndexLabel.label)")
            }
            
            noButton.tap()
            
            if i < 10 {
                let expectation = XCTestExpectation(description: "Wait between questions")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    expectation.fulfill()
                }
                wait(for: [expectation], timeout: 1)
            }
        }
        
        print("Ожидаем алерт после завершения игры...")
        
        var alert: XCUIElement?
        let possibleAlertTitles = ["Этот раунд окончен!", "Game results", "Результаты игры", "Game over"]
        
        for title in possibleAlertTitles {
            let possibleAlert = app.alerts[title]
            if possibleAlert.waitForExistence(timeout: 2) {
                alert = possibleAlert
                print("Найден алерт с заголовком: \(title)")
                break
            }
        }
        
        XCTAssertNotNil(alert, "Алерт не появился после завершения 10 вопросов")
        
        if let alert = alert {
            XCTAssertTrue(alert.exists, "Алерт должен существовать")
            
            let playAgainButton = alert.buttons["Сыграть ещё раз"]
            let retryButton = alert.buttons["Повторить"]
            let okButton = alert.buttons["OK"]
            
            if playAgainButton.waitForExistence(timeout: 2) {
                XCTAssertTrue(playAgainButton.exists, "Кнопка 'Сыграть ещё раз' должна существовать")
            } else if retryButton.waitForExistence(timeout: 2) {
                XCTAssertTrue(retryButton.exists, "Кнопка 'Повторить' должна существовать")
            } else if okButton.waitForExistence(timeout: 2) {
                XCTAssertTrue(okButton.exists, "Кнопка 'OK' должна существовать")
            } else {
                XCTAssertTrue(alert.buttons.firstMatch.waitForExistence(timeout: 2),
                            "Должна быть хотя бы одна кнопка в алерте")
            }
        }
    }
}
