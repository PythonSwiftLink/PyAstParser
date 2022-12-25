//
//  PyAst_Function.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonSwiftCore


class PyAst_Function: PyAstObject {
    
    var type: AstType = .FunctionDef
    
    var repr: String {
        //.init(value.__dict__.__repr__().pyObject)
        ""
    }
    var name: String
    var body: [PyAstObject] = []
    var args: [PyAst_Arg]
    var keywords: [PyAstObject] = []
    var decorator_list: [PyAstObject] = []
    
    required init(_ v: PythonObject) {
        name = .init(v.name)
        let _args = v.args
        args = _args.args.map(PyAst_Arg.init)
    }
    
    func handleArgs(args: PythonObject) {
        for element in args.args {
            let arg = PyAst_Arg(element)
            self.args.append(arg)
        }
    }
    
}
