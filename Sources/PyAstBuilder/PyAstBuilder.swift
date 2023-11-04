
import Foundation
import PyAstParser
import SwiftSyntax
import SwiftParser
//import PythonLib
import PythonSwiftCore

let math = PyImport_ImportModule("math")!
public let astorToSource: PyPointer = pythonImport(from: "astor", import_name: "to_source")!
public let run_astor = PyImport_Import("run_astor")!
public let makeSource: PyPointer = PyObject_GetAttr(run_astor, "makeSource")!
public let makeClass: PyPointer = PyObject_GetAttr(run_astor, "makeClass")!
public let makeTest: PyPointer = PyObject_GetAttr(run_astor, "test")!

protocol PyAstBuilder {
	
}
func handleSyntaxChildren(child: MemberBlockItemSyntax) -> PyAstObject {
	let decl = child.decl
	switch decl.kind {
	case .functionDecl:
		return PyAst_Function(syntax: decl.as(FunctionDeclSyntax.self)!)
	default: fatalError()
	}
	
	return ""
//	switch child.as(SyntaxEnum.self) {
//	case .functionDecl(let f):
//		fatalError("Function: \(f.name.text)")
//	default:
//		print(child.description)
//	}
//	return ""
}

public extension PyAst_Class {
	convenience init(syntax: ClassDeclSyntax) {
		let name = syntax.name.text
		
		self.init(
			name: name,
			body: syntax.memberBlock.members.map(handleSyntaxChildren),
			decorator_list: []
		)
	}
}

private enum SwiftTypes: String {
	case Int
	case Int32
	case Int16
	case Int8
	case UInt
	case UInt32
	case UInt16
	case UInt8
	case Float
	case Double
	case String
	case Array
}
func swiftToPyType(swiftType: String?) -> String {
	print(swiftType)
	if let swiftType = swiftType, let t = SwiftTypes(rawValue: swiftType.trimmingCharacters(in: .whitespaces)) {
		
		switch t {
			
		case .Int, .Int32, .Int16, .Int8, .UInt, .UInt32, .UInt16, .UInt8:
			return "int"
		case .Float,  .Double:
			return "float"
		case .String:
			return "str"
		case .Array:
			return "list"
		}
	}
	return "None"
}

public extension PyAst_Arg {
	
	
	
	convenience init(syntax: FunctionParameterListSyntax.Element) {
		self.init(arg: syntax.firstName.text, annotation: swiftToPyType(swiftType: syntax.type.description))
	}
}

public extension PyAst_Function {
	
	convenience init(syntax: FunctionDeclSyntax) {
		self.init(
			name: syntax.name.text,
			body: [" ..."],
			args: syntax.signature.parameterClause.parameters.map(PyAst_Arg.init),
			keywords: [],
			decorator_list: [],
			returns: " \(swiftToPyType(swiftType: syntax.signature.returnClause?.type.description))"
		)
	}
}

public func parseToAstModule(statements: CodeBlockItemListSyntax) {
	var export = [PyAstObject]()
	for stmt in statements {
		let item = stmt.item
		if let _cls_ = item.as(ClassDeclSyntax.self) {
			
			let ast_cls = PyAst_Class(syntax: _cls_).pyPointer
			
			print("\n###################################\n")
			print( try! astorToSource(ast_cls) as String )
			print("\n###################################\n")
			
		} else if let _enum_ = item.as(EnumDeclSyntax.self) {
			print("\(EnumDeclSyntax.self): \(_enum_.name.text)")
		}
	}
}


public let testBuilderTree = Parser.parse(source: """

class MySwiftClass {

	func MyFunction(a: Int) -> String {
	
	}
}

enum MySwiftEnum: String {
	case MyCase
}

""")
