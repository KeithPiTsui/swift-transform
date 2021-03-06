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

@testable import Parser
@testable import Transform

class TokenizerTests : XCTestCase {
    func testTokenizer() {
        let resourceName = "Resources"
        let testNames = [
            // primary expressions
            "IdentifierExpression",
            "LiteralExpression",
            "SelfExpression",
            "SuperclassExpression",
            "ClosureExpression",
            "ParenthesizedExpression",
            "TupleExpression",
            "ImplicitMemberExpression",
            "WildcardExpression",
            "SelectorExpression",
            "KeyPathExpression",
            "KeyPathStringExpression",

            // postfix expressions
            "PostfixOperatorExpression",
            "FunctionCallExpression",
            "InitializerExpression",
            "ExplicitMemberExpression",
            "PostfixSelfExpression",
            "SubscriptExpression",
            "ForcedValueExpression",
            "OptionalChainingExpression",

            // prefix expressions
            "PrefixOperatorExpression",
            "InOutExpression",

            // binary expressions
            "BinaryOperatorExpression",
            "AssignmentOperatorExpression",
            "TernaryConditionalOperatorExpression",
            "TypeCastingOperatorExpression",
            "SequenceExpression",

            // try expression
            "TryOperatorExpression",

            // statements
            "BreakStatement",
            "CompilerControlStatement",
            "ContinueStatement",
            "DeferStatement",
            "DoStatement",
            "FallthroughStatement",
            "ForInStatement",
            "GuardStatement",
            "IfStatement",
            "LabeledStatement",
            "RepeatWhileStatement",
            "ReturnStatement",
            "SwitchStatement",
            "ThrowStatement",
            "WhileStatement",

            // declarations
            "ClassDeclaration",
            "ConstantDeclaration",
            "DeinitializerDeclaration",
            "EnumDeclaration",
            "ExtensionDeclaration",
            "FunctionDeclaration",
            "ImportDeclaration",
            "InitializerDeclaration",
            "OperatorDeclaration",
            "PrecedenceGroupDeclaration",
            "ProtocolDeclaration",
            "StructDeclaration",
            "SubscriptDeclaration",
            "TypealiasDeclaration",
            "VariableDeclaration",

            // attributes
            "Attribute",

            // types
            "Type",
            ]
        for testName in testNames {
            runTest(resourceName, testName) { source -> String in
                let parser = Parser(source: source)
                guard let topLevelDecl = try? parser.parse() else {
                    return "error: failed in parsing the source \(source.identifier)."
                }
                let tokenizer = Tokenizer()
                return tokenizer.tokenize(topLevelDecl).joinedValues()
            }
        }
    }

    static var allTests = [
        ("testGenerator", testTokenizer),
        ]
}
