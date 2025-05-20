import Foundation
import PyCodable
import PySwiftKit
import PyAst
import SwiftSyntax
import SwiftParser
import ArgumentParser
import PathKit
import PyCallable
import PySerializing

@main
struct PyAstParser: AsyncParsableCommand {
    
    static var configuration: CommandConfiguration = .init(
        version: "0.0.1 ",
        subcommands: [
            Dump.self,
            //VenvDump.self
        ],
        defaultSubcommand: Dump.self
    )
    
    static func launchPython() throws {
        let python = PythonHandler.shared
        //try PythonFiles.checkModule()
        if !python.defaultRunning {
            python.start(
                stdlib: "/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11",
                app_packages: [
                    //PythonFiles.py_modules
                ],
                debug: true
            )
        }
    }
}

func toml_file(name: String) -> String {
    """
    [project]
    name = "\(name)"
    version = "0.1.0"
    description = "Add your description here"
      
    requires-python = ">=3.11"
    dependencies = []
    """
}

extension PyAstParser {
    struct Dump: AsyncParsableCommand {
        
        @Argument var files: [Path]
        @Option var output: Path?
        
        func run() async throws {
            guard let output else { return }
            try launchPython()
            //let file = input
            let decls = files.declSyntax()
            
            let py_classes = decls.compactMap { decl in
                switch decl.as(DeclSyntaxEnum.self) {
                case .classDecl(let classDecl):
                    classDecl
                default: nil
                }
            }
            
            let py_modules = decls.compactMap { decl in
                switch decl.as(DeclSyntaxEnum.self) {
                case .structDecl(let structDecl):
                    structDecl
                default: nil
                }
            }
            
            
            
            
            for py_module in py_modules {
                var included_classes: [ClassDeclSyntax] = []
                for member in py_module.memberBlock.members {
                    switch member.decl.as(DeclSyntaxEnum.self) {
                    case .variableDecl(let variableDecl):
                        if let binding = variableDecl.bindings.first {
                            switch binding.initializer?.value.as(ExprSyntaxEnum.self) {
                            case .arrayExpr(let arrayExpr):
                                switch binding.pattern.as(PatternSyntaxEnum.self) {
                                case .expressionPattern(let expressionPattern):
                                    break
                                case .identifierPattern(let identifierPattern):
                                    if identifierPattern.identifier.trimmed.text == "py_classes" {
                                        let classes = arrayExpr.elements.compactMap { element in
                                           switch element.expression.as(ExprSyntaxEnum.self) {
                                           case .memberAccessExpr(let memberAccessExpr):
                                               switch memberAccessExpr.base?.as(ExprSyntaxEnum.self) {
                                               case .declReferenceExpr(let declReferenceExpr):
                                                   return py_classes.first { cls in
                                                       cls.name.trimmedDescription == declReferenceExpr.baseName.text
                                                   }
                                               default: return nil
                                               }
                                           default: return nil
                                            }
                                        }
                                        included_classes.append(contentsOf: classes)
                                    }
                                default: break
                                }
                            default: break
                            }
                        }
                    
                    default: break
                    }
                }
                
                let ast_module = AST.Module(syntax: py_module, classes: included_classes)
                let py_code = try Decompiler().decompile(ast: ast_module)
                let module_name = py_module.name.text.camelCaseToSnakeCase()
                let dest = (output + "\(module_name).py")
                print("PyAstParser:",dest)
                try dest.write(py_code, encoding: .utf8)
                let toml = output + "../pyproject.toml"
                try toml.write(toml_file(name: module_name), encoding: .utf8)
            }
           
        }
    }
}

extension Path: ArgumentParser.ExpressibleByArgument {
    public init?(argument: String) {
        self = .init(argument)
    }
}


let ast_parser = PyImport(from: "ast", import_name: "parser")

func astParse(_ string: String) -> PyPointer {
    var string = string
    let str: PyPointer = string.withUTF8 { utf8 in
        PyUnicode_FromKindAndData(1, utf8.baseAddress, utf8.count)
    }
    defer { str.decref() }
    if let result = PyObject_CallOneArg(ast_parser, str) {
        return result
    }
    PyErr_Print()
    fatalError()
}

