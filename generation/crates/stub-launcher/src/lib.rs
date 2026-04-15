//! Swift stub launcher generator for TCC-compatible macOS app bundles.
//!
//! Generates and compiles per-app Swift stub binaries that `execv` into a language
//! runtime. Each stub has a unique CDHash, allowing macOS TCC (Transparency, Consent,
//! Control) to grant permissions per-app rather than per-runtime binary.
//!
//! # Usage
//!
//! ```no_run
//! use apianyware_macos_stub_launcher::{StubConfig, create_app_bundle};
//! use std::path::Path;
//!
//! let config = StubConfig {
//!     app_name: "Counter".into(),
//!     runtime_path: "/opt/homebrew/bin/racket".into(),
//!     runtime_args: vec![],
//!     script_resource_name: "main".into(),
//!     script_resource_type: "rkt".into(),
//!     script_resource_dir: "racket-app".into(),
//!     bundle_identifier: "com.example.Counter".into(),
//! };
//!
//! let app_path = create_app_bundle(&config, Path::new("/tmp/output")).unwrap();
//! ```

mod bundle;
mod generate;

pub use bundle::{compile_stub, create_app_bundle};
pub use generate::{generate_info_plist, generate_stub_source};

/// Configuration for generating a Swift stub launcher.
#[derive(Debug, Clone)]
pub struct StubConfig {
    /// Display name of the application (e.g., "Counter").
    /// Used as the bundle executable name and in error messages.
    pub app_name: String,

    /// Absolute path to the language runtime binary (e.g., "/opt/homebrew/bin/racket").
    /// Baked into the stub at compile time.
    pub runtime_path: String,

    /// Additional arguments to pass to the runtime before the script path.
    /// For example, `["-f"]` if the runtime requires a flag before the script filename.
    /// Leave empty for runtimes that take the script path as the first argument.
    pub runtime_args: Vec<String>,

    /// Base name of the main script resource (without extension), e.g., "main".
    pub script_resource_name: String,

    /// File extension of the main script, e.g., "rkt".
    pub script_resource_type: String,

    /// Subdirectory within the bundle's `Contents/Resources/` that contains the script
    /// and its dependencies, e.g., "racket-app".
    pub script_resource_dir: String,

    /// CFBundleIdentifier for Info.plist (e.g., "com.example.Counter").
    pub bundle_identifier: String,
}

/// Errors from stub launcher operations.
#[derive(Debug, thiserror::Error)]
pub enum StubError {
    /// The Swift compiler (`swiftc`) was not found on the system.
    #[error("swiftc not found: {0}")]
    CompilerNotFound(#[source] std::io::Error),

    /// The Swift compiler exited with a non-zero status.
    #[error("swift compilation failed:\n{stderr}")]
    CompilationFailed {
        /// Compiler error output.
        stderr: String,
    },

    /// An I/O error occurred during file or directory operations.
    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),
}
