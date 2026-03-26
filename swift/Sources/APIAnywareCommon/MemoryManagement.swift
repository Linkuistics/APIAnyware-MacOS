// MemoryManagement.swift — ObjC reference counting: retain and release.
// Exports: aw_common_retain, aw_common_release

/// Retain an ObjC object (+1 ref count). Returns the same pointer for chaining.
@_cdecl("aw_common_retain")
public func retainObject(_ object: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    _ = Unmanaged<AnyObject>.fromOpaque(object).retain()
    return object
}

/// Release an ObjC object (-1 ref count). The pointer may become invalid.
@_cdecl("aw_common_release")
public func releaseObject(_ object: UnsafeMutableRawPointer) {
    Unmanaged<AnyObject>.fromOpaque(object).release()
}
