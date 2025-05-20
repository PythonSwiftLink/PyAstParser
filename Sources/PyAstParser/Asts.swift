//
//  Asts.swift
//  PyAstParser
//
//  Created by CodeBuilder on 13/05/2025.
//
import Foundation
//import PythonLib
import PySwiftKit
import PySerializing
import PyCallable
import PyAst
import PySwiftWrapper

public struct Asts {

    @PyCall(gil: false) static func Module(
        body: PyPointer,
        type_ignores: [String] = []
    ) -> PyPointer
    
    @PyCall(gil: false) static func ClassDef(
        name: String,
        bases: [AST.Name] = [],
        keywords: [AST.Keyword] = [],
        body: PyPointer,
        decorator_list: [PyPointer] = []
    ) -> PyPointer
    
    @PyCall(gil: false) static func FunctionDef(
        name: String,
        args: AST.Arguments,
        body: [PyPointer] = functionBody,
        decorator_list: [PyPointer] = [],
        returns: PyPointer?
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func arguments(
        posonlyargs: [AST.Arg],
        args: [AST.Arg] = [],
        vararg: AST.Arg? = nil,
        kwonlyargs: [AST.Arg] = [],
        kw_defaults: [AST.Arg?] = [],
        kwarg: AST.Arg? = nil,
        defaults: [PyPointer] = []
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func arg(
        arg: String,
        annotation: PyPointer
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func keyword(
        arg: String?,
        value: String
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func Name(
        id: String
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func AnnAssign(
        target: AST.Name,
        annotation: AST.Name,
        value: AST.Name? = nil,
        simple: Int = 0
    ) -> PyPointer
    
    
    @PyCall(gil: false)
    static func Constant(
        value: String
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func ImportFrom(
        module: String?,
        names: [AST.Alias]
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func alias(
        name: String,
        asname: String? = nil
    ) -> PyPointer

    
    @PyCall(gil: false)
    static func Subscript(
        value: PyPointer,
        slice: PyPointer
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func Slice(
        lower: PyPointer? = nil,
        upper: PyPointer? = nil,
        step: PyPointer? = nil
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func List(
        elts: PyPointer
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func Tuple(
        elts: PyPointer
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func BinOp(
        left: PyPointer,
        op: PyPointer,
        right: PyPointer
    ) -> PyPointer
    
    @PyCall(gil: false)
    static func BitOr() -> PyPointer

}

extension Asts {
    
    static let functionBody: [PyPointer] = [PyObject_CallNoArgs(_Pass)]
    
  
    
    public static let py_cls = PyImport_ImportModule("ast")!


    public static let _FunctionDef =  PyObject_GetAttrString(py_cls, "FunctionDef")!
    public static let _ClassDef =  PyObject_GetAttrString(py_cls, "ClassDef")!

    public static let _AnnAssign =  PyObject_GetAttrString(py_cls, "AnnAssign")!
    public static let _Subscript =  PyObject_GetAttrString(py_cls, "Subscript")!

    public static let _Assign =  PyObject_GetAttrString(py_cls, "Assign")!
    public static let _Module =  PyObject_GetAttrString(py_cls, "Module")!
    public static let stmt =  PyObject_GetAttrString(py_cls, "stmt")!
    public static let _arg =  PyObject_GetAttrString(py_cls, "arg")!
    public static let _Slice =  PyObject_GetAttrString(py_cls, "Slice")!
    public static let _keyword =  PyObject_GetAttrString(py_cls, "keyword")!
    public static let _Call =  PyObject_GetAttrString(py_cls, "Call")!
    public static let _arguments =  PyObject_GetAttrString(py_cls, "arguments")!
    public static let str = PyObject_GetAttrString(py_cls, "str")!
//    public static let FunctionDef =  PyObject_GetAttrString(py_cls, "FunctionDef")
//    public static let FunctionDef =  PyObject_GetAttrString(py_cls, "FunctionDef")
//    public static let FunctionDef =  PyObject_GetAttrString(py_cls, "FunctionDef")
    public static let _ImportFrom = PyObject_GetAttrString(py_cls, "ImportFrom")!
    
    public static let _alias = PyObject_GetAttrString(py_cls, "alias")!

    public static let _Constant =  PyObject_GetAttrString(py_cls, "Constant")!

    public static let Expr =  PyObject_GetAttrString(py_cls, "Expr")!

    public static let _NamedExpr =  PyObject_GetAttrString(py_cls, "NamedExpr")!

    public static let _Name =  PyObject_GetAttrString(py_cls, "Name")!

    public static let _AugAssign =  PyObject_GetAttrString(py_cls, "AugAssign")!

    public static let _Attribute =  PyObject_GetAttrString(py_cls, "Attribute")!

    public static let _List =  PyObject_GetAttrString(py_cls, "List")!

    public static let Dict =  PyObject_GetAttrString(py_cls, "Dict")!

    public static let _Tuple =  PyObject_GetAttrString(py_cls, "Tuple")!

    public static let _BinOp =  PyObject_GetAttrString(py_cls, "BinOp")!

    public static let Add =  PyObject_GetAttrString(py_cls, "Add")!

    public static let Div =  PyObject_GetAttrString(py_cls, "Div ")!

    public static let Sub =  PyObject_GetAttrString(py_cls, "Sub")!

    public static let Mult =  PyObject_GetAttrString(py_cls, "Mult")!

    public static let FloorDiv =  PyObject_GetAttrString(py_cls, "FloorDiv")!

    public static let Mod =  PyObject_GetAttrString(py_cls, "Mod")!

    public static let Pow =  PyObject_GetAttrString(py_cls, "Pow")!

    public static let With =  PyObject_GetAttrString(py_cls, "With")!

    public static let WithItem =  PyObject_GetAttrString(py_cls, "withitem")!

    public static let Elipsis =  PyObject_GetAttrString(py_cls, "Elipsis")!

    public static let _Pass =  PyObject_GetAttrString(py_cls, "Pass")!

    
    public static let _BitOr =  PyObject_GetAttrString(py_cls, "BitOr")!
}
