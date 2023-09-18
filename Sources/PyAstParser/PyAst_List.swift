

import Foundation
import PythonSwiftCore

public class PyAst_List: PyAstObject {
    
    public var description: String { name }
    
    public let type: AstType = .List
    
    public var elts: [PyAstObject]
    
    public var name: String { "PyAst_List: \(elts.map(\.name))" }
    
    public required init(_ v: PythonObject) {
        
        elts = v.elts.map(handlePyAst)

    }
    
	public var pyObject: PythonSwiftCore.PythonObject {
		fatalError()
	}
	
	public var pyPointer: PythonSwiftCore.PyPointer {
		fatalError()
	}
}
