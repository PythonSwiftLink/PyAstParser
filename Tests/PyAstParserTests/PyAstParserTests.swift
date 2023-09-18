import XCTest
import PythonLib
import PythonSwiftCore
@testable import PyAstParser
@testable import PythonTestSuite
import PyAstBuilder
import SwiftSyntax



final class PyAstParserTests: XCTestCase {
    func test_PyAstParser_export_ClassDef() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
		
		initPython()
		astorToSource
		return
        let cls = PyAst_Class(
			name: "MyClass",
			body: [
				PyAst_Function(
					name: "MyFunctionA",
					body: ["..."],
					args: [
						.init(arg: "a"),
						.init(arg: "b", annotation: "int")
					],
					keywords: [],
					decorator_list: [
						"myDecorator"
					],
					returns: nil
				)
			],
			bases: [],
			keywords: [],
			decorator_list: []
		)
		
		let cls_object = cls.pyPointer

		PyErr_Print()
		
		let code_string: String = try! astorToSource(cls_object)
		
		print("\n########################################\n")
		print(code_string)
		print("\n########################################\n")
		//print(code_string)
		cls_object.decref()
    }
	
	
	func test_PyAstBuilder_init_ClassDef() throws {
		initPython()
		astorToSource
		parseToAstModule(statements: testBuilderTree.statements)
	}
}
