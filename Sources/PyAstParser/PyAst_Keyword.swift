//
//  PyAst_Keyword.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonSwiftCore

public class PyAst_Keyword: PyAstObject {
    public var name: String { arg }
    
    public let type: AstType = .Keyword
    
    public var arg: String
    
    public var value: PyAstObject
    
    required public init(_ v: PythonSwiftCore.PythonObject) {
        //v.print_dict()
        arg = .init(v.arg)
        
        value = PyAst_Name(v.value)
    }
    
    
}
