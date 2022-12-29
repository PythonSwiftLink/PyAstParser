
import Foundation
import PythonSwiftCore

public class PyAst_Expression: PyAstObject {
    
    public let type: AstType = .Expr
    
    public var name: String { value.name }
    
    public var value: PyAst_Constant
    
    required public init(_ v: PythonObject) {
        
        //print(self)
        //v.print_dict()
        value = .init(v.value)
        //fatalError("\(self)")
        //v.print_dict()
    }
}
