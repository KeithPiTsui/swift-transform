/*
   Copyright 2017 Ryuichi Laboratories and the Yanagiba project contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import XCTest

@testable import Source

func runTest(
  _ resourceName: String,
  _ testName: String,
  convertor convert: (SourceFile) -> String
) {
  let pwd = URL(fileURLWithPath: #file).deletingLastPathComponent().path
  let testTarget = "\(resourceName)/\(testName)"
  let testPath = "\(pwd)/\(testTarget)"
  let sourcePath = "\(testPath).source"
  let resultPath = "\(testPath).result"
  guard let sourceContent = try? String(contentsOfFile: sourcePath, encoding: .utf8),
    let resultContent = try? String(contentsOfFile: resultPath, encoding: .utf8)
  else {
    XCTFail("Failed in reading contents for \(testPath)")
    return
  }

  let sourceFile = SourceFile(path: "\(testTarget)Tests.swift", content: sourceContent)
  let result = convert(sourceFile)

  AssertTextEquals(result, resultContent)
}


func AssertTextEquals(_ translate: String?, _ expected: String) {
    guard let translate = translate else {
        XCTFail("Translation failed")
        return
    }

    if translate != expected {
        //Find text difference
        let difference = prettyFirstDifferenceBetweenStrings(translate as NSString, expected as NSString)
        XCTFail(difference)
    }
}



/// Find first differing character between two strings
///
/// :param: s1 First String
/// :param: s2 Second String
///
/// :returns: .DifferenceAtIndex(i) or .NoDifference
public func firstDifferenceBetweenStrings(_ s1: NSString, _ s2: NSString) -> FirstDifferenceResult {
    let len1 = s1.length
    let len2 = s2.length

    let lenMin = min(len1, len2)

    for i in 0..<lenMin {
        if s1.character(at: i) != s2.character(at: i) {
            return .DifferenceAtIndex(i)
        }
    }

    if len1 < len2 {
        return .DifferenceAtIndex(len1)
    }

    if len2 < len1 {
        return .DifferenceAtIndex(len2)
    }

    return .NoDifference
}


/// Create a formatted String representation of difference between strings
///
/// :param: s1 First string
/// :param: s2 Second string
///
/// :returns: a string, possibly containing significant whitespace and newlines
public func prettyFirstDifferenceBetweenStrings(_ s1: NSString, _ s2: NSString) -> String {
    let firstDifferenceResult = firstDifferenceBetweenStrings(s1, s2)
    return prettyDescriptionOfFirstDifferenceResult(firstDifferenceResult, s1, s2)
}


/// Create a formatted String representation of a FirstDifferenceResult for two strings
///
/// :param: firstDifferenceResult FirstDifferenceResult
/// :param: s1 First string used in generation of firstDifferenceResult
/// :param: s2 Second string used in generation of firstDifferenceResult
///
/// :returns: a printable string, possibly containing significant whitespace and newlines
public func prettyDescriptionOfFirstDifferenceResult(_ firstDifferenceResult: FirstDifferenceResult, _ s1: NSString, _ s2: NSString) -> String {

    func diffString(_ index: Int, _ s1: NSString, _ s2: NSString) -> String {
        let markerArrow = "👉"
        let ellipsis    = "…"
        /// Given a string and a range, return a string representing that substring.
        ///
        /// If the range starts at a position other than 0, an ellipsis
        /// will be included at the beginning.
        ///
        /// If the range ends before the actual end of the string,
        /// an ellipsis is added at the end.
        func windowSubstring(_ s: NSString, _ range: NSRange, isPrefix: Bool = false, isSuffix: Bool = false) -> String {
            let validRange = NSMakeRange(range.location, min(range.length, s.length - range.location))
            let substring = s.substring(with: validRange)

            let prefix = isPrefix && range.location > 0 ? ellipsis : ""
            let suffix = isSuffix && (s.length - range.location > range.length) ? ellipsis : ""

            return "\(prefix)\(substring)\(suffix)"
        }

        // Show this many characters before and after the first difference
        let windowPrefixLength = min(120, index)
        let windowSuffixLength = 120

        let prefix1 = windowSubstring(s1, NSMakeRange(index - windowPrefixLength, windowPrefixLength), isPrefix: true)
        let suffix1 = windowSubstring(s1, NSMakeRange(index, windowSuffixLength), isSuffix: true)

        let prefix2 = windowSubstring(s2, NSMakeRange(index - windowPrefixLength, windowPrefixLength), isPrefix: true)
        let suffix2 = windowSubstring(s2, NSMakeRange(index, windowSuffixLength), isSuffix: true)

        return "Difference at index \(index):\n------ Result: \n\(prefix1)\(markerArrow)\(suffix1)\n------ Expected:\n\(prefix2)\(markerArrow)\(suffix2)\n------\n"
    }

    switch firstDifferenceResult {
    case .NoDifference:                 return "No difference"
    case .DifferenceAtIndex(let index): return diffString(index, s1, s2)
    }
}


/// Result type for firstDifferenceBetweenStrings()
public enum FirstDifferenceResult {
    /// Strings are identical
    case NoDifference

    /// Strings differ at the specified index.
    ///
    /// This could mean that characters at the specified index are different,
    /// or that one string is longer than the other
    case DifferenceAtIndex(Int)
}


