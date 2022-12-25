//
//  PyAstHandler.swift
//  touchBay editor
//
//  Created by MusicMaker on 11/09/2022.
//

import Foundation
import PythonLib
import PythonSwiftCore



public enum AstType {
    case ImportFrom
    case Module
    case FunctionDef
    case ClassDef
    case Call
    case Slice
    case Subscript
    
    case Annotation
    case Expr
    case Keyword
    case Constant
    
    case Name
    case Assign
    case AnnAssign
    
    
    case Arg
    
    
    
}

class Ast {
    
    static let shared = Ast()
    
    static let py_cls = PyImport_ImportModule("ast")
    
    
    static let FunctionDef =  PyObject_GetAttrString(py_cls, "FunctionDef")
    static let ClassDef =  PyObject_GetAttrString(py_cls, "ClassDef")
    
    static let AnnAssign =  PyObject_GetAttrString(py_cls, "AnnAssign")
    static let Subscript =  PyObject_GetAttrString(py_cls, "Subscript")
    
    static let Assign =  PyObject_GetAttrString(py_cls, "Assign")
    static let Module =  PyObject_GetAttrString(py_cls, "Module")
    static let stmt =  PyObject_GetAttrString(py_cls, "stmt")
    static let arg =  PyObject_GetAttrString(py_cls, "arg")
    static let Slice =  PyObject_GetAttrString(py_cls, "Slice")
    static let keyword =  PyObject_GetAttrString(py_cls, "keyword")
    static let Call =  PyObject_GetAttrString(py_cls, "Call")
    static let arguments =  PyObject_GetAttrString(py_cls, "arguments")
    static let str = PyObject_GetAttrString(py_cls, "str")
//    static let FunctionDef =  PyObject_GetAttrString(py_cls, "FunctionDef")
//    static let FunctionDef =  PyObject_GetAttrString(py_cls, "FunctionDef")
//    static let FunctionDef =  PyObject_GetAttrString(py_cls, "FunctionDef")
    static let ImportFrom = PyObject_GetAttr(py_cls, "ImportFrom")
    
    static let Constant =  PyObject_GetAttrString(py_cls, "Constant")
    
    static let Expr =  PyObject_GetAttrString(py_cls, "Expr")
    
    static let NamedExpr =  PyObject_GetAttrString(py_cls, "NamedExpr")
    
    static let Name =  PyObject_GetAttrString(py_cls, "Name")
    
    static let AugAssign =  PyObject_GetAttrString(py_cls, "AugAssign")
    
    static let Attribute =  PyObject_GetAttrString(py_cls, "Attribute")
    
    static let List =  PyObject_GetAttrString(py_cls, "List")
    
    static let Tuple =  PyObject_GetAttrString(py_cls, "Tuple")
    
    static let BinOp =  PyObject_GetAttrString(py_cls, "BinOp")
    
    static let Add =  PyObject_GetAttrString(py_cls, "Add")
    
    static let Div =  PyObject_GetAttrString(py_cls, "Div ")
    
    static let Sub =  PyObject_GetAttrString(py_cls, "Sub")
    
    static let Mult =  PyObject_GetAttrString(py_cls, "Mult")
    
    static let FloorDiv =  PyObject_GetAttrString(py_cls, "FloorDiv")
    
    static let Mod =  PyObject_GetAttrString(py_cls, "Mod")
    
    static let Pow =  PyObject_GetAttrString(py_cls, "Pow")
    
    
    init() {
        
    }
    
    
    
}


class AstHandler {
    
    var wrap_module: WrapModule?
    
    var currentClass: WrapClass?
    
