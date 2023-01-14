

import Foundation
import PythonSwiftCore

public class PyAst_Slice: PyAstObject {
    
    public let type: AstType = .Slice
    
    public var name: String {
        ""
    }
    
    required public init(_ v: PythonSwiftCore.PythonObject) {

        fatalError("\(self)")
    }
    
    
}
