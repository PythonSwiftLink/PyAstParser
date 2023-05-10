//
//  PyAst_Assign.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
//import PythonLib
import PythonSwiftCore


public class PyAst_Assign: PyAstObject {
    public var description: String { name }
    
    
    public let type: AstType = .Assign
    
    public var name: String {targets.first?.name ?? "nil"}
    
    public var targets: [PyAstObject]
    
    public var value: PyAstObject?
    
    required public init(_ v: PythonSwiftCore.PythonObject) {
        
        targets = v.targets.map({ element in
            switch element {
            case let obj where obj.IsInstance(Ast.Name):
                return PyAst_Name(obj)
            default: fatalError("PyAst_Assign targets -  element cant be handled")
            }
        })
        
        switch v.value {
        case let obj where obj.IsInstance(Ast.Name):
            value = PyAst_Name(obj)
        case let obj where obj.IsInstance(Ast.Call):
            value = PyAst_Call(obj)
        case let obj where obj.IsInstance(Ast.Expr):
            value = PyAst_Expression(obj)
        case let obj where obj.IsInstance(Ast.Subscript):
            value = PyAst_Subscript(obj)
        default:
            v.value.print_dict()
            fatalError()
        }
        
        //print(self)
        //v.print_dict()
        
        
    }
    
    
}
