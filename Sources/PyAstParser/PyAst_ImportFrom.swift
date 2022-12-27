//
//  PyAst_ImportFrom.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
//import PythonLib
import PythonSwiftCore



public class PyAst_ImportFrom: PyAstObject {
    
    public var type: AstType = .ImportFrom
    
    public var name: String {
        ""
    }
    
    required public init(_ v: PythonSwiftCore.PythonObject) {
//        print(self)
//        v.print_dict()
    }
    
    
}
