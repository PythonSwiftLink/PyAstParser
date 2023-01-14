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
    
    
    public var type: AstType = .Module

    
    public var body: [PyAstObject]
    
    public var name: String {
        ""
    }
    
    required public init(_ v: PythonObject) {

        body = v.body.map(handlePyAst)
        
    }
    
}
