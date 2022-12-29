//
//  File.swift
//  
//
//  Created by MusicMaker on 28/12/2022.
//

import Foundation
import PythonSwiftCore
import PythonLib

public class PyAst_Constant: PyAstObject {
    
    var value: String
    
    
    public var name: String {
        value
    }
    
    public let type: AstType = .Constant
    
    public required init(_ v: PythonSwiftCore.PythonObject) {
        //print("PyAst_Constant:")
        
        //v.print_dict()
        let _value = v.value.ptr
        if PythonBool_Check(_value) {
            value = _value == PythonTrue ? "true": "false"
        } else {
            value = .init(_value) ?? "nil"
        }
        //print(value)
        //pyPrint(v.value.ptr)
        //value = "init(_value) ?? None"
        //_value.decref()
    }
    
    
    
    
}
