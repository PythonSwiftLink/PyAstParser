//
//  File.swift
//  
//
//  Created by MusicMaker on 28/12/2022.
//

import Foundation
import PythonSwiftCore

public class PyAst_Annotation: PyAstObject {
    
    public let type: AstType = .Annotation
    
    var id: String
    
    
    
    public var name: String { id }
    
    
    
    required public init(_ v: PythonObject) {
        id = .init(v.id)
        //print(self)
        //v.print_dict()
    }
}
