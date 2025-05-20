
import PySwiftKit
import PySerializing
import PyAst



extension AST.Module: PySerializing.PySerialize {
    
    public var pyPointer: PyPointer {
        body.insert(AST.ImportFrom(module: "typing", names: ["Optional", "Protocol", "Callable"]), at: 0)
        let py_body = body.pyList
        let result = Asts.Module(body: py_body)
        Py_DecRef(py_body)
        return result
    }
}

extension AST.ClassDef: PySerializing.PySerialize {
    
    public var pyPointer: PyPointer {
        let pybody = (body.isEmpty ? Asts.functionBody.pyPointer : body.pyList)
        let result = Asts.ClassDef(
            name: name,
            bases: bases.map({.init(id: $0.name)}),
            body: pybody
        )
        Py_DecRef(pybody)
        return result
    }
}

extension AST.FunctionDef: PySerializing.PySerialize {
    
    public var pyPointer: PyPointer {
        Asts.FunctionDef(
            name: name,
            args: args,
            returns: returns?.type.pyPointer
        )
    }
}

extension AST.Arguments: PySerializing.PySerialize {
    
    public var pyPointer: PyPointer {
        Asts.arguments(posonlyargs: args)
    }
}

extension AST.Arg: PySerializing.PySerialize {
    
    public var pyPointer: PyPointer {
        let py: PyPointer = Asts.arg(
            arg: arg,
            annotation: Expr2PyPointer(annotation) ?? PyNone
        )
        return py
    }
}

extension AST.Keyword: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        Asts.keyword(arg: arg, value: value.name)
    }
}

extension AnyExpr: PySerializing.PySerialize {
    public var pyPointer: PyPointer { Expr2PyPointer(value)! }
}

extension AST.Name: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        Asts.Name(id: id)
    }
}

extension AST.Constant: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        Asts.Constant(value: n)
    }
}

extension AST.AnnAssign: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        Asts.AnnAssign(target: .init(id: target.name), annotation: .init(id: annotation.name))
    }
}

extension AST.ImportFrom: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        Asts.ImportFrom(module: module, names: names)
    }
}

extension AST.Alias: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        Asts.alias(name: name, asname: asname)
    }
}

extension AST.Tuple: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        let py_elts = elts.compactMap { expr in
            Expr2PyPointer(expr)
        }.pyPointer
        defer { py_elts.decref() }
        return Asts.Tuple(elts: py_elts)
    }
}

extension AST.List: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        let py_elts = elts.compactMap { expr in
            Expr2PyPointer(expr)
        }.pyPointer
        defer { py_elts.decref() }
        return Asts.List(elts: py_elts)
    }
}

extension AST.Slice: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
//        let py_slice = Expr2PyPointer(slice)!
//        defer { py_slice.decref() }
        return Asts.Slice(step: .False)
    }
}

extension AST.Subscript: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        let py_slice = Expr2PyPointer(slice)!
        defer { py_slice.decref() }
        return Asts.Subscript(value: Expr2PyPointer(value)!, slice: py_slice )
    }
}


extension AST.BinOp: PySerializing.PySerialize {
    public var pyPointer: PyPointer {
        Asts.BinOp(
            left: Expr2PyPointer(left)!,
            op: Asts.BitOr(),
            right: Expr2PyPointer(right)!
        )
    }
}

//extension AST.Alias: PySerializing.PySerialize {
//    public var pyPointer: PyPointer {
//        Asts.alias(name: name, asname: asname)
//    }
//}
