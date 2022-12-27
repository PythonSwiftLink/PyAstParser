//
//  PyAst_Call.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
//import PythonLib
import PythonSwiftCore

public class PyAst_Call: PyAstObject {
    
    public let type: AstType = .Call
    
    public var _func: PyAst_Name
    
    public var args: [PyAst_Name]
    
    public var keywords: [PyAst_Keyword]
    public var name: String { _func.id }
    
    required public init(_ v: PythonSwiftCore.PythonObject) {
        _func = .init(v.func)
        args = v.args.map({ arg in
            if arg.IsInstance(Ast.Name) {
                return .init(arg)
            }
            fatalError("Ast.Name only handled so far")
        })
        
        keywords = v.keywords.map(PyAst_Keyword.init)
        
//        print(self)
//        v.print_dict()
    }
    
    
}
