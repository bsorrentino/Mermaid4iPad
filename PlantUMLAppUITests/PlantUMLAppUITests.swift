//
//  PlantUMLAppUITests.swift
//  PlantUMLAppUITests
//
//  Created by Bartolomeo Sorrentino on 03/04/23.
//

import XCTest


// table extension
extension XCUIElement {
    

    // [Perform a full swipe left action in UI Tests?](https://stackoverflow.com/a/51639973)
    func longSwipeLeft() {
        let startOffset: CGVector
        let endOffset: CGVector

        startOffset = CGVector(dx: 0.6, dy: 0.0)
        endOffset = CGVector.zero

        let startPoint = self.coordinate(withNormalizedOffset: startOffset)
        let endPoint = self.coordinate(withNormalizedOffset: endOffset)
        startPoint.press(forDuration: 0, thenDragTo: endPoint)
    }
    
    
}

extension XCUIApplication {
    
    func tapCoordinate(at point: CGPoint) {
        let normalized = coordinate(withNormalizedOffset: .zero)
        let offset = CGVector(dx: point.x, dy: point.y)
        let coordinate = normalized.withOffset(offset)
        coordinate.tap()
    }
}

extension XCUIElementQuery {
    
}


extension XCTestCase {
    
    func waitForNotExistence( element: XCUIElement, timeout: TimeInterval ) {
        let predicate = NSPredicate(format: "exists == FALSE")

        expectation(for: predicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func waitUntilEnabled( element: XCUIElement, timeout: TimeInterval ) {
        let predicate = NSPredicate(format: "enabled == TRUE")

        let _ = XCTWaiter.wait( for: [ expectation(for: predicate, evaluatedWith: element, handler: nil) ], timeout: timeout )

    }
    
    func wait( reason description: String, timeout: TimeInterval ) {
        let _ = XCTWaiter.wait( for: [ expectation(description: description) ], timeout: timeout )
    }

}

final class PlantUMLAppUITests: XCTestCase {
    
    var app: XCUIApplication?
    
    override func setUpWithError() throws {
// [iOS Localization and Internationalization Testing with XCUITest](https://medium.com/xcblog/ios-localization-and-internationalization-testing-with-xcuitest-495747a74775)
//        let app = XCUIApplication()
//        app.launchArguments += ["-AppleLanguages", "(en)"]
//        app.launchArguments += ["-AppleLocale", "en_US"]
//        app.launch()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        guard let app else { return }
        
        wait( reason: "wait before exit", timeout: 5.0 )

        // [How to access back bar button item in universal way under UITests in Xcode?](https://stackoverflow.com/a/38595332/521197)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // delete document
        let predicate = NSPredicate(format: "label beginswith 'Untitled'")
        let query = app.collectionViews.cells.matching(predicate)
            
        XCTAssertTrue(query.element.exists)
        
        for _ in 0..<query.count {
            let e = query.element(boundBy: 0)
            XCTAssertEqual( e.elementType, XCUIElement.ElementType.cell)
            e.press(forDuration: 2.0 )
            
            XCTAssertTrue( app.collectionViews.buttons["Delete"].exists )
            app.collectionViews.buttons["Delete"].tap()
        }
        
        self.app = nil
    }

    func findConteMenuDeleteItem() throws {
        // UI tests must launch the application that they test.
        self.app = XCUIApplication()
        
        guard let app else { XCTFail( "error creating XCUIApplication instance") ; return }
        
        app.launch()

        XCTAssertTrue(  app.collectionViews.element.waitForExistence(timeout: 10) )

        let predicate = NSPredicate(format: "label beginswith 'Untitled'")
        let query = app.collectionViews.cells.matching(predicate)
        
        XCTAssertTrue(query.element.exists)
        XCTAssertTrue(query.count > 0)

        let e = query.element(boundBy: 0)
        XCTAssertEqual( e.elementType, XCUIElement.ElementType.cell)
        e.press(forDuration: 2.0 )
                
        // [iOS UI testing: element descendants](https://pgu.dev/2020/12/20/ios-ui-tests-element-descendants.html)
        XCTAssertTrue( app.collectionViews.buttons["Delete"].exists )

    }
    
    
    func getPlantUMLKeyboard( _ app: XCUIApplication, handler: (( ( customKeyboard: XCUIElement, addBelow: XCUIElement, addAbove: XCUIElement ) ) -> Void)  ) -> Void {

        XCTAssertTrue(app.buttons["PlantUML Keyboard"].waitForExistence(timeout: 3.0))
        XCTAssertTrue(app.buttons["Add Below"].exists)
        XCTAssertTrue(app.buttons["Add Above"].exists)
        
        handler( (
            customKeyboard: app.buttons["PlantUML Keyboard"],
            addBelow: app.buttons["Add Below"],
            addAbove: app.buttons["Add Above"]
        ))

    }
    
    
    func selectChoice(  _ app: XCUIApplication, ofTab tab: String, forKey key: String, value choice: String  ) {
        
        XCTAssertTrue(app.buttons[tab].exists)
        XCTAssertTrue(app.buttons[tab].isSelected)

        app.buttons[key].tap()
        
        let choiceView = app.descendants(matching: .other).matching(identifier: "choiceview" ).element
        XCTAssertTrue(choiceView.exists)
        
        let choiceCells = choiceView.descendants(matching: .cell)
        XCTAssertEqual(choiceCells.count, 12)
        
        let choiceSelected = [0..<choiceCells.count].map { r in
            choiceCells.element(boundBy: r.startIndex).staticTexts.element(boundBy: 0)
        }
        .first( where: { $0.label == choice })

        XCTAssertNotNil(choiceSelected)

        choiceSelected?.tap()
 
    }
    
    func selectColor(  _ app: XCUIApplication, ofTab tab: String, forKey key: String, value choice: String  ) {
        
        XCTAssertTrue(app.buttons[tab].exists)
        XCTAssertTrue(app.buttons[tab].isSelected)

        // app.buttons[key].tap()
        
        let d = app.descendants(matching: .other)
        for i in 0..<d.count {
            
            let e = d.element(boundBy: i)
            if e.exists {
                print( "element[\(i)].id[\(e.title)]" )

            }
        }
         
    }

    
    func testPlantUMLKeyboard() throws {

        self.app = XCUIApplication()
        
        guard let app else { XCTFail( "error creating XCUIApplication instance") ; return }

        app.launch()

        XCTAssertTrue(  app.collectionViews.element.waitForExistence(timeout: 10) )
        
        let predicate = NSPredicate(format: "label beginswith 'Create Document'")
        let cell = app.collectionViews.cells.matching(predicate).element
        
        XCTAssertTrue(cell.exists)
        
        wait( reason: "wait before open diagram", timeout: 3.0 )

        cell.tap()
    
        XCTAssertTrue( app.tables.element.waitForExistence(timeout: 10) )
        XCTAssertTrue( app.buttons["editor"].waitForExistence(timeout: 10) )
        XCTAssertTrue( app.buttons["diagram"].waitForExistence(timeout: 10) )

        app.buttons["editor"].tap()
        
        XCTAssertEqual( app.tables.cells.count, 1 )

        getCellTextField(table: app.tables.element, atRow: 0 ) { textField in

            textField.tap()
            XCTAssertEqual( textField.valueAsString(), "Title untitled")

        }
        
        getPlantUMLKeyboard( app ) { (customKeyboard, _, addAbove) in
        
            addAbove.tap()
       
            XCTAssertEqual( app.tables.cells.count, 2 )

            customKeyboard.tap()

            XCTAssertTrue(app.buttons["general"].waitForExistence(timeout: 3.0))
            XCTAssertTrue(app.buttons["sequence"].exists)

        }

        selectColor( app, ofTab: "general", forKey: "#color", value: "")

        selectChoice( app, ofTab: "general", forKey: "skinparam", value: "linetype ortho")
                
        let _ = getCellTextField(table: app.tables.element, atRow: 1 ) { textField in
            textField.tap()
        }
                
//        XCTAssertTrue(app.buttons["dismiss"].exists)
//        app.buttons["dismiss"].tap()
        
        getPlantUMLKeyboard( app ) { ( customKeyboard, addBelow, _ ) in

            addBelow.tap()

            customKeyboard.tap()
            if !app.buttons["general"].waitForExistence(timeout: 0.5) { // FIX SHOW KEYBOARD BUG
                customKeyboard.tap()
            }

        }
        
        XCTAssertTrue(app.buttons["general"].waitForExistence(timeout: 3.0))
        XCTAssertTrue(app.buttons["sequence"].exists)

        app.buttons["sequence"].tap()

        XCTAssertTrue(app.buttons["hide footbox"].exists)
        
        app.buttons["hide footbox"].tap()
        
        
    }
    
    func testCopyAndPasteDiagram() {
        // UI tests must launch the application that they test.
        self.app = XCUIApplication()
        
        guard let app else { XCTFail( "error creating XCUIApplication instance") ; return }

        app.launch()

        XCTAssertTrue(  app.collectionViews.element.waitForExistence(timeout: 10) )

        
    }
    
    
    func testSequenceDiagram() throws {
        // UI tests must launch the application that they test.
        self.app = XCUIApplication()
        
        guard let app else { XCTFail( "error creating XCUIApplication instance") ; return }

        app.launch()

        XCTAssertTrue(  app.collectionViews.element.waitForExistence(timeout: 10) )

        let predicate = NSPredicate(format: "label beginswith 'Create Document'")
        let cell = app.collectionViews.cells.matching(predicate).element
        
        XCTAssertTrue(cell.exists)
        
        wait( reason: "wait before open diagram", timeout: 3.0 )

        cell.tap()
    
        XCTAssertTrue( app.tables.element.waitForExistence(timeout: 10) )
        XCTAssertTrue( app.buttons["editor"].waitForExistence(timeout: 10) )
        XCTAssertTrue( app.buttons["diagram"].waitForExistence(timeout: 10) )

        app.buttons["editor"].tap()
        
        XCTAssertEqual( app.tables.cells.count, 1 )

        getCellTextField(table: app.tables.element, atRow: 0 ) { textField in
            textField.tap()

            XCTAssertEqual( textField.valueAsString(), "Title untitled")
            
            textField.typeBackspace(times: 8)
            XCTAssertEqual( textField.valueAsString(), "Title ")
            
            textField.typeText( "sequence diagram\n")
            XCTAssertEqual( textField.valueAsString(), "Title sequence diagram")
        }
       
        XCTAssertEqual( app.tables.cells.count, 2 )
        
        getPlantUMLKeyboard( app ) { ( customKeyboard, addBelow, _ ) in

            customKeyboard.tap()
            if !app.buttons["general"].waitForExistence(timeout: 0.5) { // FIX SHOW KEYBOARD BUG
                customKeyboard.tap()
            }

            XCTAssertTrue(app.buttons["general"].waitForExistence(timeout: 3.0))
            XCTAssertTrue(app.buttons["sequence"].waitForExistence(timeout: 3.0))

            app.buttons["general"].tap()

            selectChoice( app, ofTab: "general", forKey: "skinparam", value: "linetype ortho")
            
            addBelow.tap()
            
        }
        
        """
        Bob -> Alice : Authentication Request
        Bob <- Alice : Authentication Response
        """.split(whereSeparator: \.isNewline).forEach { value in

            let nextText = app.tables.cells.count - 1

            getCellTextField(table: app.tables.element, atRow: nextText ) { textField in
                textField.tap()
                textField.typeText( "\(value)\n")
            }

        }
        
        app.buttons["diagram"].tap()

        wait( reason: "wait before back to diagram", timeout: 5.0 )

        app.buttons["editor"].tap()

        getCellTextField(table: app.tables.element, atRow: 1 ) { textField in
            textField.tap()
        }

        getPlantUMLKeyboard( app ) { ( customKeyboard, addBelow, _ ) in

            addBelow.tap()
            
            customKeyboard.tap()
            if !app.buttons["general"].waitForExistence(timeout: 0.5) { // FIX SHOW KEYBOARD BUG
                customKeyboard.tap()
            }

            XCTAssertTrue(app.buttons["general"].waitForExistence(timeout: 3.0))
            XCTAssertTrue(app.buttons["sequence"].waitForExistence(timeout: 3.0))

            app.buttons["sequence"].tap()
            
            XCTAssertTrue(app.buttons["hide footbox"].exists)
            
            app.buttons["hide footbox"].tap()

            addBelow.tap()

            customKeyboard.tap()
            if !app.buttons["sequence"].waitForExistence(timeout: 0.5) { // FIX SHOW KEYBOARD BUG
                customKeyboard.tap()
            }

            XCTAssertTrue(app.buttons["autonumber"].exists)
            
            app.buttons["autonumber"].tap()

            customKeyboard.tap()
        }

        XCTAssertEqual( app.tables.cells.count, 6 )
        
        app.buttons["diagram"].tap()


//        wait( reason: "wait before exit", timeout: 5.0 )
//
//        app.buttons["editor"].tap()
//
//        getCellTextField(table: app.tables.element, atRow: app.tables.cells.count - 1 ) { textField in
//            textField.tap()
//        }
//
//        app.buttons["diagram"].tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testActivityDiagram() throws {
        // UI tests must launch the application that they test.
        self.app = XCUIApplication()
        
        guard let app else { XCTFail( "error creating XCUIApplication instance") ; return }

        app.launch()

        XCTAssertTrue(  app.collectionViews.element.waitForExistence(timeout: 10) )

        let predicate = NSPredicate(format: "label beginswith 'Create Document'")
        let cell = app.collectionViews.cells.matching(predicate).element
        
        XCTAssertTrue(cell.exists)
        
        wait( reason: "wait before open diagram", timeout: 3.0 )

        cell.tap()
    
        XCTAssertTrue( app.tables.element.waitForExistence(timeout: 10) )
        XCTAssertTrue( app.buttons["editor"].waitForExistence(timeout: 10) )
        XCTAssertTrue( app.buttons["diagram"].waitForExistence(timeout: 10) )

        app.buttons["editor"].tap()
        
        XCTAssertEqual( app.tables.cells.count, 1 )

        getCellTextField(table: app.tables.element, atRow: 0 ) { textField in
            textField.tap()
            XCTAssertEqual( textField.valueAsString(), "Title untitled")
            
            textField.typeBackspace(times: 8)
            XCTAssertEqual( textField.valueAsString(), "Title ")
            
            textField.typeText( "activity diagram\n")
            XCTAssertEqual( textField.valueAsString(), "Title activity diagram")
        }

       
        XCTAssertEqual( app.tables.cells.count, 2 )

        """
        start
        if (condition A) then (yes)
          :Text 1;
        elseif (condition B) then (yes)
          :Text 2;
          stop
        (no) elseif (condition C) then (yes)
          :Text 3;
        (no) elseif (condition D) then (yes)
          :Text 4;
        else (nothing)
          :Text else;
        endif
        stop
        """.split(whereSeparator: \.isNewline).forEach { value in
            
            let nextText = app.tables.cells.count - 1
            
            getCellTextField(table: app.tables.element, atRow: nextText ) { textField in
                textField.tap()
                textField.typeText( "\(value)\n")
            }
            
        }
        
        app.buttons["diagram"].tap()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}