    init() {
        //self.wrap_module = .init(filename: "")
    }
    
    
    func parse(filename: String, string: String, completion: @escaping () throws -> Void) async throws {
        
        //Task {
            wrap_module = .init(filename: filename)
            let pyString = string.pyStringUTF8
            guard let _parsed: PythonPointerU = Ast.py_cls(method: "parse", args: [pyString]) else { PyErr_Print(); pyString.decref(); return }
            let parsed = PythonObject(ptr: _parsed)
            await handleModule(parsed)
            
//            print("####################################################################################### \n")
//            print(wrap_module!.pyswift_code)
//            print("####################################################################################### \n")
            try completion()
        //}
    }
    
    
    func handleChildren(_ item: PythonObject) async {
        switch item {
            
        case let obj where obj.IsInstance(Ast.Module):
            await handleModule(obj)
        case let obj where obj.IsInstance(Ast.ClassDef):
            await handleClass(obj)
        case let obj where obj.IsInstance(Ast.FunctionDef):
            await handleFunction(obj)
        case let obj where obj.IsInstance(Ast.Constant):
            break
        case let obj where obj.IsInstance(Ast.Name):
            fatalError()
        case let obj where obj.IsInstance(Ast.Expr):
            fatalError()
        case let obj where obj.IsInstance(Ast.Assign):
            fatalError()
        case let obj where obj.IsInstance(Ast.AnnAssign):
            fatalError()
        
        default:
            break
        }
    }
    
    func handleClassChildren(_ item: PythonObject, cls: WrapClass, callback: Bool = false) async {
            switch item {
                
            case let obj where obj.IsInstance(Ast.ClassDef):
                await handleClass(obj)
                //print("handleClassChildren", "found ClassDef")
            case let obj where obj.IsInstance(Ast.FunctionDef):
                await handleClassFunction(obj, cls: cls, callback: callback)
            case let obj where obj.IsInstance(Ast.Constant):
                fatalError()
            case let obj where obj.IsInstance(Ast.Assign):
                await handleClassAssign(obj, wrap_cls: cls)
            case let obj where obj.IsInstance(Ast.AnnAssign):
                fatalError()
            case let obj where obj.IsInstance(Ast.Expr):
                break
            case let obj where obj.IsInstance(Ast.Expr):
                break
            
            default:
                break
            }
        }
    
    func handleModule(_ mod: PythonObject) async {
        
        _ = PyAst_Module(mod)
        return
        
        let parsed_body: PythonObject = mod.body
        mod.print_dict()
        
        guard !parsed_body.ptr.isNone else { return }
        let body_array: [PythonObject] = parsed_body.array()
        
        
        
        for item in body_array {
            await handleChildren(item)
        }
    }
    
    func handleClass(_ cls: PythonObject) async {
        //print("handleClass")
        let name: String = cls.name.ptr.string!
        let decorator_list: [PythonObject] = cls.decorator_list.ptr.array()
        let wrapper_keys = await handleClassDecorators(decorator_list)
//        guard wrapper_keys.contains("wrapper") else {return}
        
        
        if name == "Callbacks" {
            if let currentClass = currentClass {
                await handleCallbackClass(cls, currentClass)
            }
            
        } else {
            if wrapper_keys.contains("wrapper") {
                await handleWrapperClass(name, cls, decorator_list)
            }
        }
    }
    
    func handleClassAssign(_ test: PythonObject, wrap_cls: WrapClass) async {
        //print("handleClassAssign:")
        
        
        
        //test.print_dict()
        let value = test.value
        
        var t: String
        var name = ""
        if let target = test.targets.array().first {
            name = target.id.string!
        }
        switch value {
        case let obj where obj.IsInstance(Ast.Call):
            //value.print_dict()
            t = await handleName(value.func)
            await handleClassProperties(t, name: name, obj: obj, cls: wrap_cls)
            
        default:
            t = ""
        }
        //print(t)
        //value.print_dict()
        //pyPrint(value.ptr)
        
        
    }
    
    func handleClassProperties(_ t: String,name: String, obj: PythonObject , cls: WrapClass, anno: Bool = false) async {
        switch t {
        case "Property":
            
            var setter = true
            var prop_type: ClassPropertyType = .GetSet
            
            let kw = obj.keywords
            //print("for key in kw:")
            for key in kw {
                //key.print_dict()
                let k = key.arg.string!
                let v = key.value.value
                if v.ptr == .True || v.ptr == .False {
                    setter = v.ptr.bool
                }
                //print(v.ptr == .True)
            }
            
            let arg: WrapArg
            if anno {
                arg = WrapArg(name: "", type: .object, other_type: "", idx: 0, arg_options: [])
            } else {
                
                arg = WrapArg(name: "", type: .object, other_type: "", idx: 0, arg_options: [])
            }
            
            prop_type = setter ? .GetSet : .Getter
            
            cls.properties.append(
                .init(name: name, property_type: prop_type, arg_type: arg)
            )
        default:
            return
        }
    }
    
