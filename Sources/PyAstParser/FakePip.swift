import Foundation
import PyAst
import PySwiftKit
import PathKit
import PyCallable
import PySerializing

extension String {
	var ast_name: AST.Name { .init(id: self) }
	var ast_constant: AST.Constant { .init(stringLiteral: self) }
}

extension String {
    public func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"
        return self.processCamalCaseRegex(pattern: acronymPattern)?
            .processCamalCaseRegex(pattern: normalPattern)?.lowercased() ?? self.lowercased()
    }
    
    fileprivate func processCamalCaseRegex(pattern: String) -> String? {
        //let regex = try? Regex(pattern)
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}

extension Array where Element == any Stmt {
	var pyArray: [PyPointer] {
        lazy.compactMap(Stmt2PyPointer)
	}
	var pyList: PyPointer {
        guard let list = PyList_New(count) else { fatalError("creating new list failed, make sure GIL is active")}
        var _count = 0
        for element in pyArray {
            PyList_SetItem(list, _count, element)
            _count += 1
        }
        return list
    }
}

//extension Array where Element == any ExprProtocol {
//	var pyArray: [PyPointer] {
//		lazy.compactMap(Expr2PyPointer)
//	}
//	var pyList: PyPointer { pyArray.pyPointer }
//}



extension AST.Name {
	func processType() -> Self {
		switch id {
		case "Error", "URL": return .init(id: "str")
		case "data": return .init(id: "bytes")
		default: break
		}
		
		return self
	}
}

extension AST.Constant {
	func processType() -> Self {
		switch value {
		case "Error", "URL": return .init(stringLiteral: "str")
		case "data": return .init(stringLiteral: "bytes")
		default: break
		}
		
		return self
	}
}

func Stmt2PyPointer(_ stmt: any Stmt) -> PyPointer? {
    switch stmt.type {
    case .ClassDef:
        (stmt as? AST.ClassDef)?.pyPointer
    case .FunctionDef:
        (stmt as? AST.FunctionDef)?.pyPointer
    case .AnnAssign:
        (stmt as? AST.AnnAssign)?.pyPointer
    case .ImportFrom:
        (stmt as? AST.ImportFrom)?.pyPointer
        //(stmt as? AST.ImportFrom)
//            case .Expr:
//                (stmt as? AST.Expr)?.pyPointer
    default: fatalError()
    }
}

func Expr2PyPointer(_ expr: (any ExprProtocol)?) -> PyPointer? {
	return switch expr?.type {
	
	case .Name:
        (expr as! AST.Name).pyPointer
	case .Constant:
		(expr as! AST.Constant).pyPointer
	case .Subscript:
		(expr as! AST.Subscript).pyPointer
    case .Slice:
        (expr as! AST.Slice).pyPointer
//	case .Call:
//		(expr as! AST.Call).pyPointer
	case .Tuple:
		(expr as! AST.Tuple).pyPointer
	case .List:
		(expr as! AST.List).pyPointer
    case .NoneType:
            .None
	case .BinOp:
		(expr as! AST.BinOp).pyPointer
//	case .Attribute:
//		(expr as! AST.Attribute)?.pyPointer
	default: nil
	}
}


//public func venv_dump(wrapper: Path) throws -> PyPointer {
//	let module = try PyWrap.parse(file: wrapper.url)
//	var type_vars = [AnyArg]()
//	var ast_classes: [any Stmt] = module.classes.map(generateAstClass)
//	var class_names: [String] = module.classes.map(\.name)
//	for cls in module.classes {
//		for function in cls.functions ?? [] {
//			for arg in function.args {
//				if arg.type.py_type == .other {
//					
//					if !class_names.contains(arg.name), !type_vars.contains(where: {$0.type.string == arg.type.string }) {
//						type_vars.append(arg)
//					}
//				}
//			}
//		}
//		for function in cls.callbacks?.functions ?? [] {
//			for arg in function.args {
//				if arg.type.py_type == .other {
//					
//					if !class_names.contains(arg.name), !type_vars.contains(where: {$0.type.string == arg.type.string }) {
//						type_vars.append(arg)
//					}
//				}
//			}
//		}
//	}
//	//	let imports: [Stmt] = [
//	//		//AST.ImportFrom(module: "", names: <#T##[AST.Alias]#>, level: <#T##Int#>, lineno: <#T##Int#>, col_offset: <#T##Int#>)
//	//	]
//	var _type_vars = [String]()
//	for type_var in type_vars {
//		_type_vars.append(type_var.type.string)
//	}
//	var ast_module = AstExportModule(body: ast_classes, type_vars: _type_vars)
//	
//	return ast_module.pyPointer
//}
//
//
//
//fileprivate func withGIL<O: PyEncodable>(handle: @escaping ()->O ) -> O {
//	let gil = PyGILState_Ensure()
//	let result = handle()
//	PyGILState_Release(gil)
//	return result
//}


