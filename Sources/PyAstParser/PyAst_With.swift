

import Foundation
import PythonSwiftCore

public class PyAst_With: PyAstObject {
    
    public var description: String { name }
    
    public let type: AstType = .With
    
    public var items: [PyAstObject]
    public var body: [PyAstObject]
    
    public var name: String { items.first?.name ?? "Nil" }
    
    public required init(_ v: PythonObject) {
        
        items = v.items.map(handlePyAst)
        body = v.body.map(handlePyAst)

    }
    
    
}

public class PyAst_WithItem: PyAstObject {
    
    public var description: String { name }
    
    public let type: AstType = .WithItem
    
    public var context_expr: PyAstObject

    
    public var name: String { context_expr.name }
    
    public required init(_ v: PythonObject) {
        
        context_expr = handlePyAst(v.context_expr)
        
    }
    
    
}
