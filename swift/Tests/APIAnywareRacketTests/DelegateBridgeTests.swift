import Testing
import Foundation
@testable import APIAnywareRacket

// MARK: - Test callback tracking

/// Tracks calls to delegate method callbacks for test verification.
private nonisolated(unsafe) var delegateCallLog: [(selector: String, args: [UnsafeMutableRawPointer?])] = []

/// void callback: 0 args
private let voidCallback0: @convention(c) () -> Void = {
    delegateCallLog.append((selector: "void0", args: []))
}

/// void callback: 1 arg
private let voidCallback1: @convention(c) (UnsafeMutableRawPointer?) -> Void = { arg0 in
    delegateCallLog.append((selector: "void1", args: [arg0]))
}

/// bool callback: 0 args — always returns true
private let boolCallback0: @convention(c) () -> Bool = {
    delegateCallLog.append((selector: "bool0", args: []))
    return true
}

/// bool callback: 1 arg
private let boolCallback1: @convention(c) (UnsafeMutableRawPointer?) -> Bool = { arg0 in
    delegateCallLog.append((selector: "bool1", args: [arg0]))
    return true
}

/// id callback: 0 args — returns nil
private let idCallback0: @convention(c) () -> UnsafeMutableRawPointer? = {
    delegateCallLog.append((selector: "id0", args: []))
    return nil
}

// Serialized to avoid races on shared delegateCallLog and dispatchTable
@Suite("DelegateBridge", .serialized)
struct DelegateBridgeTests {

    @Test("Register a delegate class with void method")
    func registerDelegateVoid() {
        let instance = withSelectorArray(["windowWillClose:"], returnTypes: ["void"]) { sels, rets in
            registerDelegate(sels, rets, 1)
        }
        #expect(instance != nil, "Should create a delegate instance")
    }

    @Test("Set and invoke a void method handler")
    func setAndInvokeVoidMethod() {
        delegateCallLog = []

        let instance = withSelectorArray(["testVoidAction:"], returnTypes: ["void"]) { sels, rets in
            registerDelegate(sels, rets, 1)
        }!

        let callbackPtr = unsafeBitCast(voidCallback1, to: UnsafeMutableRawPointer.self)
        setDelegateHandler(instance, "testVoidAction:", callbackPtr)

        // Create a real ObjC object as the argument
        let argStr = ("sentinel" as NSString)
        let argPtr = Unmanaged.passUnretained(argStr).toOpaque()
        sendMsg1(instance, "testVoidAction:", argPtr)

        #expect(delegateCallLog.count == 1, "Handler should be called once")
        #expect(delegateCallLog[0].args[0] == argPtr, "Handler should receive the argument")
    }

    @Test("Set and invoke a bool method handler")
    func setAndInvokeBoolMethod() {
        delegateCallLog = []

        let instance = withSelectorArray(["shouldTestClose"], returnTypes: ["bool"]) { sels, rets in
            registerDelegate(sels, rets, 1)
        }!

        let callbackPtr = unsafeBitCast(boolCallback0, to: UnsafeMutableRawPointer.self)
        setDelegateHandler(instance, "shouldTestClose", callbackPtr)

        let result = sendMsgBool(instance, "shouldTestClose")

        #expect(delegateCallLog.count == 1, "Bool handler should be called")
        #expect(result == true, "Should return true from callback")
    }

    @Test("Multiple methods on one delegate")
    func multipleMethodsOnDelegate() {
        delegateCallLog = []

        let instance = withSelectorArray(
            ["doTestAction", "shouldTestDoIt"],
            returnTypes: ["void", "bool"]
        ) { sels, rets in
            registerDelegate(sels, rets, 2)
        }!

        setDelegateHandler(instance, "doTestAction",
            unsafeBitCast(voidCallback0, to: UnsafeMutableRawPointer.self))
        setDelegateHandler(instance, "shouldTestDoIt",
            unsafeBitCast(boolCallback0, to: UnsafeMutableRawPointer.self))

        sendMsg0(instance, "doTestAction")
        let boolResult = sendMsgBool(instance, "shouldTestDoIt")

        #expect(delegateCallLog.count == 2)
        #expect(boolResult == true)
    }

    @Test("Delegate without handler uses default return")
    func defaultReturnWithoutHandler() {
        let instance = withSelectorArray(["shouldTestProceed"], returnTypes: ["bool"]) { sels, rets in
            registerDelegate(sels, rets, 1)
        }!

        // Don't set a handler — should get default return (false for bool)
        let result = sendMsgBool(instance, "shouldTestProceed")
        #expect(result == false, "Default bool return should be false")
    }

