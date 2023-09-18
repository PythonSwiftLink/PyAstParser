//
//  File.swift
//  
//
//  Created by MusicMaker on 28/12/2022.
//

import Foundation
import PythonSwiftCore

public class PyAst_Annotation: PyAstObject {
	
	
    public var description: String { id }
    
    
    public let type: AstType = .Annotation
    
    var id: String
    
    
    
    public var name: String { id }
    
    
    
    required public init(_ v: PythonObject) {
        //id = (try? .init(object: v.id.ptr ?? .PyNone)) ?? ""
        if let id_ptr = v.id.ptr, let _id = try? String(object: id_ptr) {
            id = _id
        } else {
            id = ""
        }

    }
    enum CodingKeys: CodingKey {
        case id
    }
    
    public required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
    }
	
	public var pyObject: PythonSwiftCore.PythonObject {
		fatalError()
	}
	
	public var pyPointer: PythonSwiftCore.PyPointer {
		fatalError()
	}
}
