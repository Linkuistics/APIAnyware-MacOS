//! Racket constants file code generation.

use apianyware_macos_emit::code_writer::CodeWriter;
use apianyware_macos_emit::write_line;

/// Generate a Racket constants file for a framework.
pub fn generate_constants_file(framework: &str) -> String {
    let mut w = CodeWriter::new();
    w.line("#lang racket/base");
    write_line!(w, ";; Generated constant declarations for {}", framework);
    w.blank_line();
    w.line("(require ffi/unsafe ffi/unsafe/objc)");
    w.blank_line();
    w.line("(provide (all-defined-out))");
    w.blank_line();
    w.line(";; Note: constants are ObjC object pointers loaded at runtime.");
    w.line(";; Most are NSString constants (notification names, etc.).");
    w.line(";; Accessing them requires linking to the framework.");

    w.finish()
}