    func handleWrapperClass(_ name: String,_ cls: PythonObject, _ decorator_list: [PythonObject] ) async {
        
        
        let wrap_cls = WrapClass(name)
        wrap_module?.classes.append(wrap_cls)
        currentClass = wrap_cls
        let body: PythonObject = cls.body
        //cls.print_dict()
        //let __dict__ = body.__dict__.ptr
        let body_array: [PythonObject] = body.array()
        for child in body_array {
            await handleClassChildren(child, cls: wrap_cls)
        }
        wrap_cls.callbacks_count = wrap_cls.functions.filter{$0.options.contains(.callback)}.count
        for f in wrap_cls.functions {
            f.wrap_class = wrap_cls
        }
    }
    
    func handleCallbackClass(_ cls: PythonObject, _ wrap_cls: WrapClass) async {
        let body: PythonObject = cls.body
        //cls.print_dict()
        //let __dict__ = body.__dict__.ptr
        let body_array: [PythonObject] = body.array()
        for child in body_array {
            await handleClassChildren(child, cls: wrap_cls, callback: true)
        }
    }
    
    func handleClassDecorators(_ decs: [PythonObject] ) async -> [String] {
        //print("handleClassDecorators")
        var output = [String]()
        for dec in decs {
            //dec.print_dict()
            
            switch dec {
            case let o where o.IsInstance(Ast.Name):
                //print("dec is Ast.Name")
                output.append( await handleName(o) )
            case let o where o.IsInstance(Ast.Call):
                output.append( await handleDecoCall(o) )
            default: continue
            }
        }
        return output
    }
    
    func handleDecoCall(_ o: PythonObject) async -> String {
        //print("dec is callable")
        //o.print_dict()
        let keys: [PythonObject] = o.keywords.ptr.array()
        return await handleName(o.func)
    }
    
    func handleFunction(_ _func: PythonObject) async {
        //print("handleFunction")
        //_func.print_dict()
        let name: String = _func.name.ptr.string!
        
        
        
        let f = WrapFunction(name: name, args: [], rtn: nil, options: [])
        await handleArguments(_func.args, f: f)
        
    
        wrap_module?.functions.append(f)
    }
    
    func getKeyType(f: PythonObject) async -> PythonType {
        var key: PythonType = .object
        for arg in f.args.args {
            switch arg.arg {
            case "self":
                continue
            case "key":
                var options: [WrapArgOptions] = []
                key = .init(rawValue: await handleAnnotation(arg.annotation, options: &options)) ?? .object
            default:
                continue
            }
            //arg.print_dict()
            
        }
        return key
    }
    
    func getValueType(f: PythonObject) async -> PythonType {
        var key: PythonType = .object
        for arg in f.args.args {
            switch arg.arg {
            case "self":
                continue
            case "value":
                var options: [WrapArgOptions] = []
                key = .init(rawValue: await handleAnnotation(arg.annotation, options: &options)) ?? .object
            default:
                continue
            }
            //arg.print_dict()
            
        }
        return key
    }
    
    func getReturnType(f: PythonObject) async -> PythonType {
        let returns = f.returns
        if returns.isNone { return .object }
        let n = String(returns.id)

        
        return .init(rawValue: n) ?? .object
    }
    
    func handleFunctionSpecial(name: String, f: PythonObject, cls: WrapClass) async -> Bool {
        switch PySequenceFunctions(rawValue: name) {
        case .__getitem__:
            //f.print_dict()
            //f.returns.print_dict()
            cls.pySequenceMethods.append(
                .__getitem__(key: await getKeyType(f: f), returns: await getReturnType(f: f) )
            )
            
            return true
        case .__setitem__:
            
            cls.pySequenceMethods.append(
                .__setitem__(key: await getKeyType(f: f), value: await getValueType(f: f))
            )
            return true
        case .__delitem__:
            cls.pySequenceMethods.append(.__delitem__(key: await getKeyType(f: f)))
            return true
        default: break
            
        }
        switch PyClassFunctions(rawValue: name) {
        case .__call__:
            cls.pyClassMehthods.append(.__call__)
        case .__init__:
            //var options: [WrapFunctionOption] = []
            //print(cls.title, cls.functions.first(where: {$0.has_option(option: .callback)})  != nil)
            let init_f = WrapFunction(name: name, args: [], rtn: .init(name: "", type: .void, other_type: "", idx: 0, arg_options: []), options: [.callback])
            await handleArguments(f.args, f: init_f)
            cls.init_function = init_f
            return true
        
        default: break
        }
        return false
    }
    
