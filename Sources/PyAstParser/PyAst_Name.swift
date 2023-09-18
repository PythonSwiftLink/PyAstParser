

import Foundation
import PythonSwiftCore

public class PyAst_Name: PyAstObject {
    
    public var description: String { name }
    
    public let type: AstType = .Name
    
    var id: String
    
    public var name: String { id }
    
    public required init(_ v: PythonObject) {
        
        if v.isNone {
            id = "None"
        } else {
            id = .init(object: v.id) ?? "None"
        }
    }
    
	public var pyObject: PythonSwiftCore.PythonObject {
		fatalError()
	}
	
	public var pyPointer: PythonSwiftCore.PyPointer {
		fatalError()
	}
}
