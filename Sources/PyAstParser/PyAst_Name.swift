

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
            let _id = v.id
            id = _id.isNone ? "None": String(_id)
        }
    }
    
    
}
