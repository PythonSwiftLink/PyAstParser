
import Foundation
import PyAst
import SwiftSyntax
import SwiftParser
//import PythonLib
import PySwiftKit

let math = PyImport_ImportModule("math")!
//public let astorToSource: PyPointer = PyImport(from: "astor", import_name: "to_source")!
//public let run_astor = PyImport_ImportModule("run_astor")!
//public let makeSource: PyPointer = PyObject_GetAttr(run_astor, "makeSource")!
//public let makeClass: PyPointer = PyObject_GetAttr(run_astor, "makeClass")!
//public let makeTest: PyPointer = PyObject_GetAttr(run_astor, "test")!




enum PyTypeRepresentation {
    case int
    case float
    case bool
    case str
    case none
    case object
    case list(TypeSyntax)
    case dict(DictionaryTypeSyntax)
    case optional(OptionalTypeSyntax)
    case PyWrapped(TypeSyntax)
    case callable(FunctionTypeSyntax)
    
    var py_type: String {
        switch self {
                case .int: "int"
                case .float: "float"
                case .bool: "bool"
        case .str: "str"
        case .none: "None"
        case .object: "object"
        case .list(let typeSyntax): "list[\(syntaxToSwiftTypes(syntax: typeSyntax).py_type)]"
        case .dict(_): "dict"
        case .optional(let typeSyntax):
            "\(syntaxToSwiftTypes(syntax: typeSyntax.wrappedType).py_type) | None"
        case .PyWrapped(let typeSyntax):
            "\"\(typeSyntax.trimmedDescription)\""
        case .callable(_): "Callablee"
        }
    }
    var ast_name: AST.Name {
        return .init(id: py_type)
    }
}

extension PyTypeRepresentation {
    var asAst: any ExprProtocol {
        switch self {
        case .int:
            AST.Name(id: "int")
        case .float:
            AST.Name(id: "float")
        case .bool:
            AST.Name(id: "bool")
        case .str:
            AST.Name(id: "str")
        case .none:
            AST.Name(id: "None")
        case .object:
            AST.Name(id: "object")
        case .list(let typeSyntax):
            AST.Subscript(value: AST.Name(id: "list"), slice: syntaxToSwiftTypes(syntax: typeSyntax).asAst)
        case .dict(let dictionaryType):
            AST.Subscript(syntax: dictionaryType)
        case .optional(let typeSyntax):
            AST.BinOp(syntax: typeSyntax)
        case .PyWrapped(let typeSyntax):
            AST.Name(id: "\"\(typeSyntax.trimmedDescription)\"")
        case .callable(let functionTypeSyntax):
            AST.Subscript(syntax: functionTypeSyntax)
        }
    }
}


enum SwiftTypes: String {
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
    case Bool
	case String
    case PyPointer
    
    
    
}
func swiftToPyType(swiftType: String?) -> String {
	if let swiftType = swiftType, let t = SwiftTypes(rawValue: swiftType.trimmingCharacters(in: .whitespaces)) {
		
		switch t {
			
		case .Int, .Int32, .Int16, .Int8, .UInt, .UInt32, .UInt16, .UInt8:
			return "int"
		case .Float,  .Double:
			return "float"
		case .String:
			return "str"
        case .Bool:
            return "bool"
        case .PyPointer:
            return "object"
		}
	}
	return "object"
}

func syntaxToSwiftTypes(syntax: TypeSyntax) -> PyTypeRepresentation {
    
    return switch syntax.as(TypeSyntaxEnum.self) {
    case .arrayType(let arrayType):
            .list(arrayType.element)
    case .attributedType(let attributedType):
        syntaxToSwiftTypes(syntax: attributedType.baseType)
    case .dictionaryType(let dictionaryType):
            .dict(dictionaryType)
    case .functionType(let functionType):
            .callable(functionType)
    case .identifierType(let identifierType):
        switch SwiftTypes(rawValue: syntax.trimmedDescription) {
        case .Int, .Int8, .Int16, .Int32, .UInt, .UInt8, .UInt16, .UInt32: .int
        case .Float, .Double: .float
        case .String: .str
        case .PyPointer: .object
        case .Bool: .bool
        case .none: .PyWrapped(syntax)
        }
    case .optionalType(let optionalType):
            .optional(optionalType)
    default:
        PyTypeRepresentation.PyWrapped(syntax)
    }
}





