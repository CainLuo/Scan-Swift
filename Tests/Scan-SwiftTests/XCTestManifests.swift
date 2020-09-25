import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Scan_SwiftTests.allTests),
    ]
}
#endif
