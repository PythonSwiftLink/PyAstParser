
import Foundation
import PythonSwiftCore

public class PyAst_Arg: PyAstObject {
	public init(arg: String, annotation: PyAstObject? = nil) {
		self.arg = arg
		self.annotation = annotation
	}
	
    public var description: String { arg }
    
    
    public let type: AstType = .Arg
    
    public var name: String { arg }
    
    public var arg: String
    
    public var annotation: PyAstObject?
    
    required public init(_ v: PythonObject) {
        arg = .init(object: v.arg) ?? "None"
        
        let anno = v.annotation
        if !anno.isNone {
            annotation = handlePyAst(anno)
        }
    }
    
    enum CodingKeys: CodingKey {
            case id
        }

	public var pyObject: PythonSwiftCore.PythonObject {
		fatalError()
	}
	
	public var pyPointer: PythonSwiftCore.PyPointer {
		"\(name): \(annotation?.name ?? "object")".pyPointer
	}
}
