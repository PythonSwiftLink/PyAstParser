//
//  PyAst_Module.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonSwiftCore


class PyAst_Module: PyAstObject {
    
    
    var type: AstType = .Module
    
    var repr: String {
        ""
    }
    
    var body: [PyAstObject]
    
    var name: String {
        ""
    }
    
    required init(_ v: PythonObject) {
        body = []
        print( self )
        v.print_dict()
        body = v.body.map(handlePyAst)
        
        
        //fatalError("module done")
    }
    
}
