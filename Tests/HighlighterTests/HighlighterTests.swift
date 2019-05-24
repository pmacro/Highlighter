import XCTest
@testable import Highlighter

final class HighlighterTests: XCTestCase {
    func testExample() {

      let result = try! highlight(
                    """
                    /// A test class
                    ///
                    public class Test {
                      var test = false
                    }
                    """
                    )
      print(result)
  }

    static var allTests = [
        ("testExample", testExample),
    ]
}
