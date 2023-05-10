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
    
    public var description: String { name }
    
    var value: String
    
    
    public var name: String {
        value
    }
    
    public let type: AstType = .Constant
    
    public required init(_ v: PythonSwiftCore.PythonObject) {
        
        let _value = v.value.ptr
        
        switch _value {
            
        case let _bool where PythonBool_Check(_value):
            value = _bool == PythonTrue ? "true": "false"
        case let _str where PythonUnicode_Check(_value):
            value = _str!.string
        case let _none where _none == PythonNone:
            value = "None"
        default:
            value = "nil"
        }
        
    }
    
    
    
    
}
