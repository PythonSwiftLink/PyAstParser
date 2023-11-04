//
//  PyAst_Class.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
////import PythonLib
import PythonSwiftCore

public class PyAst_Class: PyAstObject {
	
	
    public var description: String { name }
    
    public var type: AstType = .ClassDef
    
    
    
    var repr: String {
        //.init(value.__dict__.__repr__().pyObject)
        ""
    }
    public var name: String
    public var body: [PyAstObject]
    public var bases: [PyAstObject] = []
    public var keywords: [PyAstObject] = []
    public var decorator_list: [PyAstObject]
    
    public required init(_ v: PythonObject) {
        name = .init(object: v.name) ?? "None"

        body = v.body.map(handlePyAst)
        decorator_list = v.decorator_list.map(handlePyAst)
        bases = v.bases.map(handlePyAst)
        
    }
    
	public init(name: String, body: [PyAstObject], bases: [PyAstObject] = [], keywords: [PyAstObject] = [], decorator_list: [PyAstObject]) {
		self.name = name
		self.body = body
		self.bases = bases
		self.keywords = keywords
		self.decorator_list = decorator_list
	}
	
	public var pyObject: PythonSwiftCore.PythonObject {
		.init(getter: pyPointer)
	}
	
	public var pyPointer: PythonSwiftCore.PyPointer {
		
//	name: _Identifier
//	bases: list[expr]
//	keywords: list[keyword]
//	body: list[stmt]
//	decorator_list: list[expr]
		
		
		
		let cls: PyPointer = try! Ast.ClassDef(
			name.pyPointer.xINCREF,
			bases.pyPointer,
			keywords.pyPointer,
			body.pyPointer,
			decorator_list.pyPointer
		)
		
		return cls
	}
}