    func handleClassFunction(_ _func: PythonObject, cls: WrapClass, callback: Bool = false) async {
        //print("\n##################################################################################\nhandleFunction\n")
        //_func.print_dict()
        let name: String = .init(o: _func.name)
        //print("handleClassFunction: \(name)")
        if await handleFunctionSpecial(name: name, f: _func, cls: cls) {
            return
        }
        
        
        
        
        var options: [WrapFunctionOption] = []
        if callback {
            options.append(.callback)
            
        }
        var rtn_options = [WrapArgOptions]()
        let _rtn = await handleReturnAnnotation(_func.returns, options: &rtn_options)
        
        let f = WrapFunction(name: name, args: [], rtn: .init(name: "", type: .init(rawValue: _rtn) ?? .void, other_type: "", idx: 0, arg_options: []), options: options)
        await handleArguments(_func.args, f: f)
        cls.functions.append(f)
    }
    
    func handleArguments(_ args: PythonObject, f: WrapFunction) async {
//        //print("handleArguments")
//        args.print_dict()
        let _args: PythonObject = args.args
        let arg_array: [PythonObject] = _args.array()
        for arg in arg_array {
            await handleArg(arg,f: f)
        }
    }
    
    func handleArg(_ arg: PythonObject, f: WrapFunction) async {
//        //print("handleArg")
        //arg.print_dict()
        
        let name = arg.arg.ptr.string!
        
        let arg_arg = arg.arg as PythonObject
        
        //print(name,String(ptr: PyObject_Str(PyObject_Type(arg.arg.ptr))))
        
        var options: [WrapArgOptions] = []
        
        switch arg_arg {
        case .str_self:
            //print("self arg")
            return
        default: break
        }

        let t = await handleAnnotation(arg.annotation, options: &options)
        let warg = handleWrapArg(name: name, t: t, options: options)
        //print(warg)
        f._args_.append(warg)
        
    }
    
    func handleAnnotation(_ anno: PythonObject,options: inout [WrapArgOptions]) async ->  String {
        //print("handleAnnotation", String(ptr: PyObject_Str(PyObject_Type(anno.ptr))))
//        anno.__dict__.print()
        
        //let value = anno.value.ptr.string!
        //var options: [WrapArgOptions] = []
        
        guard anno.ptr != nil else { return "" }
        switch anno {
        case let obj where obj.IsInstance(Ast.Name):
            return await handleName(obj)
        case let o where o.IsInstance(Ast.Subscript):
            
            return await handleSubScript(o, options: &options)
            
        case let o where o.IsInstance(Ast.Constant):
            o.print_dict()
            
        case let o where o.isNone:
            return "object"
        default:
            //print("type not handle!!!!")
            fatalError( String(ptr: PyObject_Str(PyObject_Type(anno.ptr))))
        }
        
        
        return ""
    }
    
    func handleReturnAnnotation(_ anno: PythonObject,options: inout [WrapArgOptions]) async ->  String {
        //print("handleAnnotation", String(ptr: PyObject_Str(PyObject_Type(anno.ptr))))
        //        anno.__dict__.print()
        
        //let value = anno.value.ptr.string!
        //var options: [WrapArgOptions] = []
        
        guard anno.ptr != nil else { return "" }
        switch anno {
        case let obj where obj.IsInstance(Ast.Name):
            return await handleName(obj)
        case let o where o.IsInstance(Ast.Subscript):
            
            return await handleSubScript(o, options: &options)
            
        case let o where o.IsInstance(Ast.Constant):
            o.print_dict()
            
        case let o where o.isNone:
            return "void"
        default:
            //print("type not handle!!!!")
            fatalError( String(ptr: PyObject_Str(PyObject_Type(anno.ptr))))
        }
        
        
        return ""
    }
    
