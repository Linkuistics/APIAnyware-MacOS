// MessageSend.swift — Typed objc_msgSend wrappers for common calling patterns.
//
// Uses dlsym to get objc_msgSend and unsafeBitCast for each typed variant.
// The unsafeBitCast is always done within this module's @_cdecl functions,
// which produces correct code on arm64e.
//
// Naming convention:
//   aw_common_msg_{return}     — zero pointer args
//   aw_common_msg_{return}{N}  — N pointer args
//   aw_common_msg_{return}_{argtype} — non-pointer arg type

import Foundation

// MARK: - Internal helpers

/// Cached objc_msgSend function pointer address.
private nonisolated(unsafe) let _msgSendPtr: UnsafeMutableRawPointer = dlsym(
    UnsafeMutableRawPointer(bitPattern: -2)!,
    "objc_msgSend"
)!

/// Convert a C string selector name to a raw selector pointer for objc_msgSend.
func makeSelector(_ name: UnsafePointer<CChar>) -> UnsafeMutableRawPointer {
    unsafeBitCast(sel_registerName(name), to: UnsafeMutableRawPointer.self)
}

// MARK: - Returns pointer (id)

/// Send: (target, sel) -> id
@_cdecl("aw_common_msg_ptr")
public func msgPtr(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>
) -> UnsafeMutableRawPointer? {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> UnsafeMutableRawPointer?
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
}

/// Send: (target, sel, id) -> id
@_cdecl("aw_common_msg_ptr1")
public func msgPtr1(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ arg1: UnsafeMutableRawPointer?
) -> UnsafeMutableRawPointer? {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel), arg1)
}

/// Send: (target, sel, id, id) -> id
@_cdecl("aw_common_msg_ptr2")
public func msgPtr2(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ arg1: UnsafeMutableRawPointer?,
    _ arg2: UnsafeMutableRawPointer?
) -> UnsafeMutableRawPointer? {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel), arg1, arg2)
}

/// Send: (target, sel, UInt64) -> id — for objectAtIndex:, etc.
@_cdecl("aw_common_msg_ptr_uint")
public func msgPtrUInt(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ arg1: UInt64
) -> UnsafeMutableRawPointer? {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UInt64) -> UnsafeMutableRawPointer?
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel), arg1)
}

/// Send: (target, sel, Double) -> id — for numberWithDouble:, etc.
@_cdecl("aw_common_msg_ptr_dbl")
public func msgPtrDouble(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ arg1: Double
) -> UnsafeMutableRawPointer? {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer, Double) -> UnsafeMutableRawPointer?
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel), arg1)
}

/// Send: (target, sel, Int64) -> id — for numberWithInteger:, etc.
@_cdecl("aw_common_msg_ptr_int")
public func msgPtrInt(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ arg1: Int64
) -> UnsafeMutableRawPointer? {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer, Int64) -> UnsafeMutableRawPointer?
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel), arg1)
}

// MARK: - Returns void

/// Send: (target, sel) -> void
@_cdecl("aw_common_msg_void")
public func msgVoid(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>
) {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Void
    unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
}

/// Send: (target, sel, id) -> void — for setDelegate:, addObject:, etc.
@_cdecl("aw_common_msg_void1")
public func msgVoid1(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ arg1: UnsafeMutableRawPointer?
) {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer?) -> Void
    unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel), arg1)
}

/// Send: (target, sel, id, id) -> void — for setObject:forKey:, etc.
@_cdecl("aw_common_msg_void2")
public func msgVoid2(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ arg1: UnsafeMutableRawPointer?,
    _ arg2: UnsafeMutableRawPointer?
) {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> Void
    unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel), arg1, arg2)
}

// MARK: - Returns Bool

/// Send: (target, sel) -> Bool
@_cdecl("aw_common_msg_bool")
public func msgBool(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>
) -> Bool {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Bool
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
}

/// Send: (target, sel, id) -> Bool — for isKindOfClass:, isEqual:, etc.
@_cdecl("aw_common_msg_bool1")
public func msgBool1(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ arg1: UnsafeMutableRawPointer?
) -> Bool {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer?) -> Bool
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel), arg1)
}

// MARK: - Returns numeric

/// Send: (target, sel) -> UInt64 — for count, length, hash, etc.
@_cdecl("aw_common_msg_uint")
public func msgUInt(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>
) -> UInt64 {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> UInt64
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
}

/// Send: (target, sel) -> Int64
@_cdecl("aw_common_msg_int")
public func msgInt(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>
) -> Int64 {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Int64
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
}

/// Send: (target, sel) -> Double — for doubleValue, etc.
@_cdecl("aw_common_msg_dbl")
public func msgDouble(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>
) -> Double {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Double
    return unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
}

// MARK: - Returns struct (written to output buffer)
// On arm64, objc_msgSend returns small structs in registers. The caller
// provides a buffer of the appropriate size (use aw_common_sizeof_* to query).

/// Send: (target, sel) -> CGRect, written to out buffer.
@_cdecl("aw_common_msg_rect")
public func msgRect(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ out: UnsafeMutableRawPointer
) {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> CGRect
    let result = unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
    out.storeBytes(of: result, as: CGRect.self)
}

/// Send: (target, sel) -> CGPoint, written to out buffer.
@_cdecl("aw_common_msg_point")
public func msgPoint(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ out: UnsafeMutableRawPointer
) {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> CGPoint
    let result = unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
    out.storeBytes(of: result, as: CGPoint.self)
}

/// Send: (target, sel) -> CGSize, written to out buffer.
@_cdecl("aw_common_msg_size")
public func msgSize(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ out: UnsafeMutableRawPointer
) {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> CGSize
    let result = unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
    out.storeBytes(of: result, as: CGSize.self)
}

/// Send: (target, sel) -> NSRange, written to out buffer.
@_cdecl("aw_common_msg_range")
public func msgRange(
    _ target: UnsafeMutableRawPointer,
    _ sel: UnsafePointer<CChar>,
    _ out: UnsafeMutableRawPointer
) {
    typealias F = @convention(c) (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> NSRange
    let result = unsafeBitCast(_msgSendPtr, to: F.self)(target, makeSelector(sel))
    out.storeBytes(of: result, as: NSRange.self)
}
