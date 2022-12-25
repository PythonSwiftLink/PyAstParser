//
//  PyAst_ImportFrom.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonLib
import PythonSwiftCore



class PyAst_ImportFrom: PyAstObject {
    
    var type: AstType = .ImportFrom
    
    var name: String {
        ""
    }
    
    required init(_ v: PythonSwiftCore.PythonObject) {
        print(self)
        v.print_dict()
    }
    
    
}