    func handleWrapArg(name: String, t: String, options: [WrapArgOptions]) -> WrapArgProtocol {
        
        let type: PythonType = .init(rawValue: t)!
        
        switch type {
        case .int, .int32, .int16, .int8, .uint, .uint32, .uint16, .uint8, .long, .ulong, .short, .ushort:
            return intArg(_name: name, _type: type, _other_type: "", _idx: 0, _options: options)
        case .float, .float32, .double:
            return floatArg(_name: name, _type: type, _other_type: "", _idx: 0, _options: options)
        case .str:
            return strArg(_name: name, _type: type, _other_type: "", _idx: 0, _options: options)
        case .data:
            return dataArg(_name: name, _type: type, _other_type: "", _idx: 0, _options: options)
        case .jsondata:
            return jsonDataArg(_name: name, _type: type, _other_type: "", _idx: 0, _options: options)
        case .bool:
            return boolArg(_name: name, _type: type, _other_type: "", _idx: 0, _options: options)
        case .object:
            return objectArg(_name: name, _type: type, _other_type: "", _idx: 0, _options: options)
        case .other:
            return objectArg(_name: name, _type: type, _other_type: "", _idx: 0, _options: options)
        default: fatalError()
        }
    }
    
    enum AstSubScriptValue: PyStringEnum {
        case list
        case tuple
    }
    
    func handleSubScript(_ sub: PythonObject, options: inout [WrapArgOptions]) async -> String {
        //print("handleSubScript")
        //sub.print_dict()
        let value: PythonObject = await handleName(object: sub.value)
        //print("\tvalue: \(value)")
        switch AstSubScriptValue(rawValue: .init(rawValue: value) ) {
        case .list:
            //print("enum case is list")
            options.append(.list)
        case .tuple:
            //print("enum case is tuple")
            options.append(.tuple)
        case .none:
            fatalError()
        }
        
        //print("options",options)
        
        let slice: PythonObject = sub.slice
        switch slice {
        case let o where o.IsInstance(Ast.Name):
            return await handleName(o)
        case let o where o.IsInstance(Ast.Subscript):
            return await handleSubScript(o, options: &options)
        default: fatalError()
        }
        return ""
    }
    
    func handleName(object name: PythonObject) async -> PythonObject {
        return name.id
    }
    
    func handleName(_ name: PythonObject) async -> String {
        let id: String = .init(o: name.id)
        return id
    }
    
//    func makeWrapArg(_ _arg: PythonObject) -> WrapArgProtocol {
//
//        let t = try c.decode(String.self, forKey: .type)
//
//        var type: PythonType
//        do {
//            type = try c.decode(PythonType.self, forKey: .type)
//        } catch {
//            type = .other
//        }
//
//        switch type {
//        case .int, .int32, .int16, .int8, .uint, .uint32, .uint16, .uint8, .long, .ulong, .short, .ushort:
//            return intArg(_name: <#T##String#>, _type: <#T##PythonType#>, _other_type: <#T##String#>, _idx: <#T##Int#>, _options: <#T##[WrapArgOptions]#>, _sequence: <#T##Bool#>, _tuple: <#T##Bool#>, _list: <#T##Bool#>)
//        case .float, .float32, .double:
//            arg = try floatArg(from: decoder)
//        case .str:
//            arg = try strArg(from: decoder)
//        case .data:
//            arg = try dataArg(from: decoder)
//        case .jsondata:
//            arg = try jsonDataArg(from: decoder)
//        case .bool:
//            arg = try boolArg(from: decoder)
//        case .other:
//            let mod = wrap_module_shared!
//
//            var other_type: String
//            if c.contains(.other_type) {
//                other_type = try c.decode(String.self, forKey: .other_type)
//            } else {
//                other_type = try c.decode(String.self, forKey: .type)
//            }
//
//
//            if let objectenum = mod.objectEnums(has: other_type) {
//                switch objectenum.type {
//                case .str:
//                    arg = try intEnumArg(from: decoder)
//                case .int:
//                    arg = try intEnumArg(from: decoder)
//                case .object:
//                    switch objectenum.subtype {
//                    case .str:
//                        arg = try objectStrEnumArg(from: decoder)
//                    default: arg = try objectStrEnumArg(from: decoder)
//                    }
//                }
//            } else {
//                arg = try objectArg(from: decoder)
//            }
//        default:
//            arg = try objectArg(from: decoder)
//        }
//
//
//    }
//
    static func parseEval(string: String) {
        let pyString = string.pyStringUTF8

        let _parsed: PythonPointer = Ast.py_cls(method: "parse", args: [pyString])
        guard _parsed != nil else { PyErr_Print(); pyString.decref(); return }
        let parsed = PythonObject(ptr: _parsed)
        let parsed_body: PythonObject = parsed.body

        for item in parsed_body.ptr.getBuffer() {
            let _item = PythonObject(ptr: item)

            switch item {

            case let obj where PyObject_IsInstance(obj, Ast.Expr) == 1 :
                handleExpr(_item)
            case let obj where PyObject_IsInstance(obj, Ast.AugAssign) == 1 :
                print("ast.Expr")
            case let obj where PyObject_IsInstance(obj, Ast.Expr) == 1 :
                print("ast.Expr")
            case let obj where PyObject_IsInstance(obj, Ast.Expr) == 1 :
                print("ast.Expr")
            case let obj where PyObject_IsInstance(obj, Ast.Expr) == 1 :
                print("ast.Expr")

            default:
                fatalError()
                //pythonPrint(_item.__dict__.ptr)
            }



        }


        //parsed.decref()
        pyString.decref()
    }


