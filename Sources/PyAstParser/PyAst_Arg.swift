
import Foundation
import PythonSwiftCore

public class PyAst_Arg: PyAstObject {
    
    public let type: AstType = .Arg
    
    public var name: String { arg }
    
    public var arg: String
    
    public var annotation: PyAstObject?
    
    required public init(_ v: PythonObject) {
        //print("PyAst_Arg init:")
        arg = .init( v.arg)
        
        let anno = v.annotation
        if !anno.isNone {
            //anno.print_dict()
            annotation = handlePyAst(anno)
        }
        //print(self, name)
    }
    
    
}
