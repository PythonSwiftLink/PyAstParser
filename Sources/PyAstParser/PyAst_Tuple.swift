

import Foundation
import PythonSwiftCore

public class PyAst_Tuple: PyAstObject {
    
    public let type: AstType = .Tuple
    
    public var elts: [PyAstObject]
    
    public var name: String { fatalError() }
    
    public required init(_ v: PythonObject) {
        
        elts = v.elts.map(handlePyAst)

    }
    
    
}
