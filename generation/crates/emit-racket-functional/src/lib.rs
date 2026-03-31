//! Racket functional code generation — plain procedures with explicit objc_msgSend.
//!
//! Stub: not yet implemented. See `generation/crates/emit-racket-oo/` for the
//! OO emitter that this will be modelled on.

use std::io;
use std::path::Path;

use apianyware_macos_emit::binding_style::{
    BindingStyle, EmitResult, LanguageEmitter, LanguageInfo,
};
use apianyware_macos_types::ir::Framework;

/// Language metadata for the Racket functional emitter.
pub const RACKET_FUNCTIONAL_LANGUAGE_INFO: LanguageInfo = LanguageInfo {
    id: "racket-functional",
    display_name: "Racket Functional",
    supported_styles: &[BindingStyle::Functional],
    default_style: BindingStyle::Functional,
};

/// Racket functional emitter (stub).
pub struct RacketFunctionalEmitter;

impl LanguageEmitter for RacketFunctionalEmitter {
    fn language_info(&self) -> &LanguageInfo {
        &RACKET_FUNCTIONAL_LANGUAGE_INFO
    }

    fn emit_framework(
        &self,
        _framework: &Framework,
        _output_dir: &Path,
        _style: BindingStyle,
    ) -> io::Result<EmitResult> {
        // Stub: returns empty result
        Ok(EmitResult {
            files_written: 0,
            classes_emitted: 0,
            protocols_emitted: 0,
            enums_emitted: 0,
            functions_emitted: 0,
            constants_emitted: 0,
        })
    }
}