    static func handleExpr(_ o: PythonObject) {
//        //print("ast.Expr")
//        pythonPrint(o.__dict__.ptr)
//        let value: PythonObject = o.value
//        switch value.ptr {
//        case let obj where PyObject_IsInstance(obj, Ast.List) == 1 :
//            handleList(value)
//
//        default:
//            break
//        }
    }


    static func handleList(_ o: PythonObject) {
//        //print("ast.List")
//        pythonPrint(o.__dict__.ptr)
//        let elts: PythonObject = o.elts
//
//        let _elts: [PythonObject] = elts.ptr.map { .init(ptr: $0, from_getter: true) }
//        var expressions = [ExpressionProtocol]()
//        for item in _elts {
//            //let item = PythonObject(ptr: _item)
//            var value_name = [String]()
//            switch item.ptr {
//            case let obj where PyObject_IsInstance(obj, Ast.Constant) == 1 :
//                handleConstant(item, &expressions)
//            case let obj where PyObject_IsInstance(obj, Ast.Name) == 1 :
//                handleName(item, value_name: &value_name, &expressions)
//            case let obj where PyObject_IsInstance(obj, Ast.Attribute) == 1 :
//                handleAttribute(item, value_name: &value_name, &expressions)
//                //print(value_name)
//            case let obj where PyObject_IsInstance(obj, Ast.BinOp) == 1 :
//                handleBinOp(item)
//            default:
//                //print("handleList default")
//                pythonPrint(item.ptr)
//            }
//        }
//
//        //print(expressions.map(\.type))
//        switch elts.ptr {
//        case let obj where PyObject_IsInstance(obj, Ast.List) == 1 :
//
//
//        default:
//            break
//        }
    }

    enum AstOperator {
        case Add
        case Div
        case Mult
        case Sub
        case Mod
    }

    static func handleAstOperator(_ o: PythonObject) -> AstOperator {
        switch o.ptr {
        case let obj where PyObject_IsInstance(obj, Ast.Add) == 1 :
            return .Add
        case let obj where PyObject_IsInstance(obj, Ast.Sub) == 1 :
            return .Sub
        case let obj where PyObject_IsInstance(obj, Ast.Mult) == 1 :
            return .Mult
        case let obj where PyObject_IsInstance(obj, Ast.Div) == 1 :
            return .Add
        case let obj where PyObject_IsInstance(obj, Ast.Mod) == 1 :
            return .Mod
        default:
//            pythonPrint(o.ptr)
            return .Add
        }
    }

