//! Annotation schema for semantic method classification.
//!
//! Annotations describe how Cocoa APIs behave at runtime — block invocation
//! styles, parameter ownership, threading constraints, and error patterns.
//! They are produced by heuristic analysis and LLM classification, then
//! merged in the annotate step.

use serde::{Deserialize, Serialize};

/// Annotations for an entire framework, keyed by class name and selector.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FrameworkAnnotations {
    /// Framework name (e.g., `"Foundation"`, `"AppKit"`).
    pub framework: String,
    /// Per-class method annotations.
    pub classes: Vec<ClassAnnotations>,
}

/// Annotations for all methods/properties of a single class.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ClassAnnotations {
    /// Class name (e.g., `"NSString"`).
    pub class_name: String,
    /// Per-method annotations.
    pub methods: Vec<MethodAnnotation>,
}

/// Annotations for a single method or property.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MethodAnnotation {
    /// Selector name (e.g., `"initWithString:"`, `"setDelegate:"`).
    pub selector: String,

    /// Whether this is an instance method (`true`) or class method (`false`).
    pub is_instance: bool,

    /// Per-parameter ownership annotations.
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub parameter_ownership: Vec<ParamOwnership>,

    /// Block invocation style for block-typed parameters.
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub block_parameters: Vec<BlockParamAnnotation>,

    /// Threading constraints for this method.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub threading: Option<ThreadingConstraint>,

    /// Error handling pattern for this method.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub error_pattern: Option<ErrorPattern>,

    /// Where this annotation came from.
    pub source: AnnotationSource,
}

/// Ownership kind for a method parameter.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ParamOwnership {
    /// Zero-based parameter index.
    pub param_index: usize,
    /// How the receiver treats this parameter's reference.
    pub ownership: OwnershipKind,
}

/// How a receiver treats a parameter's reference.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum OwnershipKind {
    /// Receiver retains (strong reference). Default for most object params.
    Strong,
    /// Receiver does NOT retain. Caller must keep the object alive.
    /// Common for delegates and data sources.
    Weak,
    /// Receiver copies the value. Common for block params and strings.
    Copy,
    /// Raw pointer with no ownership transfer. Rare, only for C-level APIs.
    UnsafeUnretained,
}

/// Block parameter invocation style annotation.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BlockParamAnnotation {
    /// Zero-based parameter index of the block parameter.
    pub param_index: usize,
    /// How the block is invoked by the receiver.
    pub invocation: BlockInvocationStyle,
}

/// How a Cocoa API invokes a block parameter.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum BlockInvocationStyle {
    /// Block is invoked synchronously during the method call and NOT copied.
    /// Caller must free the block explicitly after the method returns.
    Synchronous,
    /// Block is copied (`Block_copy`) for later async invocation.
    /// The ObjC runtime manages the block lifecycle via copy/dispose helpers.
    AsyncCopied,
    /// Block is stored by the receiver for repeated invocation (e.g., observers).
    /// Similar to `AsyncCopied` but may be called multiple times.
    Stored,
}

/// Threading constraints for a method.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ThreadingConstraint {
    /// Must be called on the main thread only.
    MainThreadOnly,
    /// Safe to call from any thread.
    AnyThread,
}

/// Error handling pattern for a method.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ErrorPattern {
    /// Last parameter is `NSError**` out-param. Method returns nil/NO on failure.
    ErrorOutParam,
    /// Method throws an ObjC exception on failure (rare in modern Cocoa).
    ThrowsException,
    /// Returns nil on failure (no error object).
    NilOnFailure,
}

/// Where an annotation came from.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum AnnotationSource {
    /// Derived from naming heuristics alone.
    Heuristic,
    /// Derived from LLM analysis of Apple documentation.
    Llm,
    /// Human-reviewed resolution of a heuristic/LLM disagreement.
    HumanReviewed,
}

/// Override file: human-reviewed resolutions stored separately for merging.
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct AnnotationOverrides {
    /// Framework name.
    pub framework: String,
    /// Per-selector overrides.
    pub overrides: Vec<AnnotationOverride>,
}

/// A single human override for a method annotation.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AnnotationOverride {
    /// Class name.
    pub class_name: String,
    /// Selector name.
    pub selector: String,
    /// The field being overridden (e.g., `"block_parameters"`, `"threading"`).
    pub field: String,
    /// The overridden value (serialized as the appropriate type).
    pub value: serde_json::Value,
    /// Reason for the override.
    pub reason: String,
}
