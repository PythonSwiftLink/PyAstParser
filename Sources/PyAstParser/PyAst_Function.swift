//
//  PyAst_Function.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonSwiftCore
import PythonLib

public class PyAst_Function: PyAstObject {
	public init(name: String, body: [PyAstObject] = [], args: [PyAst_Arg], keywords: [PyAstObject] = [], decorator_list: [PyAstObject], returns: PyAstObject? = nil) {
		self.name = name
		self.body = body
		self.args = args
		self.keywords = keywords
		self.decorator_list = decorator_list
		self.returns = returns
		
	}
	
    
    public var description: String { name }
    
    public var type: AstType = .FunctionDef
    
    public var name: String
    public var body: [PyAstObject] = []
    public var args: [PyAst_Arg]
    public var keywords: [PyAstObject] = []
	public var defaults: [PyAstObject] = []
    public var decorator_list: [PyAstObject]
    public var returns: PyAstObject?
    
    required public init(_ v: PythonObject) {
        name = .init(object: v.name) ?? "None"
        let _args = v.args
        args = _args.args.map(PyAst_Arg.init)
        decorator_list = v.decorator_list.map(handlePyAst)
		defaults = _args.defaults.map(handlePyAst)
        returns = handlePyAst(v.returns)
    }
    
	public var pyObject: PythonSwiftCore.PythonObject {
		fatalError()
	}
	
	public var pyPointer: PythonSwiftCore.PyPointer {
		let arguments = try! buildAstArguments(args: args, returns: returns)
		let dec_list = PyList_New(0)!
		let function: PyPointer = try! Ast.FunctionDef(
			name,
			arguments,
			body.pyPointer,
			dec_list,
			(returns?.pyPointer) ?? .PyNone
		)
		
		return function
	}
    
}

