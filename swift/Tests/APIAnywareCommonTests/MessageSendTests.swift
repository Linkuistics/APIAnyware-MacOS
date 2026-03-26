import Testing
import Foundation
@testable import APIAnywareCommon

@Test func msgPtrAllocInit() {
    let cls = getClass("NSObject")!
    let alloc = msgPtr(cls, "alloc")!
    let obj = msgPtr(alloc, "init")!
    releaseObject(obj)
}

@Test func msgPtr1InitWithString() {
    let cls = getClass("NSString")!
    let alloc = msgPtr(cls, "alloc")!
    let cStr = stringToNSString("Hello")
    let obj = msgPtr1(alloc, "initWithString:", cStr)!
    let len = msgUInt(obj, "length")
    #expect(len == 5)
    releaseObject(obj)
    releaseObject(cStr)
}

@Test func msgUIntReturnsLength() {
    let str = stringToNSString("Hello, World!")
    let len = msgUInt(str, "length")
    #expect(len == 13)
    releaseObject(str)
}

@Test func msgBoolIsKindOfClass() {
    let str = stringToNSString("Test")
    let nsstringClass = getClass("NSString")!
    let result = msgBool1(str, "isKindOfClass:", nsstringClass)
    #expect(result == true)
    releaseObject(str)
}

@Test func msgBoolIsNotKindOfClass() {
    let str = stringToNSString("Test")
    let nsarrayClass = getClass("NSArray")!
    let result = msgBool1(str, "isKindOfClass:", nsarrayClass)
    #expect(result == false)
    releaseObject(str)
}

@Test func msgVoidDoesNotCrash() {
    let cls = getClass("NSObject")!
    let alloc = msgPtr(cls, "alloc")!
    let obj = msgPtr(alloc, "init")!
    _ = retainObject(obj)
    msgVoid(obj, "release")
    releaseObject(obj)
}

@Test func msgVoid1AddObject() {
    let arrCls = getClass("NSMutableArray")!
    let alloc = msgPtr(arrCls, "alloc")!
    let arr = msgPtr(alloc, "init")!

    let str = stringToNSString("item")
    msgVoid1(arr, "addObject:", str)

    let count = msgUInt(arr, "count")
    #expect(count == 1)

    releaseObject(str)
    releaseObject(arr)
}

@Test func msgDoubleReturn() {
    let num = NSNumber(value: 3.14)
    let ptr = Unmanaged.passRetained(num).toOpaque()
    let val = msgDouble(ptr, "doubleValue")
    #expect(val == 3.14)
    releaseObject(ptr)
}

@Test func msgPtrDoubleArg() {
    // Create NSNumber via msgPtrDouble (numberWithDouble: class method)
    let pool = autoreleasePoolPush()
    let cls = getClass("NSNumber")!
    let num = msgPtrDouble(cls, "numberWithDouble:", 3.14)!
    let val = msgDouble(num, "doubleValue")
    #expect(val == 3.14)
    autoreleasePoolPop(pool)
}

@Test func msgIntReturn() {
    let num = NSNumber(value: 42)
    let ptr = Unmanaged.passRetained(num).toOpaque()
    let val = msgInt(ptr, "integerValue")
    #expect(val == 42)
    releaseObject(ptr)
}

@Test func msgPtrIntArg() {
    let pool = autoreleasePoolPush()
    let cls = getClass("NSNumber")!
    let num = msgPtrInt(cls, "numberWithInteger:", 42)!
    let val = msgInt(num, "integerValue")
    #expect(val == 42)
    autoreleasePoolPop(pool)
}

@Test func msgPtrUIntObjectAtIndex() {
    let arrCls = getClass("NSMutableArray")!
    let alloc = msgPtr(arrCls, "alloc")!
    let arr = msgPtr(alloc, "init")!

    let str = stringToNSString("hello")
    msgVoid1(arr, "addObject:", str)

    let item = msgPtrUInt(arr, "objectAtIndex:", 0)!
    let len = msgUInt(item, "length")
    #expect(len == 5)

    releaseObject(str)
    releaseObject(arr)
}

@Test func msgRectReturn() {
    // Create NSValue with rect using Swift, then read via msgRect
    let pool = autoreleasePoolPush()
    let rect = NSRect(origin: CGPoint(x: 10, y: 20), size: CGSize(width: 300, height: 400))
    let nsValue = NSValue(rect: rect)
    let ptr = Unmanaged.passRetained(nsValue).toOpaque()

    var outBuf = [UInt8](repeating: 0, count: sizeofCGRect())
    msgRect(ptr, "rectValue", &outBuf)

    var x = 0.0, y = 0.0, w = 0.0, h = 0.0
    unpackCGRect(&outBuf, &x, &y, &w, &h)
    #expect(x == 10.0)
    #expect(y == 20.0)
    #expect(w == 300.0)
    #expect(h == 400.0)

    releaseObject(ptr)
    autoreleasePoolPop(pool)
}

@Test func msgPtr2SetObjectForKey() {
    let dictCls = getClass("NSMutableDictionary")!
    let alloc = msgPtr(dictCls, "alloc")!
    let dict = msgPtr(alloc, "init")!

    let key = stringToNSString("name")
    let val = stringToNSString("Alice")
    msgVoid2(dict, "setObject:forKey:", val, key)

    let count = msgUInt(dict, "count")
    #expect(count == 1)

    releaseObject(key)
    releaseObject(val)
    releaseObject(dict)
}
