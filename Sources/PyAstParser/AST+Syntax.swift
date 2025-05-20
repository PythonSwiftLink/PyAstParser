import Foundation
import PyAst
import SwiftSyntax
import SwiftParser
//import PythonLib
import PySwiftKit

func handleSyntaxChildren(child: MemberBlockItemSyntax) -> Stmt? {
  
    let decl = child.decl
    switch decl.as(DeclSyntaxEnum.self) {
    
    case .classDecl(let classDeclSyntax):
        break
    case .extensionDecl(let extensionDeclSyntax):
        break
    case .functionDecl(let f):
        if f.attributes.contains(where: { ["@PyMethod", "@PyFunction"].contains($0.trimmedDescription) }) {
            return AST.FunctionDef(syntax: f)
        }
    case .structDecl(let structDeclSyntax):
        break
    case .variableDecl(let varDecl):
        if varDecl.attributes.contains(where: {$0.trimmedDescription == "@PyProperty"}) {
            return AST.AnnAssign(syntax: varDecl)
        }
    default: break
    }
    return nil

}

public extension AST.Module {
    
    convenience init(syntax: StructDeclSyntax, classes: [ClassDeclSyntax] = []) {
        let functions = syntax.memberBlock.members.compactMap { member -> FunctionDeclSyntax? in
            switch member.decl.as(DeclSyntaxEnum.self) {
            case .functionDecl(let funcDecl):
                guard funcDecl.attributes.contains(where: { $0.trimmedDescription == "@PyFunction" }) else { return nil }
                return funcDecl
            default: return nil
            }
        }.map(AST.FunctionDef.init)
        
        self.init(body: classes.map(AST.ClassDef.init) + functions)
    }
    
    convenience init(syntax: SwiftSyntax.SourceFileSyntax) {
        let body: [Stmt] = syntax.statements.compactMap { codeitem in
            switch codeitem.item {
            case .decl(let decl):
                switch decl.as(DeclSyntaxEnum.self) {
                case .classDecl(let cls):
                    if cls.attributes.contains(where: { $0.trimmedDescription == "@PyClass" }) {
                        return AST.ClassDef(syntax: cls)
                    }
                case .structDecl(let structDecl):
                    if structDecl.attributes.contains(where: { $0.trimmedDescription == "@PyModule" }) {
                        
                    }
                default: break
                }
            default: break
            }
            
            return nil
        }
        self.init(body: body)
        self.name = ""
    }
}

public extension AST.AnnAssign {
    init(syntax: VariableDeclSyntax) {
        let pattern = syntax.bindings.first!
        let anno_ast = if let t = pattern.typeAnnotation?.type {
            syntaxToSwiftTypes(syntax: t).ast_name
        } else {
            AST.Name(id: "object")
        }
        self.init(
            target: AST.Name(id: pattern.pattern.trimmedDescription),
            annotation: anno_ast,
            simple: 0,
            lineno: -1,
            col_offset: -1
        )
    }
}

public extension AST.ClassDef {
    init(syntax: ClassDeclSyntax) {
        let name = syntax.name.trimmedDescription
        var bases: [AST.Name] = []
        if syntax.attributes.contains(where: {$0.trimmedDescription == "@PyCallback"}) {
            bases.append(.init(id: "Protocol"))
        }
        self.init(
            name: name,
            bases: bases,
            keywords: [],
            body: syntax.memberBlock.members.compactMap(handleSyntaxChildren),
            decorator_list: [],
            lineno: 0,
            col_offset: 0
        )
    }
}

extension AST.Arg {
    init(syntax: FunctionParameterListSyntax.Element) {
        let name = syntax.secondName ?? syntax.firstName
        self.init(
            arg: name.trimmedDescription,
            annotation: syntaxToSwiftTypes(syntax: syntax.type).asAst
        )
    }
}

public extension AST.Arguments {
    init(syntax: [FunctionParameterSyntax], no_self: Bool) {
        var ast_args: [AST.Arg] = []
        
        if !no_self {
            ast_args.append(AST.Arg(label: "self"))
        }
        ast_args.append(contentsOf: syntax.map(AST.Arg.init))
        
        self.init(
            args: ast_args,
            kwonlyargs: [],
            kw_defaults: [],
            defaults: []
        )
    }
}

public extension AST.FunctionDef {
    
    init(syntax: FunctionDeclSyntax) {
        let is_static = syntax.modifiers.contains { mod in
            mod.name.text == "static"
        }
       self.init(
            name: syntax.name.text,
            args: .init(syntax: .init(syntax.signature.parameterClause.parameters), no_self: is_static),
            body: [AST.Pass()],
            decorator_list: [],
            returns: nil,
            lineno: 0,
            col_offset: 0
        )
    }
}

public extension AST.Tuple {
    init(syntax: [TupleTypeElementSyntax]) {
        
        let elts: [any ExprProtocol] = syntax.map { t in
            switch t.type.as(TypeSyntaxEnum.self) {
            case .attributedType(let attrType):
                switch attrType.baseType.as(TypeSyntaxEnum.self) {
                case .functionType(let functionType):
                    return AST.Subscript(syntax: functionType)
                default: break
                }
            case .functionType(let functionType):
                return AST.Subscript(syntax: functionType)
            default: break
            }
            return syntaxToSwiftTypes(syntax: t.type).ast_name
        }
        
        self = .init(elts: elts)
    }
}



public extension AST.Subscript {
    init(syntax: FunctionTypeSyntax) {
        let slice = AST.Tuple(elts: [
            AST.List(elts: syntax.parameters.map {
                syntaxToSwiftTypes(syntax: $0.type).asAst
            }),
            AST.Name(id: "None")
        ])
        self = .init(value: AST.Name(id: "Callable"), slice: slice)
    }
    
    init(syntax: DictionaryTypeSyntax) {
        let slice = AST.Tuple(elts: [
            syntaxToSwiftTypes(syntax: syntax.key).asAst,
            syntaxToSwiftTypes(syntax: syntax.value).asAst
        ])
        self = .init(value: AST.Name(id: "dict"), slice: slice)
    }
}

extension AST.BinOp {
    init(syntax: OptionalTypeSyntax) {
        self.init(
            left: syntaxToSwiftTypes(syntax: syntax.wrappedType).asAst,
            op: AST.Operator.BitOr(),
            right: AST.Name(id: "None")
        )
    }
}
