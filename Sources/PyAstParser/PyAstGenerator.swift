//
//  File.swift
//  
//
//  Created by CodeBuilder on 14/09/2023.
//

import Foundation
import PythonSwiftCore
//import PythonLib



extension Array where Element == PyAstObject {
	
	var pyPointer: PyPointer {
		let list = PyList_New(0)!
		for element in self {
			let object = element.pyPointer
			PyList_Append(list, object)
			object.decref() // setting rec count back to original state
			// so when list is garbage collected and element ref count is 1
			// python will gc that object also automatic for us.
		}
		
		return list
	}
	
}

extension Array where Element: PyAst_Arg {
	
	var pyPointer: PyPointer {
		let list = PyList_New(0)!
		for element in self {
			let object = element.pyPointer
			PyList_Append(list, object)
			object.decref() // setting rec count back to original state
			// so when list is garbage collected and element ref count is 1
			// python will gc that object also automatic for us.
		}
		
		return list
	}
	
}



public func buildAstArguments(args: [PyAst_Arg], returns: PyAstObject?) throws -> PyPointer {
	let arg_list = args.pyPointer
	let dummy_args = PyList_New(0)!
	let var_arg = PythonNone!
	let kwonlyargs = PyList_New(0)!
	let kw_defaults = PythonNone!
	let kwarg = PythonNone!
	let defaults = PyList_New(0)!

	let arguments: PyPointer = try Ast.arguments(
		dummy_args,
		arg_list,
		var_arg,
		kwonlyargs,
		kw_defaults,
		kwarg,
		defaults
	)
	
	return arguments
}
