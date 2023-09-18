
import Foundation
import PythonSwiftCore

public class PyAst_Expression: PyAstObject {
    
    public var description: String { name }
    
    public let type: AstType = .Expr
    
    public var name: String { value.name }
    
    public var value: PyAst_Constant
    
    required public init(_ v: PythonObject) {

        value = .init(v.value)

    }
	
	public var pyObject: PythonSwiftCore.PythonObject {
		fatalError()
	}
	
	public var pyPointer: PythonSwiftCore.PyPointer {
		fatalError()
	}
}
