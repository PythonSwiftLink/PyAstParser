
import Foundation
import PythonSwiftCore


public class PyAst_Subscript: PyAstObject {
    
    public let type: AstType = .Subscript
    
    public var name: String {
        value.name
    }
    
    public var value: PyAstObject
    
    public var slice: PyAstObject
    
    required public init(_ v: PythonSwiftCore.PythonObject) {
        
        
        
        switch v.value {
        case let obj where obj.IsInstance(Ast.Name):
            value = PyAst_Name(obj)
        default:
            v.value.print_dict()
            fatalError()
        }
        
        switch v.slice {
        case let obj where obj.IsInstance(Ast.Name):
            slice = PyAst_Name(obj)
        default:
            v.slice.print_dict()
            fatalError()
        }
        
        //
        //        print(self)
        //        //v.print_dict()
        //        print(value.name)
        
    }
    
    
}
