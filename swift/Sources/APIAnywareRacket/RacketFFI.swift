// RacketFFI.swift — Racket-specific FFI helpers.
//
// The APIAnywareRacket module provides:
//   - BlockBridge:    ObjC block creation from C function pointers
//   - DelegateBridge: Dynamic ObjC class creation with per-instance dispatch
//   - GCPrevention:   Reference registry preventing GC collection of live callbacks
//
// All exports use @_cdecl with `aw_racket_` prefix.
// The Common module's `aw_common_msg_*` variants handle objc_msgSend dispatch.

import APIAnywareCommon
