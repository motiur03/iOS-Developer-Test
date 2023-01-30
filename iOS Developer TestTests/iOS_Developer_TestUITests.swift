//
//  iOS_Developer_TestUITests.swift
//  iOS Developer TestUITests
//
//  Created by Motiur Rahaman on 2023-01-16.
//

import XCTest
@testable import iOS_Developer_Test
import SwiftUI

final class iOS_Developer_TestUITests: XCTestCase {
    var app = XCUIApplication()
    var lodedLession: ContentView!
    @State private var lessions: [lession] = []

    override func setUp() {
        continueAfterFailure = true
        app = XCUIApplication()
        app.launch()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    func test_should_display_screen_on_launch() {
        
        app.launch()
        
        let lessonNavBarTitle = app.staticTexts["Lessons"]
        XCTAssertTrue(lessonNavBarTitle.waitForExistence(timeout: 0.5))
        
   
        
    }
    func testCategoryRowDisplaysCategoryNameWithLandmarks() throws {
       // let app = XCUIApplication()
        app.launch()

       Task {
            do {
                let response = try await ApiManager.shared.generateLession()
                 lessions = response.lessons
                
             
                
                print("urls \(lessions)")
                
            } catch {
           
                print(error)
           
                
            }
        }
 
        XCTAssertEqual(lessions.count,lodedLession.lessions.count)
        
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
}