public extension AST {
    static func parseFile(url: URL) throws -> Module {
        let decoder = PyDecoder()
        let ast_object = astParse(try .init(contentsOf: url))
        return try decoder.decode(Module.self, from: ast_object)
    }
    static func parseString(_ string: String) throws -> Module {
        let decoder = PyDecoder()
        let ast_object = astParse(string)
        return try decoder.decode(Module.self, from: ast_object)
    }
}

public extension SwiftSyntax.SourceFileSyntax {
    func py_module() -> AST.Module {
        .init(syntax: self)
    }
    
    func classes() -> [AST.ClassDef] {
        py_module().body.compactMap { stmt -> AST.ClassDef? in
            switch stmt.type {
            case .ClassDef:
                stmt as? AST.ClassDef
            default:
                nil
            }
        }
    }
    
    func asPyFile() throws -> String {
        let ast = py_module()
        
        let py_code = try Decompiler().decompile(ast: ast)
        
        
        return py_code.replacingOccurrences(of: ", /)", with: ")")
    }
}

extension PathKit.Path {
    var fileSyntax: SourceFileSyntax? {
        guard exists, self.extension == "swift" else { return nil }
        return Parser.parse(source: try! read())
    }
}

public extension Array where Element == PathKit.Path {
    
    func statements() -> [CodeBlockItemSyntax.Item] {
        lazy.compactMap(\.fileSyntax).compactMap({ file -> [CodeBlockItemSyntax.Item] in
            file.statements.map(\.item)
        }).flatMap(\.self)
    }
    
    func declSyntax() -> [DeclSyntax] {
        statements().compactMap { member in
            switch member {
            case .decl(let declSyntax):
                switch declSyntax.as(DeclSyntaxEnum.self) {
                case .classDecl(let classDecl):
                    if classDecl.attributes.contains(where: {["@PyClass", "@PyClassByExtension"].contains($0.trimmedDescription)})
                    {
                        return .init(classDecl)
                    }
                case .structDecl(let structDecl):
                    if structDecl.attributes.contains(where: {$0.trimmedDescription == "@PyModule"})
                    {
                        return .init(structDecl)
                    }
                default: break
                }
            case .stmt(let stmtSyntax):
                break
            case .expr(let exprSyntax):
                break
            }
            return nil
        }
    }
    func py_modules() throws -> [(String, String)] {
        
        let statements = statements()
        
        let module_structs = statements.compactMap { item in
            switch item.kind {
            case .structDecl:
                if
                    let structDecl = item.as(StructDeclSyntax.self),
                    structDecl.attributes.contains(where: {$0.trimmedDescription == "@PyModule"})
                {
                    return structDecl
                }
                return nil
            default: return nil
            }
        }
        
        let pyclassDecls = statements.compactMap { item in
            switch item.kind {
            case .classDecl:
                if
                    let classDecl = item.as(ClassDeclSyntax.self),
                    classDecl.attributes.contains(where: {["@PyClass", "@PyClassByExtension"].contains($0.trimmedDescription)})
                {
                    return classDecl
                }
                return nil
            default: return nil
            }
        }
        
        return try lazy.compactMap(\.fileSyntax).compactMap { file in
            let is_pymodule = file.statements.contains { blockitem in
                let item = blockitem.item
                switch item.kind {
                case .structDecl:
                    return item.as(StructDeclSyntax.self)!.attributes.contains(where: {$0.trimmedDescription == "@PyModule"})
                default: return false
                }
            }
            if is_pymodule {
                let ast = file.py_module()
                let py_code = try Decompiler().decompile(ast: ast).replacingOccurrences(of: ", /)", with: ")")
                return (ast.name, py_code)
            }
            
            return nil
        }
    }
}

public class Decompiler {
    
    init() {
        let g = PyDict_New()!
        PyRun_String(
            py_decompiler,
            Py_file_input,
            g,
            g
        )
        module = g
        _decompile = PyDict_GetItemString(module, "decompile")!
    }
    private let module: PyPointer
    private let _decompile: PyPointer
    public static let shared = Decompiler()
//    ? = {
//        return PyDict_GetItemString(module, "decompile")!
//    }()
    
    
    public func decompile(ast: PySerialize) throws -> String {
        try PythonCallWithGil(call: _decompile, ast)
    }
    deinit {
        module.decref()
        _decompile.decref()
    }
}
