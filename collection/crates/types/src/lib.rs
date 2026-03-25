//! Shared IR types, annotation schema, and checkpoint file format.
//!
//! This crate defines the data structures that flow through the entire pipeline:
//! Collection → Analysis → Generation. All checkpoint JSON files serialize
//! and deserialize using these types.
