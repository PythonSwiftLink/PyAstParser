//
//  PyAst_Call.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonLib
import PythonSwiftCore

class PyAst_Call: PyAstObject {
    
    let type: AstType = .Call
    
    var _func: PyAst_Name
    
    var args: [PyAst_Name]
    
    
    var name: String { "" }
    
    required init(_ v: PythonSwiftCore.PythonObject) {
        _func = .init(v.func)
        args = v.args.map({ arg in
            if arg.IsInstance(Ast.Name) {
                return .init(arg)
            }
            fatalError()
        })
        print(self)
        //v.print_dict()
    }
    
    
}
