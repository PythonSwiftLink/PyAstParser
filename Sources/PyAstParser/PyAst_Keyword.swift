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
        
        //arg = (try? .init(object: v.arg.ptr)) ?? "None"
        
        if let arg_ptr = v.arg.ptr, let _arg = try? String(object: arg_ptr) {
            arg = _arg
        } else {
            arg = "None"
        }
        
        value = handlePyAst(v.value)
    }
    
    
}
