//
//  iOS_Developer_TestTests.swift
//  iOS Developer TestTests
//
//  Created by Motiur Rahaman on 2023-01-16.
//

import XCTest
@testable import iOS_Developer_Test

final class iOS_Developer_TestUnitTest: XCTestCase {

    var sut: URLSession!

    override func setUp() {
        super.setUp()
        sut = URLSession(configuration: .default)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }


    func testValidCallToJSONPlaceholer() {
        // given
        let url = URL(string: "https://iphonephotographyschool.com/test-api/lessons")

        //What we expect to happen
        let promise = expectation(description: "Status code: 200 or 201")

        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in

            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {

                if statusCode == 200 || statusCode == 201 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()

        //Keeps the test running until all expectations are fulfilled, or the timeout interval ends, whichever happens first
        wait(for: [promise], timeout: 5)
    }

}
