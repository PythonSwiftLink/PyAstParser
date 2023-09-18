//
//  PyAst_Module.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonSwiftCore


public class PyAst_Module: PyAstObject {
	
	
    
    public var description: String { name }
    
    public var type: AstType = .Module

    
    public var body: [PyAstObject]
    
    public var name: String {
        ""
    }
    
    required public init(_ v: PythonObject) {

        body = v.body.map(handlePyAst)
        
    }
	
	public init(body: [PyAstObject]) {
		self.body = body
	}
    
	
}

extension PyAst_Module: PyEncodable {
	public var pyObject: PythonSwiftCore.PythonObject {
		.init(getter: pyPointer)
	}
	
	public var pyPointer: PythonSwiftCore.PyPointer {
		try! Ast.Module(body.pyPointer)
	}
}
