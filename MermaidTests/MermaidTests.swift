//
//  MermaidTests.swift
//  MermaidTests
//
//  Created by Bartolomeo Sorrentino on 01/08/22.
//

import XCTest
import OpenAI
import AIAgent
@testable import MermaidApp

extension String {
    // [How to remove all the spaces in a String?](https://stackoverflow.com/a/34940120/521197)
    func trimAll() -> String {
        self.filter { !$0.isWhitespace }
    }
}

class MermaidTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAccessibilityId() {
        
        let msg = { ( title: String ) in "secure_toggle_field_\(title.trimAll().lowercased())"
        }
        
        XCTAssertEqual(msg( "Api Key" ), "secure_toggle_field_apikey")
        XCTAssertEqual(msg( "Org Id"), "secure_toggle_field_orgid")

    }
    
    func testGetErrorMessage() {

        let result = Errors.readingPromptError("vision prompt not found!")
        
        XCTAssertEqual( "vision prompt not found!", result.localizedDescription )

    }


    class Handler : AgentExecutorDelegate {
        func progress(_ message: String) {
            print( message )
        }
        
    }

    func testTranslateDrawingToMermaid() async throws {


        guard let openAIKey = readConfigString(forInfoDictionaryKey: "OPENAI_API_KEY") else {
            fatalError( "no OPENAI_API_KEY provided!")
        }

        let openAI = OpenAI( configuration: OpenAI.Configuration( token: openAIKey ) )

        let result =  try await translateDrawingToMermaidWithDiagramDescription( fromJSONFile: "describe_generic_result",
                                                                                 openAI: openAI,
                                                                                 delegate: Handler() )

        XCTAssertNotNil(result)
        print( result! )

    }
}
