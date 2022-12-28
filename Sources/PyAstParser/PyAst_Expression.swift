
import Foundation
import PythonSwiftCore

public class PyAst_Expression: PyAstObject {
    
    public let type: AstType = .Expr
    
    public var name = ""
    
    required public init(_ v: PythonObject) {
        
        //print(self)
        fatalError("\(self)")
        //v.print_dict()
    }
}
