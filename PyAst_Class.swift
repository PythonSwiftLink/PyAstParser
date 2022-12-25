//
//  PyAst_Class.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonLib
import PythonSwiftCore

class PyAst_Class: PyAstObject {
    var type: AstType = .ClassDef
    
    
    
    var repr: String {
        //.init(value.__dict__.__repr__().pyObject)
        ""
    }
    var name: String
    var body: [PyAstObject] = []
    var bases: [PyAstObject] = []
    var keywords: [PyAstObject] = []
    var decorator_list: [PyAstObject] = []
    
    required init(_ v: PythonObject) {
        name = .init(v.name)
        print(self)
        //v.print_dict()
        
        body = v.body.map(handlePyAst)
        decorator_list = v.decorator_list.map(handlePyAst)
        
        
        
    }
    
}
