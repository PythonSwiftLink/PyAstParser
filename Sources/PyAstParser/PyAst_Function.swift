//
//  PyAst_Function.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonSwiftCore


public class PyAst_Function: PyAstObject {
    
    public var type: AstType = .FunctionDef
    
    public var name: String
    public var body: [PyAstObject] = []
    public var args: [PyAst_Arg]
    public var keywords: [PyAstObject] = []
    public var decorator_list: [PyAstObject]
    public var returns: PyAst_Name?
    
    required public init(_ v: PythonObject) {
//        print("PyAst_Function dict:")
//        v.print_dict()
        name = .init(v.name)
        let _args = v.args
        args = _args.args.map(PyAst_Arg.init)
        decorator_list = v.decorator_list.map(handlePyAst)
        
        //print(decorator_list)
        
        
        returns = .init(v.returns)
    }
    
    
}