    @Test("Set method registers GC prevention, free releases it")
    func delegateGCLifecycle() {
        let instance = withSelectorArray(["testGCLifecycleAction:"], returnTypes: ["void"]) { sels, rets in
            registerDelegate(sels, rets, 1)
        }!

        let beforeSet = gcPreventionCount()
        let callbackPtr = unsafeBitCast(voidCallback1, to: UnsafeMutableRawPointer.self)
        setDelegateHandler(instance, "testGCLifecycleAction:", callbackPtr)
        let afterSet = gcPreventionCount()
        #expect(afterSet > beforeSet, "setDelegateHandler should register GC prevention")

        let beforeFree = gcPreventionCount()
        freeDelegateDispatch(instance)
        let afterFree = gcPreventionCount()
        #expect(afterFree < beforeFree, "freeDelegateDispatch should release GC prevention")
    }

    @Test("Free delegate removes from dispatch table")
    func freeDelegateRemovesFromTable() {
        delegateCallLog = []

        let instance = withSelectorArray(["testFreeAction"], returnTypes: ["void"]) { sels, rets in
            registerDelegate(sels, rets, 1)
        }!

        setDelegateHandler(instance, "testFreeAction",
            unsafeBitCast(voidCallback0, to: UnsafeMutableRawPointer.self))

        freeDelegateDispatch(instance)

        delegateCallLog = []
        sendMsg0(instance, "testFreeAction")
        #expect(delegateCallLog.isEmpty, "Handler should not be called after free")
    }
}

// MARK: - Test helpers

/// Create C string arrays, call the body, and free the arrays.
private func withSelectorArray(
    _ selectors: [String],
    returnTypes: [String],
    body: (UnsafePointer<UnsafePointer<CChar>?>, UnsafePointer<UnsafePointer<CChar>?>) -> UnsafeMutableRawPointer?
) -> UnsafeMutableRawPointer? {
    let selPtrs = selectors.map { UnsafePointer<CChar>?(strdup($0)) }
    let retPtrs = returnTypes.map { UnsafePointer<CChar>?(strdup($0)) }
    defer {
        for p in selPtrs { free(UnsafeMutablePointer(mutating: p)) }
        for p in retPtrs { free(UnsafeMutablePointer(mutating: p)) }
    }
    return selPtrs.withUnsafeBufferPointer { selBuf in
        retPtrs.withUnsafeBufferPointer { retBuf in
            body(selBuf.baseAddress!, retBuf.baseAddress!)
        }
    }
}

/// Send an ObjC message with 0 args via objc_msgSend.
private func sendMsg0(_ target: UnsafeMutableRawPointer, _ selectorName: String) {
    let msgSendPtr = dlsym(UnsafeMutableRawPointer(bitPattern: -2)!, "objc_msgSend")!
    selectorName.withCString { selCStr in
        let sel = unsafeBitCast(sel_registerName(selCStr), to: UnsafeMutableRawPointer.self)
        typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Void
        unsafeBitCast(msgSendPtr, to: F.self)(target, sel)
    }
}

/// Send an ObjC message with 1 pointer arg via objc_msgSend.
private func sendMsg1(_ target: UnsafeMutableRawPointer, _ selectorName: String, _ arg: UnsafeMutableRawPointer?) {
    let msgSendPtr = dlsym(UnsafeMutableRawPointer(bitPattern: -2)!, "objc_msgSend")!
    selectorName.withCString { selCStr in
        let sel = unsafeBitCast(sel_registerName(selCStr), to: UnsafeMutableRawPointer.self)
        typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer?) -> Void
        unsafeBitCast(msgSendPtr, to: F.self)(target, sel, arg)
    }
}

/// Send an ObjC message with 0 args, returning Bool.
private func sendMsgBool(_ target: UnsafeMutableRawPointer, _ selectorName: String) -> Bool {
    let msgSendPtr = dlsym(UnsafeMutableRawPointer(bitPattern: -2)!, "objc_msgSend")!
    return selectorName.withCString { selCStr in
        let sel = unsafeBitCast(sel_registerName(selCStr), to: UnsafeMutableRawPointer.self)
        typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Bool
        return unsafeBitCast(msgSendPtr, to: F.self)(target, sel)
    }
}
