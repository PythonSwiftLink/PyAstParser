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

        arg = (try? .init(object: v.id.ptr)) ?? "None"
        
        value = handlePyAst(v.value)
    }
    
    
}
