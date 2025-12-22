//
//  MovieQuizUITests_LaunchTests.swift
//  MovieQuizUITestsф
//
//  Created by Виолетта Сиротина on 6.12.25.
//

import XCTest

final class MovieQuizUITests_LaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
