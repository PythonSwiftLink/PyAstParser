

import Foundation
import PythonSwiftCore

public class PyAst_Name: PyAstObject {
    
    public let type: AstType = .Name
    
    var id: String
    
    public var name: String { id }
    
    public required init(_ v: PythonObject) {
        
        if v.isNone {
            id = "void"
        } else {
            id = .init(object: v.id) ?? "None"
        }
    }
    
    
}
