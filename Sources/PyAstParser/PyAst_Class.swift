//
//  PyAst_Class.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
//import PythonLib
import PythonSwiftCore

public class PyAst_Class: PyAstObject {
    public var type: AstType = .ClassDef
    
    
    
    var repr: String {
        //.init(value.__dict__.__repr__().pyObject)
        ""
    }
    public var name: String
    public var body: [PyAstObject] = []
    public var bases: [PyAstObject] = []
    public var keywords: [PyAstObject] = []
    public var decorator_list: [PyAstObject] = []
    
    public required init(_ v: PythonObject) {
        name = .init(v.name)
        print(self)
        //v.print_dict()
        
        body = v.body.map(handlePyAst)
        decorator_list = v.decorator_list.map(handlePyAst)
        
        
        
    }
    
}