    static func handleBinOp(_ o: PythonObject) {
        //print("ast.BinOp")
        let l:PythonObject = o.left
        let r: PythonObject = o.right
        let op = handleAstOperator(o.op)

        var left_name = [String]()
        var right_name = [String]()
//        let l_exp = SingleExpression()
//        switch l.ptr {
//        case let obj where PyObject_IsInstance(obj, Ast.Constant) == 1 :
//            handleConstant(l, &l_exp.children)
//        case let obj where PyObject_IsInstance(obj, Ast.Name) == 1 :
//            handleName(l, value_name: &left_name, &l_exp.children)
//        case let obj where PyObject_IsInstance(obj, Ast.Attribute) == 1 :
//            handleAttribute(l, value_name: &left_name, &l_exp.children)
//        default:
//            //print("handleList default")
//            pythonPrint(l.ptr)
//        }
//
//        let r_exp = SingleExpression()
//        switch r.ptr {
//        case let obj where PyObject_IsInstance(obj, Ast.Constant) == 1 :
//            handleConstant(r, &r_exp.children)
//        case let obj where PyObject_IsInstance(obj, Ast.Name) == 1 :
//            handleName(r, value_name: &right_name, &r_exp.children)
//        case let obj where PyObject_IsInstance(obj, Ast.Attribute) == 1 :
//            handleAttribute(r, value_name: &right_name, &r_exp.children)
//        default:
//            //print("handleList default")
//            pythonPrint(r.ptr)
//        }
        //print("operator")
        switch op {
        case .Add:
            break
        case .Div:
            break
        case .Mult:
            break
        case .Sub:
            break
        case .Mod:
            break
        }
    }

//    static func handleConstant(_ o: PythonObject, _ e: inout [ExpressionProtocol]) {
//        //print("ast.Constant")
//        pythonPrint(o.__dict__.ptr)
//        let test = PyAst_Constant(o)
//
//        //print(test.rawValue)
//        //print(test.repr)
//        e.append(
//            ValueExpression()
//        )
//        //value_name += o.id.pyStringUTF8
//
//    }
    //@discardableResult
//    static func handleName(_ o: PythonObject, value_name: inout [String],_ e: inout [ExpressionProtocol]) {
//        //print("ast.Name")
//        let id: PythonObject = o.id
//        pythonPrint(id.ptr)
//        pythonPrint(o.__dict__.ptr)
//        value_name.append(id.string!)
//        let name_exp = ObservableExpression()
//
//        //print("name:", value_name.joined(separator: "."))
//        //print("from attribute", e)
//        //guard let attr_exp = e.first as? ObservableExpression else { return }
//        name_exp.attr_name = value_name.joined(separator: ".")
//        //print(name_exp.getAttr() )
//    }

    //@discardableResult
//    static func handleAttribute(_ o: PythonObject, value_name: inout [String], _ e: inout [ExpressionProtocol]) {
//        //print("ast.Attribute")
//        //pythonPrint(o.__dict__.ptr)
//        let value: PythonObject = o.value
//        let attr: PythonObject = o.attr
//        //var value_name = ""
//        let attr_string = attr.string ?? ""
//        let attr_exp = ObservableExpression()
//        switch value.ptr {
//
//        case let obj where PyObject_IsInstance(obj, Ast.Constant) == 1 :
//            handleConstant(value, &attr_exp.children)
//        case let obj where PyObject_IsInstance(obj, Ast.Name) == 1 :
//            handleName(value, value_name: &value_name, &attr_exp.children)
//        case let obj where PyObject_IsInstance(obj, Ast.Attribute) == 1 :
//            handleAttribute(value, value_name: &value_name, &attr_exp.children)
//        default:
//            //print("handleList default")
//            pythonPrint(value.ptr)
//        }
//        //let final_string = "\(value_name).\(attr_string)"
//        attr_exp.attr_name = attr_string
//        value_name.append(attr_string)
//        e.append(
//            attr_exp
//        )
//        //print("attribute:", value_name.joined(separator: "."))
//
//        //print(attr_exp.getAttr() )
//
//
//        //return value_name
//    }
}
public protocol PyAstObject {
    
    var name: String { get }
    
    var type: AstType { get }
    
    init(_ v: PythonObject)
    
    
    
}


