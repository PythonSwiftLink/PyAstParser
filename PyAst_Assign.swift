//
//  PyAst_Assign.swift
//  PythonSwiftLink
//
//  Created by MusicMaker on 25/12/2022.
//  Copyright © 2022 Example Corporation. All rights reserved.
//

import Foundation
import PythonLib
import PythonSwiftCore


public class PyAst_Assign: PyAstObject {
    
    public let type: AstType = .Assign
    
    public var name: String {targets.first?.name ?? "nil"}
    
    var targets: [PyAstObject]
    
    var value: PyAstObject?
    
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
            let astname = PyAst_Name(obj)
            fatalError()
        case let obj where obj.IsInstance(Ast.Call):
            print("Handling Ast.Call")
            let call = PyAst_Call(obj)
            value = PyAst_Call(obj)
            print("handled Ast.Call")
            //fatalError()
        case let obj where obj.IsInstance(Ast.Expr):
            fatalError()
        case let obj where obj.IsInstance(Ast.Subscript):
            //let _subscript = PyAst_Subscript(obj)
            fatalError()
        default:
            v.value.print_dict()
            fatalError()
        }
        
        print(self)
        //v.print_dict()
        
        
    }
    
    
}
