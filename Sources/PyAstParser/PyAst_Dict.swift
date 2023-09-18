import Foundation
import PythonSwiftCore

public class PyAst_Dict: PyAstObject {
    
    public var description: String { name }
    
    public var name: String { "None" }
    
    public let type: AstType = .Dict
    
    public var keys: [PyAst_Constant]
    
    public var values: [PyAstObject] = []
    
    public required init(_ v: PythonSwiftCore.PythonObject) {
        keys = v.keys.map { .init($0) }
        values = v.values.map(handlePyAst)
    }
    
	public var pyObject: PythonSwiftCore.PythonObject {
		fatalError()
	}
	
	public var pyPointer: PythonSwiftCore.PyPointer {
		fatalError()
	}
}