public func handlePyAst(_ v: PythonObject) -> PyAstObject {
    switch v {
        
    case let obj where obj.IsInstance(Ast.Module):
        fatalError()
    case let obj where obj.IsInstance(Ast.ClassDef):
        return PyAst_Class(obj)
    case let obj where obj.IsInstance(Ast.FunctionDef):
        return PyAst_Function(obj)
    case let obj where obj.IsInstance(Ast.Constant):
        fatalError()
    case let obj where obj.IsInstance(Ast.Name):
        return PyAst_Name(obj)
    case let obj where obj.IsInstance(Ast.Expr):
        fatalError()
    case let obj where obj.IsInstance(Ast.Assign):
        return PyAst_Assign(obj)
    case let obj where obj.IsInstance(Ast.AnnAssign):
        fatalError()
    case let obj where obj.IsInstance(Ast.ImportFrom):
        return PyAst_ImportFrom(obj)
    case let obj where obj.IsInstance(Ast.Subscript):
        return PyAst_Subscript(obj)
    default:
        print()
        pyPrint(v.ptr)
        v.print_dict()
        fatalError()
    }
}

protocol PyAstProtocol: RawRepresentable {

    var value: PythonObject { get set }

    var repr: String { get }
}








class PyAst_Arg: PyAstObject {
    
    let type: AstType = .Arg
    
    var name: String { arg }
    
    var arg: String
    
    var annotation: PyAstObject?
    
    required init(_ v: PythonObject) {
        print("PyAst_Arg init:")
        arg = .init( v.arg)
        
        let anno = v.annotation
        if !anno.isNone {
            //anno.print_dict()
            annotation = handlePyAst(anno)
        }
        
        
        print(self, name)
    }
    

}

class PyAst_Annotation: PyAstObject {
    
    let type: AstType = .Annotation
    
    var id: String
    
    
    
    var name: String { id }
    
    
    
    required init(_ v: PythonObject) {
        id = .init(v.id)
        print(self)
        //v.print_dict()
    }
}

class PyAst_Subscript: PyAstObject {
    
    let type: AstType = .Subscript
    
    var name: String {
        value.name
    }
    
    var value: PyAstObject
    
    var slice: PyAstObject
    
    required init(_ v: PythonSwiftCore.PythonObject) {
        
        
        
        switch v.value {
        case let obj where obj.IsInstance(Ast.Name):
            value = PyAst_Name(obj)
        default:
            v.value.print_dict()
            fatalError()
        }
        
        switch v.slice {
        case let obj where obj.IsInstance(Ast.Name):
            slice = PyAst_Name(obj)
        default:
            v.slice.print_dict()
            fatalError()
        }
        
        
        print(self)
        //v.print_dict()
        print(value.name)
        
    }
    
    
}

class PyAst_Slice: PyAstObject {
    
    let type: AstType = .Slice
    
    var name: String {
        ""
    }
    
    required init(_ v: PythonSwiftCore.PythonObject) {
        print(self)
        //v.print_dict()
    }
    
    
}





class PyAst_Expression: PyAstObject {
    
    let type: AstType = .Expr
    
    var name = ""
    
    required init(_ v: PythonObject) {
        
        print(self)
        //v.print_dict()
    }
}

struct PyAst_Attribute: PyAstProtocol, Decodable {


    var rawValue: String

    typealias RawValue = String

    var value: PythonObject

    init?(rawValue: String) {
        self.rawValue = rawValue
        value = .init(ptr: PythonNone)
    }

    var repr: String {
        .init(value.__dict__.__repr__().pyObject)
    }
}

struct PyAst_Name: PyAstObject {
    
    let type: AstType = .Name
    
    var id: String
    
    var name: String { id }
    
    init(_ v: PythonObject) {
        let _id = v.id
        
        
        id = _id.isNone ? "None": String(_id)
        
        print(self)
        ////v.print_dict()
    }


}

struct PyAst_Constant: PyAstProtocol {

    var rawValue: String

    typealias RawValue = String

    var value: PythonObject

    init?(rawValue: String) {
        self.rawValue = rawValue
        value = .init(ptr: PythonNone)
    }

    init(_ v: PythonObject) {
        value = v
        rawValue = .init(v.__str__().pyPointer) ?? ""
    }

    var repr: String {
        .init(value.__dict__.__repr__().pyObject)
    }
}

struct PyAst_Constant2: PyAstProtocol {

    var rawValue: String

    typealias RawValue = String

    var value: PythonObject

    init?(rawValue: String) {
        self.rawValue = rawValue
        value = .init(ptr: PythonNone)
    }
    var repr: String {
        .init(value.__str__().pyPointer) ?? ""
    }
}



let a = [any PyAstProtocol]()
