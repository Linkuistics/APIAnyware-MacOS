Delegate int/long trampolines, CF_ENUM fix, struct globals, libdispatch pointer types

Add 'int/'long delegate return kinds with Swift Int32/Int64 trampolines and
matching Racket FFI dispatch; migrate numberOfRowsInTableView: from the
pointer-smuggle workaround to a clean 'long return. Fix CF_ENUM forward-
declaration shadowing (is_definition() guard) and unsigned enum extraction
(u64 component for unsigned-backed types); Foundation enums grow 212→1129.
Emit ffi-obj-ref for struct-typed C globals vs get-ffi-obj which reads a
struct field; map libdispatch _id params/returns to _pointer since no ObjC
wrapper classes exist. Expand runtime load harness to 10 frameworks and 15
library load checks including dynamic-class.rkt and the new libdispatch files.
